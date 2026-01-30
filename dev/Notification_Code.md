ขออภัยในความสับสน ขออนุญาตจัดโครงสร้างระบบ Notification ใหม่อีกครั้งโดยอ้างอิงจากไฟล์ entities ที่มีอยู่

# ระบบ Notification System - ออกแบบใหม่ตามโครงสร้างที่มีอยู่

## 1. โครงสร้าง Data Flow Diagram (ปรับปรุงใหม่)

```
┌──────────────┐    ┌──────────────┐    ┌──────────────────┐
│   MQTT       │───▶│  Sensor Data │───▶│  Check Condition │
│   Broker     │    │   Entity     │    │    Service       │
└──────────────┘    └──────────────┘    └─────────┬────────┘
                                                   │
                                    ┌──────────────▼──────────────┐
                                    │    Notification Service     │
                                    ├──────────────────────────────┤
                                    │ 1. สร้าง Notification Log   │
                                    │ 2. ค้นหา Channel Config     │
                                    │ 3. ดึง Template             │
                                    │ 4. เรียก Channel Handler    │
                                    └──────────────┬──────────────┘
                                                   │
                    ┌──────────────────────────────▼──────────────────────────────┐
                    │                       Channel Handlers                      │
                    ├──────────────┬──────────────┬──────────────┬───────────────┤
                    │     Line     │   Discord    │   Telegram   │      SMS      │
                    └──────────────┴──────────────┴──────────────┴───────────────┘
                                                   │
                                    ┌──────────────▼──────────────┐
                                    │   WebSocket Gateway         │
                                    │  Real-time Notifications    │
                                    └──────────────────────────────┘
```

## 2. แก้ไขและเพิ่ม Entities ที่จำเป็น

```typescript:file name: notification.entity.ts
[file content begin]
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn, Index } from 'typeorm';
import { Device } from '@src/modules/settings/entities/device.entity';
import { NotificationType } from './sd-notification-type.entity';
import { NotificationChannel } from './sd-notification-channel.entity';

@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'device_id', nullable: true })
  deviceId: number;

  @ManyToOne(() => Device, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @Index()
  @Column({ name: 'notification_type_id' })
  notificationTypeId: number;

  @ManyToOne(() => NotificationType, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'notification_type_id' })
  notificationType: NotificationType;

  @Index()
  @Column({ name: 'channel_id', nullable: true })
  channelId: number;

  @ManyToOne(() => NotificationChannel, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'channel_id' })
  channel: NotificationChannel;

  @Column({ type: 'text' })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({
    type: 'enum',
    enum: ['normal', 'warning', 'recovery_warning', 'alarm', 'recovery_alarm'],
    default: 'normal'
  })
  status: string;

  @Column({
    type: 'enum',
    enum: ['info', 'warning', 'critical', 'emergency'],
    default: 'info'
  })
  severity: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  value: number;

  @Column({ name: 'threshold_min', type: 'decimal', precision: 10, scale: 2, nullable: true })
  thresholdMin: number;

  @Column({ name: 'threshold_max', type: 'decimal', precision: 10, scale: 2, nullable: true })
  thresholdMax: number;

  @Column({ type: 'jsonb', nullable: true })
  metadata: any;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @Column({ name: 'is_acknowledged', default: false })
  isAcknowledged: boolean;

  @Column({ name: 'acknowledged_by', length: 200, nullable: true })
  acknowledgedBy: string;

  @Column({ name: 'acknowledged_at', nullable: true })
  acknowledgedAt: Date;

  @Column({ name: 'resolved_at', nullable: true })
  resolvedAt: Date;

  @Column({ name: 'last_notified_at', nullable: true })
  lastNotifiedAt: Date;

  @Column({ name: 'next_notify_at', nullable: true })
  nextNotifyAt: Date;

  @Column({ name: 'repeat_interval_minutes', default: 10 })
  repeatIntervalMinutes: number;

  @Column({ name: 'repeat_count', default: 0 })
  repeatCount: number;

  @Column({ name: 'max_repeat_count', default: 5 })
  maxRepeatCount: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
[file content end]
```

## 3. แก้ไข Notification Services

```typescript:file name: notification.service.ts
[file content begin]
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between, LessThanOrEqual, MoreThanOrEqual } from 'typeorm';
import { Notification } from './notification.entity';
import { NotificationLog } from './notification-log.entity';
import { SensorData } from './sensor-data.entity';
import { NotificationCondition } from './notification-condition.entity';
import { NotificationType } from './sd-notification-type.entity';
import { DeviceNotificationConfig } from './device-notification-config.entity';
import { ChannelTemplate } from './channel-template.entity';
import { RedisCacheService } from './redis-cache.service';
import { NotificationQueueService } from './notification-queue.service';
import { WebsocketService } from './websocket/websocket.service';

@Injectable()
export class NotificationService {
  private readonly logger = new Logger(NotificationService.name);

  constructor(
    @InjectRepository(Notification)
    private notificationRepository: Repository<Notification>,
    @InjectRepository(NotificationLog)
    private notificationLogRepository: Repository<NotificationLog>,
    @InjectRepository(SensorData)
    private sensorDataRepository: Repository<SensorData>,
    @InjectRepository(NotificationCondition)
    private conditionRepository: Repository<NotificationCondition>,
    @InjectRepository(NotificationType)
    private notificationTypeRepository: Repository<NotificationType>,
    @InjectRepository(DeviceNotificationConfig)
    private deviceConfigRepository: Repository<DeviceNotificationConfig>,
    @InjectRepository(ChannelTemplate)
    private templateRepository: Repository<ChannelTemplate>,
    private redisCacheService: RedisCacheService,
    private notificationQueueService: NotificationQueueService,
    private websocketService: WebsocketService
  ) {}

  async processSensorData(deviceId: number, value: number, rawData?: any): Promise<void> {
    try {
      // บันทึกข้อมูลเซ็นเซอร์
      const sensorData = this.sensorDataRepository.create({
        deviceId,
        value,
        rawData,
        timestamp: new Date()
      });
      await this.sensorDataRepository.save(sensorData);

      // ค้นหาเงื่อนไขการแจ้งเตือนที่เกี่ยวข้อง
      const conditions = await this.conditionRepository.find({
        where: {
          deviceId,
          isActive: true
        },
        relations: ['notificationType']
      });

      // ตรวจสอบแต่ละเงื่อนไข
      for (const condition of conditions) {
        await this.checkCondition(condition, value, sensorData);
      }

    } catch (error) {
      this.logger.error(`Error processing sensor data for device ${deviceId}:`, error);
    }
  }

  private async checkCondition(condition: NotificationCondition, value: number, sensorData: SensorData): Promise<void> {
    const { minValue, maxValue, conditionOperator, notificationType } = condition;
    let shouldNotify = false;
    let status = 'normal';
    let severity = 'info';

    // ตรวจสอบเงื่อนไขตาม operator
    switch (conditionOperator) {
      case 'between':
        shouldNotify = value >= minValue && value <= maxValue;
        break;
      case 'greater':
        shouldNotify = value > minValue;
        break;
      case 'less':
        shouldNotify = value < maxValue;
        break;
      case 'equal':
        shouldNotify = value === minValue;
        break;
      default:
        shouldNotify = false;
    }

    if (shouldNotify) {
      // กำหนดสถานะและความรุนแรงตามค่า
      if (value >= (maxValue || 0) * 0.9) {
        status = 'alarm';
        severity = 'critical';
      } else if (value >= (maxValue || 0) * 0.7) {
        status = 'warning';
        severity = 'warning';
      }

      // ตรวจสอบ cooldown
      const cooldownKey = `notification:${condition.deviceId}:${condition.notificationTypeId}:cooldown`;
      const isInCooldown = await this.redisCacheService.exists(cooldownKey);

      if (!isInCooldown) {
        await this.createNotification(condition, value, status, severity, sensorData);
        
        // ตั้งค่า cooldown
        await this.redisCacheService.set(
          cooldownKey,
          '1',
          notificationType.cooldownMinutes * 60
        );
      } else {
        this.logger.log(`Notification in cooldown for device ${condition.deviceId}, type ${condition.notificationTypeId}`);
      }
    } else {
      // ตรวจสอบการกู้คืนสถานะ
      await this.checkRecovery(condition, value, sensorData);
    }
  }

  private async createNotification(
    condition: NotificationCondition, 
    value: number, 
    status: string, 
    severity: string,
    sensorData: SensorData
  ): Promise<void> {
    try {
      // ค้นหา device config
      const deviceConfigs = await this.deviceConfigRepository.find({
        where: {
          deviceId: condition.deviceId,
          notificationTypeId: condition.notificationTypeId,
          isActive: true
        },
        relations: ['channel', 'notificationType']
      });

      if (deviceConfigs.length === 0) {
        this.logger.warn(`No active notification config found for device ${condition.deviceId}`);
        return;
      }

      // สร้าง notification record
      const notification = this.notificationRepository.create({
        deviceId: condition.deviceId,
        notificationTypeId: condition.notificationTypeId,
        title: `${condition.notificationType.name} Alert`,
        message: this.generateMessage(condition, value, status),
        status,
        severity,
        value,
        thresholdMin: condition.minValue,
        thresholdMax: condition.maxValue,
        metadata: {
          sensorDataId: sensorData.id,
          conditionId: condition.id
        },
        lastNotifiedAt: new Date(),
        nextNotifyAt: this.calculateNextNotifyTime(condition.notificationType.cooldownMinutes)
      });

      await this.notificationRepository.save(notification);

      // ส่งผ่านช่องทางต่างๆ
      for (const config of deviceConfigs) {
        await this.sendNotificationThroughChannel(notification, config, sensorData);
      }

      // ส่งผ่าน WebSocket
      this.websocketService.sendNotification({
        id: notification.id,
        deviceId: notification.deviceId,
        title: notification.title,
        message: notification.message,
        status: notification.status,
        severity: notification.severity,
        value: notification.value,
        timestamp: new Date()
      });

      this.logger.log(`Notification created for device ${condition.deviceId}: ${status}`);

    } catch (error) {
      this.logger.error('Error creating notification:', error);
    }
  }

  private generateMessage(condition: NotificationCondition, value: number, status: string): string {
    const deviceName = condition.device?.name || `Device ${condition.deviceId}`;
    const typeName = condition.notificationType?.name || 'Unknown';
    
    return `${deviceName} - ${typeName}: ${status.toUpperCase()}\n` +
           `Current Value: ${value}\n` +
           `Threshold: ${condition.minValue} - ${condition.maxValue}\n` +
           `Time: ${new Date().toLocaleString()}`;
  }

  private calculateNextNotifyTime(cooldownMinutes: number): Date {
    const nextTime = new Date();
    nextTime.setMinutes(nextTime.getMinutes() + cooldownMinutes);
    return nextTime;
  }

  private async sendNotificationThroughChannel(
    notification: Notification, 
    config: DeviceNotificationConfig, 
    sensorData: SensorData
  ): Promise<void> {
    try {
      // ค้นหา template
      const template = await this.templateRepository.findOne({
        where: {
          channelId: config.channel.id,
          notificationTypeId: config.notificationTypeId,
          isActive: true
        }
      });

      if (!template) {
        this.logger.warn(`No template found for channel ${config.channel.name} and type ${config.notificationType.name}`);
        return;
      }

      // สร้าง message จาก template
      const message = this.renderTemplate(template.template, {
        notification,
        device: notification.device,
        sensorData,
        config,
        timestamp: new Date()
      });

      // สร้าง log record
      const notificationLog = this.notificationLogRepository.create({
        deviceId: notification.deviceId,
        notificationTypeId: notification.notificationTypeId,
        notificationChannelId: config.channel.id,
        templateId: template.id,
        message,
        status: 'pending',
        recipient: config.config?.recipient || null
      });

      await this.notificationLogRepository.save(notificationLog);

      // เพิ่มใน queue
      await this.notificationQueueService.addToQueue({
        notificationId: notification.id,
        logId: notificationLog.id,
        channelId: config.channel.id,
        channelName: config.channel.name,
        message,
        config: config.config,
        recipient: notificationLog.recipient,
        priority: condition.priority || 1
      });

    } catch (error) {
      this.logger.error(`Error preparing notification for channel ${config.channel.name}:`, error);
    }
  }

  private renderTemplate(template: string, data: any): string {
    let rendered = template;
    
    // แทนที่ตัวแปรใน template
    rendered = rendered.replace(/\{\{(\w+)\}\}/g, (match, key) => {
      return data[key] || match;
    });

    // แทนที่ nested properties
    rendered = rendered.replace(/\{\{(\w+)\.(\w+)\}\}/g, (match, objKey, propKey) => {
      return data[objKey]?.[propKey] || match;
    });

    return rendered;
  }

  private async checkRecovery(
    condition: NotificationCondition, 
    value: number, 
    sensorData: SensorData
  ): Promise<void> {
    // ค้นหา notification ที่ยังไม่ resolved
    const activeNotification = await this.notificationRepository.findOne({
      where: {
        deviceId: condition.deviceId,
        notificationTypeId: condition.notificationTypeId,
        status: In(['warning', 'alarm']),
        resolvedAt: null
      },
      order: { createdAt: 'DESC' }
    });

    if (activeNotification) {
      // ตรวจสอบว่าค่ากลับสู่ปกติแล้วหรือไม่
      const isRecovered = value < (condition.minValue || 0) * 1.1 && value > (condition.maxValue || 0) * 0.9;

      if (isRecovered) {
        // อัพเดทสถานะเป็น recovery
        activeNotification.status = activeNotification.status === 'alarm' ? 'recovery_alarm' : 'recovery_warning';
        activeNotification.resolvedAt = new Date();
        await this.notificationRepository.save(activeNotification);

        // ส่ง recovery notification
        await this.createRecoveryNotification(condition, value, activeNotification, sensorData);
      }
    }
  }

  private async createRecoveryNotification(
    condition: NotificationCondition,
    value: number,
    originalNotification: Notification,
    sensorData: SensorData
  ): Promise<void> {
    const recoveryNotification = this.notificationRepository.create({
      deviceId: condition.deviceId,
      notificationTypeId: condition.notificationTypeId,
      title: `${condition.notificationType.name} Recovery`,
      message: `Device ${condition.device?.name} has recovered from ${originalNotification.status}\n` +
               `Current Value: ${value}\n` +
               `Time: ${new Date().toLocaleString()}`,
      status: originalNotification.status === 'alarm' ? 'recovery_alarm' : 'recovery_warning',
      severity: 'info',
      value,
      metadata: {
        originalNotificationId: originalNotification.id,
        sensorDataId: sensorData.id
      }
    });

    await this.notificationRepository.save(recoveryNotification);

    // ส่งผ่าน WebSocket
    this.websocketService.sendNotification({
      id: recoveryNotification.id,
      deviceId: recoveryNotification.deviceId,
      title: recoveryNotification.title,
      message: recoveryNotification.message,
      status: recoveryNotification.status,
      severity: recoveryNotification.severity,
      value: recoveryNotification.value,
      timestamp: new Date(),
      isRecovery: true
    });
  }

  async acknowledgeNotification(notificationId: string, userId: string, userName: string): Promise<Notification> {
    const notification = await this.notificationRepository.findOne({
      where: { id: notificationId }
    });

    if (!notification) {
      throw new Error(`Notification ${notificationId} not found`);
    }

    notification.isAcknowledged = true;
    notification.acknowledgedBy = userName;
    notification.acknowledgedAt = new Date();

    return await this.notificationRepository.save(notification);
  }

  async getDeviceNotifications(deviceId: number, options: {
    startDate?: Date;
    endDate?: Date;
    status?: string;
    severity?: string;
    limit?: number;
    offset?: number;
  } = {}): Promise<{ notifications: Notification[]; total: number }> {
    const { startDate, endDate, status, severity, limit = 50, offset = 0 } = options;

    const query = this.notificationRepository.createQueryBuilder('notification')
      .where('notification.deviceId = :deviceId', { deviceId })
      .orderBy('notification.createdAt', 'DESC');

    if (startDate) {
      query.andWhere('notification.createdAt >= :startDate', { startDate });
    }

    if (endDate) {
      query.andWhere('notification.createdAt <= :endDate', { endDate });
    }

    if (status) {
      query.andWhere('notification.status = :status', { status });
    }

    if (severity) {
      query.andWhere('notification.severity = :severity', { severity });
    }

    const total = await query.getCount();
    const notifications = await query
      .skip(offset)
      .take(limit)
      .leftJoinAndSelect('notification.notificationType', 'notificationType')
      .leftJoinAndSelect('notification.device', 'device')
      .getMany();

    return { notifications, total };
  }

  async getNotificationStats(deviceId?: number): Promise<any> {
    const query = this.notificationRepository.createQueryBuilder('notification')
      .select([
        'notification.status',
        'notification.severity',
        'COUNT(*) as count',
        'DATE(notification.createdAt) as date'
      ])
      .groupBy('notification.status, notification.severity, DATE(notification.createdAt)')
      .orderBy('date', 'DESC');

    if (deviceId) {
      query.where('notification.deviceId = :deviceId', { deviceId });
    }

    const stats = await query.getRawMany();

    // จัดกลุ่มข้อมูล
    const result = {
      byStatus: {},
      bySeverity: {},
      byDate: {},
      total: stats.length
    };

    stats.forEach(stat => {
      // จัดกลุ่มตามสถานะ
      if (!result.byStatus[stat.notification_status]) {
        result.byStatus[stat.notification_status] = 0;
      }
      result.byStatus[stat.notification_status] += parseInt(stat.count);

      // จัดกลุ่มตามความรุนแรง
      if (!result.bySeverity[stat.notification_severity]) {
        result.bySeverity[stat.notification_severity] = 0;
      }
      result.bySeverity[stat.notification_severity] += parseInt(stat.count);

      // จัดกลุ่มตามวันที่
      const date = stat.date.toISOString().split('T')[0];
      if (!result.byDate[date]) {
        result.byDate[date] = 0;
      }
      result.byDate[date] += parseInt(stat.count);
    });

    return result;
  }

  async cleanupOldNotifications(days: number = 30): Promise<number> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const result = await this.notificationRepository.createQueryBuilder()
      .delete()
      .where('createdAt < :cutoffDate', { cutoffDate })
      .andWhere('status IN (:...statuses)', { 
        statuses: ['normal', 'recovery_warning', 'recovery_alarm'] 
      })
      .andWhere('is_acknowledged = :acknowledged', { acknowledged: true })
      .execute();

    return result.affected || 0;
  }
}
[file content end]
```

## 4. เพิ่ม WebSocket Service

```typescript:file name: websocket.service.ts
[file content begin]
import { Injectable, Logger } from '@nestjs/common';
import { WebSocketGateway, WebSocketServer, SubscribeMessage, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@WebSocketGateway({
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
    credentials: true
  },
  namespace: '/notifications'
})
@Injectable()
export class WebsocketService implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(WebsocketService.name);
  private readonly connectedClients = new Map<string, Socket>();

  handleConnection(client: Socket) {
    const deviceId = client.handshake.query.deviceId as string;
    const userId = client.handshake.query.userId as string;
    
    if (deviceId) {
      client.join(`device:${deviceId}`);
      this.logger.log(`Client ${client.id} joined device room: ${deviceId}`);
    }
    
    if (userId) {
      client.join(`user:${userId}`);
      this.logger.log(`Client ${client.id} joined user room: ${userId}`);
    }

    // Join general notifications room
    client.join('notifications');
    
    this.connectedClients.set(client.id, client);
    this.logger.log(`Client connected: ${client.id}, Total: ${this.connectedClients.size}`);
  }

  handleDisconnect(client: Socket) {
    this.connectedClients.delete(client.id);
    this.logger.log(`Client disconnected: ${client.id}, Total: ${this.connectedClients.size}`);
  }

  @SubscribeMessage('subscribeDevice')
  handleSubscribeDevice(client: Socket, deviceId: string): void {
    client.join(`device:${deviceId}`);
    this.logger.log(`Client ${client.id} subscribed to device: ${deviceId}`);
    
    client.emit('subscribed', {
      deviceId,
      message: `Subscribed to device ${deviceId} notifications`
    });
  }

  @SubscribeMessage('unsubscribeDevice')
  handleUnsubscribeDevice(client: Socket, deviceId: string): void {
    client.leave(`device:${deviceId}`);
    this.logger.log(`Client ${client.id} unsubscribed from device: ${deviceId}`);
  }

  @SubscribeMessage('acknowledgeNotification')
  handleAcknowledgeNotification(client: Socket, data: { notificationId: string; userId: string }): void {
    this.server.to('notifications').emit('notificationAcknowledged', {
      ...data,
      acknowledgedAt: new Date()
    });
  }

  sendNotification(data: any): void {
    // Send to specific device room
    if (data.deviceId) {
      this.server.to(`device:${data.deviceId}`).emit('notification', data);
    }
    
    // Send to general notifications room
    this.server.to('notifications').emit('notification', data);
    
    this.logger.log(`Notification sent: ${data.id}`);
  }

  sendDeviceStatusUpdate(deviceId: number, status: any): void {
    this.server.to(`device:${deviceId}`).emit('deviceStatusUpdate', {
      deviceId,
      status,
      timestamp: new Date()
    });
  }

  sendSystemAlert(message: string, severity: string = 'warning'): void {
    this.server.to('notifications').emit('systemAlert', {
      message,
      severity,
      timestamp: new Date()
    });
  }

  getConnectedClientsCount(): number {
    return this.connectedClients.size;
  }

  getSubscribedDevices(): string[] {
    const devices = new Set<string>();
    
    for (const [room] of this.server.sockets.adapter.rooms) {
      if (room.startsWith('device:')) {
        devices.add(room.replace('device:', ''));
      }
    }
    
    return Array.from(devices);
  }
}
[file content end]
```

## 5. แก้ไข Notification Module

```typescript:file name: notification.module.ts
[file content begin]
import { forwardRef, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BullModule } from '@nestjs/bull';
import { ScheduleModule } from '@nestjs/schedule';

/**** Entities ****/
import { Notification } from './entities/notification.entity';
import { NotificationLog } from './entities/notification-log.entity';
import { SensorData } from './entities/sensor-data.entity';
import { NotificationCondition } from './entities/notification-condition.entity';
import { DeviceNotificationConfig } from './entities/device-notification-config.entity';
import { ChannelTemplate } from './entities/channel-template.entity';
import { DeviceGroup } from './entities/device-group.entity';
import { DeviceGroupMember } from './entities/sd-device-group-member.entity';
import { GroupNotificationConfig } from './entities/sd-group-notification-config.entity';
import { DeviceSchedule } from './entities/device-schedule.entity';
import { DeviceStatusHistory } from './entities/device-status-history.entity';
import { ReportData } from './entities/report-data.entity';
import { NotificationType } from './entities/sd-notification-type.entity';
import { NotificationChannel } from './entities/sd-notification-channel.entity';

/**** Services ****/
import { NotificationService } from './services/notification/notification.service';
import { NotificationQueueService } from './services/notification-queue/notification-queue.service';
import { NotificationCheckerService } from './services/notification-checker/notification-checker.service';
import { NotificationSenderService } from './services/notification-sender/notification-sender.service';
import { MqttHandlerService } from './services/mqtt-handler/mqtt-handler.service';
import { RedisCacheService } from './services/redis-cache/redis-cache.service';
import { WebsocketService } from './services/websocket/websocket.service';
import { LineService } from './services/channels/line/line.service';
import { DiscordService } from './services/channels/discord/discord.service';
import { TelegramService } from './services/channels/telegram/telegram.service';
import { SmsService } from './services/channels/sms/sms.service';
import { DashboardService } from './services/channels/dashboard/dashboard.service';
import { DeviceControlService } from './services/channels/device-control/device-control.service';
import { ReportService } from './services/report/report.service';
import { ScheduleService } from './services/schedule/schedule.service';

/**** Controllers ****/
import { NotificationController } from './controllers/notification/notification.controller';
import { NotificationHistoryController } from './controllers/notification-history/notification-history.controller';
import { NotificationSettingController } from './controllers/notification-setting/notification-setting.controller';
import { ReportController } from './controllers/report/report.controller';

/**** Gateways ****/
import { NotificationGateway } from './gateways/notification/notification.gateway';

import { PassportModule } from '@nestjs/passport';
import { AuthModule } from '@src/modules/auth/auth.module';
import { UsersModule } from '@src/modules/users/users.module';

@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forFeature([
      Notification,
      NotificationLog,
      SensorData,
      NotificationCondition,
      DeviceNotificationConfig,
      ChannelTemplate,
      DeviceGroup,
      DeviceGroupMember,
      GroupNotificationConfig,
      DeviceSchedule,
      DeviceStatusHistory,
      ReportData,
      NotificationType,
      NotificationChannel
    ]),
    BullModule.forRoot({
      redis: {
        host: process.env.REDIS_HOST || 'localhost',
        port: parseInt(process.env.REDIS_PORT || '6379'),
        password: process.env.REDIS_PASSWORD,
      },
    }),
    BullModule.registerQueue({
      name: 'notifications',
    }),
    ScheduleModule.forRoot(),
    forwardRef(() => AuthModule),
    forwardRef(() => UsersModule),
    PassportModule.register({ defaultStrategy: 'jwt' }),
  ],
  controllers: [
    NotificationController,
    NotificationSettingController,
    NotificationHistoryController,
    ReportController
  ],
  providers: [
    NotificationService,
    NotificationQueueService,
    NotificationCheckerService,
    NotificationSenderService,
    MqttHandlerService,
    RedisCacheService,
    WebsocketService,
    LineService,
    DiscordService,
    TelegramService,
    SmsService,
    DashboardService,
    DeviceControlService,
    ReportService,
    ScheduleService,
    NotificationGateway,
  ],
  exports: [
    NotificationService,
    NotificationQueueService,
    WebsocketService,
    TypeOrmModule.forFeature([
      Notification,
      NotificationLog,
      SensorData,
      NotificationCondition,
      NotificationType,
      NotificationChannel
    ])
  ],
})
export class NotificationModule {}
[file content end]
```

## 6. เพิ่ม Report Service สำหรับการรายงาน

```typescript:file name: report.service.ts
[file content begin]
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { ReportData } from '../entities/report-data.entity';
import { Notification } from '../entities/notification.entity';
import { NotificationLog } from '../entities/notification-log.entity';
import { SensorData } from '../entities/sensor-data.entity';
import { NotificationType } from '../entities/sd-notification-type.entity';
import { NotificationChannel } from '../entities/sd-notification-channel.entity';

@Injectable()
export class ReportService {
  private readonly logger = new Logger(ReportService.name);

  constructor(
    @InjectRepository(ReportData)
    private reportDataRepository: Repository<ReportData>,
    @InjectRepository(Notification)
    private notificationRepository: Repository<Notification>,
    @InjectRepository(NotificationLog)
    private notificationLogRepository: Repository<NotificationLog>,
    @InjectRepository(SensorData)
    private sensorDataRepository: Repository<SensorData>,
    @InjectRepository(NotificationType)
    private notificationTypeRepository: Repository<NotificationType>,
    @InjectRepository(NotificationChannel)
    private notificationChannelRepository: Repository<NotificationChannel>
  ) {}

  async generateDailyReport(deviceId?: number, date?: Date): Promise<ReportData> {
    const reportDate = date || new Date();
    const startDate = new Date(reportDate);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(reportDate);
    endDate.setHours(23, 59, 59, 999);

    const reportData = await this.collectReportData(startDate, endDate, deviceId);
    
    const report = this.reportDataRepository.create({
      deviceId,
      reportType: 'daily',
      data: reportData,
      periodStart: startDate,
      periodEnd: endDate,
      generatedAt: new Date()
    });

    return await this.reportDataRepository.save(report);
  }

  async generateWeeklyReport(deviceId?: number, startDate?: Date): Promise<ReportData> {
    const start = startDate || new Date();
    start.setDate(start.getDate() - start.getDay()); // Start of week (Sunday)
    start.setHours(0, 0, 0, 0);
    
    const endDate = new Date(start);
    endDate.setDate(endDate.getDate() + 6); // End of week
    endDate.setHours(23, 59, 59, 999);

    const reportData = await this.collectReportData(start, endDate, deviceId);
    
    const report = this.reportDataRepository.create({
      deviceId,
      reportType: 'weekly',
      data: reportData,
      periodStart: start,
      periodEnd: endDate,
      generatedAt: new Date()
    });

    return await this.reportDataRepository.save(report);
  }

  async generateMonthlyReport(deviceId?: number, year?: number, month?: number): Promise<ReportData> {
    const now = new Date();
    const reportYear = year || now.getFullYear();
    const reportMonth = month !== undefined ? month : now.getMonth();
    
    const startDate = new Date(reportYear, reportMonth, 1);
    const endDate = new Date(reportYear, reportMonth + 1, 0);
    endDate.setHours(23, 59, 59, 999);

    const reportData = await this.collectReportData(startDate, endDate, deviceId);
    
    const report = this.reportDataRepository.create({
      deviceId,
      reportType: 'monthly',
      data: reportData,
      periodStart: startDate,
      periodEnd: endDate,
      generatedAt: new Date()
    });

    return await this.reportDataRepository.save(report);
  }

  private async collectReportData(startDate: Date, endDate: Date, deviceId?: number): Promise<any> {
    // ค้นหาข้อมูลการแจ้งเตือน
    const notifications = await this.getNotificationStatsByPeriod(startDate, endDate, deviceId);
    
    // ค้นหาข้อมูล log
    const notificationLogs = await this.getNotificationLogStatsByPeriod(startDate, endDate, deviceId);
    
    // ค้นหาข้อมูลเซ็นเซอร์
    const sensorData = await this.getSensorDataStatsByPeriod(startDate, endDate, deviceId);
    
    // สรุปสถิติ
    const summary = {
      period: { start: startDate, end: endDate },
      notifications,
      notificationLogs,
      sensorData,
      deviceId,
      generatedAt: new Date()
    };

    return summary;
  }

  private async getNotificationStatsByPeriod(startDate: Date, endDate: Date, deviceId?: number): Promise<any> {
    const query = this.notificationRepository.createQueryBuilder('notification')
      .where('notification.createdAt BETWEEN :startDate AND :endDate', { startDate, endDate })
      .leftJoinAndSelect('notification.notificationType', 'notificationType')
      .leftJoinAndSelect('notification.device', 'device');

    if (deviceId) {
      query.andWhere('notification.deviceId = :deviceId', { deviceId });
    }

    const notifications = await query.getMany();

    const stats = {
      total: notifications.length,
      byStatus: {},
      bySeverity: {},
      byType: {},
      byHour: {},
      acknowledged: 0,
      unacknowledged: 0,
      averageResponseTime: 0
    };

    let totalResponseTime = 0;
    let respondedCount = 0;

    notifications.forEach(notification => {
      // Count by status
      if (!stats.byStatus[notification.status]) {
        stats.byStatus[notification.status] = 0;
      }
      stats.byStatus[notification.status]++;

      // Count by severity
      if (!stats.bySeverity[notification.severity]) {
        stats.bySeverity[notification.severity] = 0;
      }
      stats.bySeverity[notification.severity]++;

      // Count by type
      const typeName = notification.notificationType?.name || 'Unknown';
      if (!stats.byType[typeName]) {
        stats.byType[typeName] = 0;
      }
      stats.byType[typeName]++;

      // Count by hour
      const hour = notification.createdAt.getHours();
      if (!stats.byHour[hour]) {
        stats.byHour[hour] = 0;
      }
      stats.byHour[hour]++;

      // Count acknowledged
      if (notification.isAcknowledged) {
        stats.acknowledged++;
        
        // Calculate response time if acknowledged
        if (notification.acknowledgedAt && notification.createdAt) {
          const responseTime = notification.acknowledgedAt.getTime() - notification.createdAt.getTime();
          totalResponseTime += responseTime;
          respondedCount++;
        }
      } else {
        stats.unacknowledged++;
      }
    });

    // Calculate average response time in minutes
    if (respondedCount > 0) {
      stats.averageResponseTime = Math.round((totalResponseTime / respondedCount) / (1000 * 60));
    }

    return stats;
  }

  private async getNotificationLogStatsByPeriod(startDate: Date, endDate: Date, deviceId?: number): Promise<any> {
    const query = this.notificationLogRepository.createQueryBuilder('log')
      .where('log.createdAt BETWEEN :startDate AND :endDate', { startDate, endDate })
      .leftJoinAndSelect('log.channel', 'channel')
      .leftJoinAndSelect('log.notificationType', 'notificationType')
      .leftJoinAndSelect('log.device', 'device');

    if (deviceId) {
      query.andWhere('log.deviceId = :deviceId', { deviceId });
    }

    const logs = await query.getMany();

    const stats = {
      total: logs.length,
      byStatus: {},
      byChannel: {},
      successRate: 0,
      failedRate: 0,
      averageRetryCount: 0
    };

    let successCount = 0;
    let failedCount = 0;
    let totalRetryCount = 0;

    logs.forEach(log => {
      // Count by status
      if (!stats.byStatus[log.status]) {
        stats.byStatus[log.status] = 0;
      }
      stats.byStatus[log.status]++;

      // Count by channel
      const channelName = log.channel?.name || 'Unknown';
      if (!stats.byChannel[channelName]) {
        stats.byChannel[channelName] = 0;
      }
      stats.byChannel[channelName]++;

      // Count success/failure
      if (log.status === 'sent' || log.status === 'delivered') {
        successCount++;
      } else if (log.status === 'failed') {
        failedCount++;
      }

      // Sum retry count
      totalRetryCount += log.retryCount || 0;
    });

    // Calculate rates
    if (logs.length > 0) {
      stats.successRate = Math.round((successCount / logs.length) * 100);
      stats.failedRate = Math.round((failedCount / logs.length) * 100);
      stats.averageRetryCount = Math.round((totalRetryCount / logs.length) * 10) / 10;
    }

    return stats;
  }

  private async getSensorDataStatsByPeriod(startDate: Date, endDate: Date, deviceId?: number): Promise<any> {
    const query = this.sensorDataRepository.createQueryBuilder('data')
      .where('data.timestamp BETWEEN :startDate AND :endDate', { startDate, endDate });

    if (deviceId) {
      query.andWhere('data.deviceId = :deviceId', { deviceId });
    }

    const dataPoints = await query.getMany();

    if (dataPoints.length === 0) {
      return {
        total: 0,
        averageValue: 0,
        minValue: 0,
        maxValue: 0,
        dataPoints: []
      };
    }

    const values = dataPoints.map(d => parseFloat(d.value.toString()));
    const averageValue = values.reduce((a, b) => a + b, 0) / values.length;
    const minValue = Math.min(...values);
    const maxValue = Math.max(...values);

    // Sample data for chart (limit to 100 points for performance)
    const sampledData = dataPoints.length > 100 
      ? this.sampleData(dataPoints, 100)
      : dataPoints.map(d => ({
          timestamp: d.timestamp,
          value: d.value,
          type: d.notificationType?.name
        }));

    return {
      total: dataPoints.length,
      averageValue: Math.round(averageValue * 100) / 100,
      minValue: Math.round(minValue * 100) / 100,
      maxValue: Math.round(maxValue * 100) / 100,
      dataPoints: sampledData
    };
  }

  private sampleData(data: any[], maxPoints: number): any[] {
    if (data.length <= maxPoints) {
      return data;
    }

    const step = Math.floor(data.length / maxPoints);
    const sampled = [];

    for (let i = 0; i < data.length; i += step) {
      sampled.push({
        timestamp: data[i].timestamp,
        value: data[i].value,
        type: data[i].notificationType?.name
      });
      
      if (sampled.length >= maxPoints) {
        break;
      }
    }

    return sampled;
  }

  async getReport(reportId: number): Promise<ReportData> {
    const report = await this.reportDataRepository.findOne({
      where: { id: reportId }
    });

    if (!report) {
      throw new Error(`Report ${reportId} not found`);
    }

    return report;
  }

  async getReports(options: {
    deviceId?: number;
    reportType?: string;
    startDate?: Date;
    endDate?: Date;
    limit?: number;
    offset?: number;
  } = {}): Promise<{ reports: ReportData[]; total: number }> {
    const { deviceId, reportType, startDate, endDate, limit = 50, offset = 0 } = options;

    const query = this.reportDataRepository.createQueryBuilder('report')
      .orderBy('report.generatedAt', 'DESC');

    if (deviceId) {
      query.andWhere('report.deviceId = :deviceId', { deviceId });
    }

    if (reportType) {
      query.andWhere('report.reportType = :reportType', { reportType });
    }

    if (startDate) {
      query.andWhere('report.periodStart >= :startDate', { startDate });
    }

    if (endDate) {
      query.andWhere('report.periodEnd <= :endDate', { endDate });
    }

    const total = await query.getCount();
    const reports = await query
      .skip(offset)
      .take(limit)
      .leftJoinAndSelect('report.device', 'device')
      .getMany();

    return { reports, total };
  }

  async exportReport(reportId: number, format: 'json' | 'csv' | 'pdf' = 'json'): Promise<string> {
    const report = await this.getReport(reportId);
    
    let exportedData: string;

    switch (format) {
      case 'json':
        exportedData = JSON.stringify(report.data, null, 2);
        break;
      case 'csv':
        exportedData = this.convertToCSV(report.data);
        break;
      case 'pdf':
        // In real implementation, you would use a PDF library like pdfkit
        exportedData = JSON.stringify(report.data); // Placeholder
        break;
      default:
        exportedData = JSON.stringify(report.data);
    }

    // Update report export status
    report.isExported = true;
    report.exportedAt = new Date();
    report.fileFormat = format;
    await this.reportDataRepository.save(report);

    return exportedData;
  }

  private convertToCSV(data: any): string {
    const flattenObject = (obj: any, prefix = ''): any => {
      return Object.keys(obj).reduce((acc, k) => {
        const pre = prefix.length ? prefix + '.' : '';
        if (typeof obj[k] === 'object' && obj[k] !== null && !Array.isArray(obj[k])) {
          Object.assign(acc, flattenObject(obj[k], pre + k));
        } else {
          acc[pre + k] = obj[k];
        }
        return acc;
      }, {});
    };

    const flatData = flattenObject(data);
    const headers = Object.keys(flatData);
    const values = headers.map(h => flatData[h]);
    
    return headers.join(',') + '\n' + values.map(v => 
      typeof v === 'string' ? `"${v.replace(/"/g, '""')}"` : v
    ).join(',');
  }

  async deleteOldReports(days: number = 365): Promise<number> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);

    const result = await this.reportDataRepository.createQueryBuilder()
      .delete()
      .where('generatedAt < :cutoffDate', { cutoffDate })
      .execute();

    return result.affected || 0;
  }
}
[file content end]
```

## 7. Flow การทำงานของระบบทั้งหมด

### 1. รับข้อมูลจากเซ็นเซอร์ผ่าน MQTT
```typescript
MQTT → MqttHandlerService → SensorData Entity → NotificationService.processSensorData()
```

### 2. ตรวจสอบเงื่อนไขกับค่าที่ตั้งไว้
```typescript
NotificationService.checkCondition() → NotificationCondition Entity → Redis Cache Check
```

### 3. อัปเดตสถานะและบันทึกประวัติ
```typescript
Notification Entity → Status Update → DeviceStatusHistory Entity
```

### 4. สร้างการแจ้งเตือนตามระดับความสำคัญ
```typescript
DeviceNotificationConfig → ChannelTemplate → NotificationLog Entity
```

### 5. ตรวจสอบ cooldown ด้วย Redis
```typescript
RedisCacheService.set()/exists() → Notification cooldown management
```

### 6. ส่งผ่านช่องทางต่างๆ ตามการตั้งค่า
```typescript
NotificationQueueService → Channel Handlers (Line, Discord, Telegram, SMS, etc.)
```

### 7. บันทึกผลการส่งและอัปเดตสถานะ
```typescript
NotificationLog Entity → Status update → Response data recording
```

### 8. แจ้งเตือนผ่าน WebSocket สำหรับ Real-time
```typescript
WebsocketService.sendNotification() → Socket.io clients
```

### 9. จัดการการแจ้งซ้ำตามสถานะและเวลาที่กำหนด
```typescript
Notification.repeatIntervalMinutes → nextNotifyAt calculation → Repeat logic
```

### 10. เก็บข้อมูลรายงานสำหรับ Dashboard
```typescript
ReportService → ReportData Entity → Daily/Weekly/Monthly reports
```

โครงสร้างนี้รองรับทุกความต้องการที่ระบุไว้:
- ระบบแจ้งเตือนแบบ real-time
- การตั้งค่าที่ยืดหยุ่น
- การรายงานและสถิติ
- การจัดการ cooldown และการแจ้งซ้ำ
- รองรับหลายช่องทางการสื่อสาร
- การจัดการสถานะแบบ dynamic (normal, warning, alarm, recovery) .