ผมต้องการสร้าง ระบบ notification  system โดยใช้
NustJS framwork By Node JS
หลักการทำงานของระบบ
1.รับข้อมูลจากเซ็นเซอร์ ผ่าน MQTT
2.ตรวจสอบเงื่อนไข กับค่าที่ตั้งไว้
3.อัปเดตสถานะ และบันทึกประวัติ
4.สร้างการแจ้งเตือน ตามระดับความสำคัญ
5.ตรวจสอบ cooldown ด้วย Redis หรือ notification  alarm configuration 
6.ส่งผ่านช่องทางต่างๆ ตามการตั้งค่า
	6.1.email notification
	6.2.line notification
	6.3.discord notification
	6.4.telegram notification
	6.5.sms notification
	6.6.web dashboard notification
	6.7.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
7.บันทึกผลการส่ง และอัปเดตสถานะ แยก ประเภท 
	7.1.email notification
  7.2.line notification
	7.3.discord notification
	7.4.telegram notification
	7.45.sms notification
	7.6.web dashboard notification
	7.7.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
8.แจ้งเตือนผ่าน WebSocket สำหรับ Real-time
	8.1.web dashboard notification
	8.2.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
9.จัดการการแจ้งซ้ำ ตามสถานะและเวลาที่กำหนด
  9.1.นำเวลาแจ่งเตียน ล่าสุด มา เทียเวลาปจุบัน เกิน ค่าที่กำหนดไหม เช่น 10 นาที 
     table notification_type
	   1.Normal  หากยัง มีสถานะ  
	   2.Worming 3.Recovery Worming  
	   3.Alarm    
	   4.Recovery Alarm  
   ให้เจ้งเตียนซ้ำทุก  10 นาที  หาก  Normal  ให้แเจ้งเตียน หยุด  สถานะ Normal แล้วหยุด แเจ้งเตียน
        table notification_type
	   1.Normal  หากยัง มีสถานะ  
	   2.Worming 3.Recovery Worming  
	   3.Alarm    
	   4.Recovery Alarm  
   Notification condition 
   9.2.หาก สถานะ 1.Normal ไม่มีการ  แเจ้งเตียน
   9.3.เก็นประวัติการ แเจ้งเตียน
   9.4.กำหนด ค่าการแจ้งเตียชนแต่ละช่วง  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
   
10.เก็บข้อมูลรายงาน สำหรับ Dashboard
  10.1 แยกประเภท เก็บข้อมูลรายงาน
  10.2 ข้อมูลรายงาน สำหรับ สร้างกราฟ
  10.3 ข้อมูลรายงาน สำหรับ ข้อมูล ดิบ
  
 11.notification  group 
  11.1 sensor device เช่น  
  		sensor  
		   - temperature sensor
		   - humidity sensor
		   - CO2 sensor 
		   - O2 sensor (Oxygen Sensor)
  11.2 IO device (Input  optput) เช่น สถานะ การ 1.เปิด  2.ปิด 3.เชื่อมต่ออุปกรณ์ไม่ได้
  	        device
  	           -พัดลม
  	           -แอร์
  	           -ปลั๊มน้ำ
  	           -หลลอกไฟฟ้า

step 1
	-สร้าง entities  type orm
	-สร้าง modules rest api  
	-สร้าง level notification
	1.type orm
	2.database postgress sql
	3.socket.io
	4.mqtt
	5.redis
step 2
	1.ออกแบบ ระบบ notification data flow 
	2.ออกแบบ table database postgress sql แยก ทุก ค่าที่จำเป็น
	3.ออกแบบ Quit ใช่้ socket.io / mqtt / redis
	4.ออกแบบ  โคร้งสร้างข้อมูล สำหรับ หน้ารายงาน
	5.ออกแบบ ระบบตั้งค้า notification

step 3 notification  alarm configuration 
   1.ชื่อ Device 
   2.ข้อมูล Device เช่น  humidity  56 %
   3.วันเวลา
   4.สถานะ เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
   5.notification log  เก็บเวลา 
   6.นำเวลาแจ่งเตียน ล่าสุด มา เทียเวลาปจุบัน เกิน ค่าที่กำหนดไหม เช่น 10 นาที 
     table notification_type
	   1.Normal  หากยัง มีสถานะ  
	   2.Worming 3.Recovery Worming  
	   3.Alarm    
	   4.Recovery Alarm  
    7.icon notification
   ให้เจ้งเตียนซ้ำทุก  10 นาที  หาก  Normal  ให้แเจ้งเตียน หยุด  สถานะ Normal แล้วหยุด แเจ้งเตียน
        table notification_type
	   1.Normal  หากยัง มีสถานะ  
	   2.Worming 3.Recovery Worming  
	   3.Alarm    
	   4.Recovery Alarm  
   Notification condition 
   7.หาก สถานะ 1.Normal ไม่มีการ  แเจ้งเตียน
   8.เก็นประวัติการ แเจ้งเตียน
   9.กำหนด ค่าการแจ้งเตียชนแต่ละช่วง  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm

step 4 ช่องทาง การ ให้เลืกได้มากว่า 1 ช่องทาง โดยมี รูปแบบดังนี้
	1.line notification
	2.discord notification
	3.telegram notification
	4.sms notification
	5.web dashboard notification
	7.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
	8.AI CHERT BOT  notification  python  fast api



    # Notification System Design with NestJS

## 📁 โครงสร้าง Project

```
src/
├── main.ts
├── app.module.ts
├── common/
│   ├── constants/
│   ├── decorators/
│   └── filters/
├── core/
│   ├── database/
│   ├── redis/
│   ├── mqtt/
│   └── websocket/
├── modules/
│   ├── sensor/
│   ├── notification/
│   ├── device/
│   ├── report/
│   └── configuration/
└── shared/
    └── services/
```

## 📊 Database Design (PostgreSQL with TypeORM)

### 1. Sensor Module
```typescript
// entities/sensor.entity.ts
@Entity('sensors')
export class Sensor {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  type: SensorType; // TEMPERATURE, HUMIDITY, CO2, O2

  @Column({ unique: true })
  deviceId: string;

  @Column({ nullable: true })
  location: string;

  @Column('jsonb', { nullable: true })
  metadata: Record<string, any>;

  @OneToMany(() => SensorData, (data) => data.sensor)
  data: SensorData[];

  @OneToMany(() => NotificationRule, (rule) => rule.sensor)
  rules: NotificationRule[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

// entities/sensor-data.entity.ts
@Entity('sensor_data')
export class SensorData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Sensor, (sensor) => sensor.data)
  @JoinColumn({ name: 'sensor_id' })
  sensor: Sensor;

  @Column('decimal', { precision: 10, scale: 2 })
  value: number;

  @Column()
  unit: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  timestamp: Date;

  @Column('jsonb', { nullable: true })
  rawData: Record<string, any>;
}
```

### 2. Device Module
```typescript
// entities/device.entity.ts
@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  type: DeviceType; // FAN, AC, WATER_PUMP, LIGHT, ROBOT

  @Column({ unique: true })
  deviceId: string;

  @Column()
  status: DeviceStatus; // ONLINE, OFFLINE, ERROR

  @Column('jsonb', { nullable: true })
  configuration: {
    ipAddress?: string;
    port?: number;
    protocol?: string;
    commands?: Record<string, any>;
  };

  @OneToMany(() => DeviceCommand, (cmd) => cmd.device)
  commands: DeviceCommand[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

// entities/device-command.entity.ts
@Entity('device_commands')
export class DeviceCommand {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Device, (device) => device.commands)
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @Column()
  command: string; // START, STOP, TURN_ON, TURN_OFF

  @Column('jsonb', { nullable: true })
  parameters: Record<string, any>;

  @Column()
  status: CommandStatus; // PENDING, EXECUTING, COMPLETED, FAILED

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  executedAt: Date;

  @Column({ nullable: true })
  result: string;
}
```

### 3. Notification Module
```typescript
// entities/notification-type.entity.ts
@Entity('notification_types')
export class NotificationType {
  @PrimaryColumn()
  id: number;

  @Column()
  name: string; // NORMAL, WARNING, RECOVERY_WARNING, ALARM, RECOVERY_ALARM

  @Column()
  description: string;

  @Column({ default: '#4CAF50' })
  color: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ type: 'integer', default: 600 })
  cooldownSeconds: number; // Default 10 minutes

  @Column({ default: true })
  requiresNotification: boolean;
}

// entities/notification-rule.entity.ts
@Entity('notification_rules')
export class NotificationRule {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Sensor, (sensor) => sensor.rules)
  @JoinColumn({ name: 'sensor_id' })
  sensor: Sensor;

  @ManyToOne(() => NotificationType)
  @JoinColumn({ name: 'notification_type_id' })
  notificationType: NotificationType;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  minValue: number;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  maxValue: number;

  @Column('jsonb', { default: {} })
  conditions: {
    comparison: 'GREATER_THAN' | 'LESS_THAN' | 'EQUAL' | 'BETWEEN';
    duration?: number; // Duration in seconds for sustained condition
  };

  @Column('simple-array', { default: [] })
  channels: NotificationChannel[]; // EMAIL, LINE, DISCORD, TELEGRAM, SMS, WEB, DEVICE_CONTROL

  @Column('jsonb', { default: {} })
  channelConfig: {
    email?: string[];
    line?: string[];
    discord?: { webhookUrl: string }[];
    telegram?: { chatId: string }[];
    sms?: string[];
    deviceControl?: {
      deviceId: string;
      command: string;
      parameters?: Record<string, any>;
    }[];
  };

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}

// entities/notification.entity.ts
@Entity('notifications')
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Sensor)
  @JoinColumn({ name: 'sensor_id' })
  sensor: Sensor;

  @ManyToOne(() => NotificationType)
  @JoinColumn({ name: 'notification_type_id' })
  notificationType: NotificationType;

  @Column('decimal', { precision: 10, scale: 2 })
  sensorValue: number;

  @Column()
  message: string;

  @Column({ default: 'PENDING' })
  status: NotificationStatus; // PENDING, SENDING, SENT, FAILED

  @Column('jsonb', { default: {} })
  deliveryStatus: {
    email?: { sent: boolean; timestamp?: Date; error?: string };
    line?: { sent: boolean; timestamp?: Date; error?: string };
    discord?: { sent: boolean; timestamp?: Date; error?: string };
    telegram?: { sent: boolean; timestamp?: Date; error?: string };
    sms?: { sent: boolean; timestamp?: Date; error?: string };
    web?: { sent: boolean; timestamp?: Date };
    deviceControl?: { sent: boolean; deviceId?: string; command?: string; timestamp?: Date; error?: string };
  };

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  triggeredAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  sentAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  acknowledgedAt: Date;
}

// entities/notification-log.entity.ts
@Entity('notification_logs')
export class NotificationLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Notification)
  @JoinColumn({ name: 'notification_id' })
  notification: Notification;

  @Column()
  channel: NotificationChannel;

  @Column()
  status: 'SUCCESS' | 'FAILED';

  @Column({ nullable: true })
  errorMessage: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  sentAt: Date;

  @Column('jsonb', { nullable: true })
  metadata: Record<string, any>;
}
```

### 4. Report Module
```typescript
// entities/report.entity.ts
@Entity('reports')
export class Report {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  type: ReportType; // DAILY, WEEKLY, MONTHLY, CUSTOM

  @Column()
  title: string;

  @ManyToOne(() => Sensor, { nullable: true })
  @JoinColumn({ name: 'sensor_id' })
  sensor: Sensor;

  @Column('jsonb')
  data: {
    timeRange: { start: Date; end: Date };
    metrics: Record<string, any>;
    charts: {
      type: string;
      data: any[];
      options: Record<string, any>;
    }[];
    rawData: any[];
  };

  @Column({ default: false })
  isGenerated: boolean;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  generatedAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
```

## 🚀 Core Implementation

### 1. MQTT Service
```typescript
// core/mqtt/mqtt.service.ts
@Injectable()
export class MqttService {
  private client: mqtt.MqttClient;

  constructor(
    private configService: ConfigService,
    private sensorService: SensorService,
    private notificationService: NotificationService,
  ) {}

  async connect() {
    const options = {
      host: this.configService.get('MQTT_HOST'),
      port: this.configService.get('MQTT_PORT'),
      username: this.configService.get('MQTT_USERNAME'),
      password: this.configService.get('MQTT_PASSWORD'),
    };

    this.client = mqtt.connect(options);

    this.client.on('connect', () => {
      console.log('Connected to MQTT broker');
      this.client.subscribe('sensors/#');
      this.client.subscribe('devices/status/#');
    });

    this.client.on('message', async (topic, message) => {
      await this.handleMessage(topic, message.toString());
    });
  }

  private async handleMessage(topic: string, message: string) {
    try {
      const data = JSON.parse(message);
      
      if (topic.startsWith('sensors/')) {
        await this.sensorService.processSensorData(topic, data);
      } else if (topic.startsWith('devices/status/')) {
        await this.deviceService.updateDeviceStatus(topic, data);
      }
    } catch (error) {
      console.error('Error processing MQTT message:', error);
    }
  }

  publish(topic: string, message: any) {
    this.client.publish(topic, JSON.stringify(message));
  }
}
```

### 2. Notification Service
```typescript
// modules/notification/notification.service.ts
@Injectable()
export class NotificationService {
  constructor(
    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,
    @InjectRepository(NotificationRule)
    private ruleRepo: Repository<NotificationRule>,
    private redisService: RedisService,
    private emailService: EmailService,
    private lineService: LineService,
    private discordService: DiscordService,
    private telegramService: TelegramService,
    private smsService: SmsService,
    private deviceService: DeviceService,
    private webSocketGateway: WebSocketGateway,
  ) {}

  async checkAndNotify(sensor: Sensor, value: number) {
    // Get active rules for this sensor
    const rules = await this.ruleRepo.find({
      where: { sensor: { id: sensor.id }, isActive: true },
      relations: ['notificationType'],
    });

    for (const rule of rules) {
      if (this.checkCondition(value, rule)) {
        await this.triggerNotification(sensor, value, rule);
      }
    }
  }

  private checkCondition(value: number, rule: NotificationRule): boolean {
    const { conditions, minValue, maxValue } = rule;
    
    switch (conditions.comparison) {
      case 'GREATER_THAN':
        return value > maxValue;
      case 'LESS_THAN':
        return value < minValue;
      case 'BETWEEN':
        return value >= minValue && value <= maxValue;
      case 'EQUAL':
        return value === maxValue;
      default:
        return false;
    }
  }

  private async triggerNotification(
    sensor: Sensor,
    value: number,
    rule: NotificationRule,
  ) {
    const cacheKey = `notification:cooldown:${sensor.id}:${rule.notificationType.id}`;
    
    // Check cooldown in Redis
    const lastNotification = await this.redisService.get(cacheKey);
    if (lastNotification) {
      const lastTime = new Date(lastNotification).getTime();
      const now = Date.now();
      const cooldownMs = rule.notificationType.cooldownSeconds * 1000;
      
      if (now - lastTime < cooldownMs) {
        return; // Still in cooldown period
      }
    }

    // Create notification record
    const notification = this.notificationRepo.create({
      sensor,
      notificationType: rule.notificationType,
      sensorValue: value,
      message: this.generateMessage(sensor, value, rule.notificationType),
      status: 'PENDING',
    });

    await this.notificationRepo.save(notification);

    // Send through all configured channels
    await this.sendThroughChannels(notification, rule);

    // Update cooldown in Redis
    await this.redisService.set(
      cacheKey,
      new Date().toISOString(),
      'EX',
      rule.notificationType.cooldownSeconds,
    );
  }

  private async sendThroughChannels(
    notification: Notification,
    rule: NotificationRule,
  ) {
    const deliveryStatus: any = {};
    const promises = [];

    // Email
    if (rule.channels.includes('EMAIL') && rule.channelConfig.email) {
      promises.push(
        this.emailService
          .sendNotification(rule.channelConfig.email, notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // LINE
    if (rule.channels.includes('LINE') && rule.channelConfig.line) {
      promises.push(
        this.lineService
          .sendNotification(rule.channelConfig.line, notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // Discord
    if (rule.channels.includes('DISCORD') && rule.channelConfig.discord) {
      promises.push(
        this.discordService
          .sendNotification(rule.channelConfig.discord, notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // Telegram
    if (rule.channels.includes('TELEGRAM') && rule.channelConfig.telegram) {
      promises.push(
        this.telegramService
          .sendNotification(rule.channelConfig.telegram, notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // SMS
    if (rule.channels.includes('SMS') && rule.channelConfig.sms) {
      promises.push(
        this.smsService
          .sendNotification(rule.channelConfig.sms, notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // Web Dashboard (WebSocket)
    if (rule.channels.includes('WEB')) {
      promises.push(
        this.webSocketGateway
          .sendNotification(notification)
          .then(() => ({ sent: true }))
          .catch((error) => ({ sent: false, error: error.message })),
      );
    }

    // Device Control
    if (rule.channels.includes('DEVICE_CONTROL') && rule.channelConfig.deviceControl) {
      for (const deviceConfig of rule.channelConfig.deviceControl) {
        promises.push(
          this.deviceService
            .sendCommand(
              deviceConfig.deviceId,
              deviceConfig.command,
              deviceConfig.parameters,
            )
            .then(() => ({ sent: true, deviceId: deviceConfig.deviceId, command: deviceConfig.command }))
            .catch((error) => ({ 
              sent: false, 
              deviceId: deviceConfig.deviceId, 
              command: deviceConfig.command,
              error: error.message 
            })),
        );
      }
    }

    // Wait for all notifications to complete
    const results = await Promise.allSettled(promises);
    
    // Update notification status
    notification.status = 'SENT';
    notification.sentAt = new Date();
    notification.deliveryStatus = this.processResults(results);
    
    await this.notificationRepo.save(notification);
  }
}
```

### 3. WebSocket Gateway
```typescript
// core/websocket/websocket.gateway.ts
@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'notifications',
})
export class WebSocketGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private clients = new Map<string, Socket>();

  handleConnection(client: Socket) {
    const clientId = client.id;
    this.clients.set(clientId, client);
    console.log(`Client connected: ${clientId}`);
  }

  handleDisconnect(client: Socket) {
    const clientId = client.id;
    this.clients.delete(clientId);
    console.log(`Client disconnected: ${clientId}`);
  }

  sendNotification(notification: Notification) {
    this.server.emit('notification', {
      id: notification.id,
      type: notification.notificationType.name,
      sensor: notification.sensor.name,
      value: notification.sensorValue,
      message: notification.message,
      timestamp: notification.triggeredAt,
    });
  }

  sendDeviceStatus(device: Device) {
    this.server.emit('device-status', {
      id: device.id,
      name: device.name,
      status: device.status,
      lastUpdated: new Date(),
    });
  }
}
```

### 4. Report Service
```typescript
// modules/report/report.service.ts
@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(SensorData)
    private sensorDataRepo: Repository<SensorData>,
    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,
    @InjectRepository(Report)
    private reportRepo: Repository<Report>,
  ) {}

  async generateDailyReport(date: Date = new Date()) {
    const start = startOfDay(date);
    const end = endOfDay(date);

    // Get sensor data
    const sensorData = await this.sensorDataRepo
      .createQueryBuilder('data')
      .leftJoinAndSelect('data.sensor', 'sensor')
      .where('data.timestamp BETWEEN :start AND :end', { start, end })
      .getMany();

    // Get notifications
    const notifications = await this.notificationRepo
      .createQueryBuilder('notification')
      .leftJoinAndSelect('notification.sensor', 'sensor')
      .leftJoinAndSelect('notification.notificationType', 'type')
      .where('notification.triggeredAt BETWEEN :start AND :end', { start, end })
      .getMany();

    // Generate metrics
    const metrics = this.calculateMetrics(sensorData, notifications);

    // Generate charts data
    const charts = this.generateChartsData(sensorData, notifications);

    // Create report
    const report = this.reportRepo.create({
      type: 'DAILY',
      title: `Daily Report - ${format(date, 'yyyy-MM-dd')}`,
      data: {
        timeRange: { start, end },
        metrics,
        charts,
        rawData: sensorData.slice(0, 1000), // Limit raw data
      },
      isGenerated: true,
      generatedAt: new Date(),
    });

    return await this.reportRepo.save(report);
  }

  private calculateMetrics(sensorData: SensorData[], notifications: Notification[]) {
    // Implementation for various metrics
    return {
      totalReadings: sensorData.length,
      avgValues: this.calculateAverages(sensorData),
      notificationCounts: this.countNotifications(notifications),
      uptime: this.calculateUptime(sensorData),
    };
  }

  private generateChartsData(sensorData: SensorData[], notifications: Notification[]) {
    return [
      {
        type: 'line',
        data: this.prepareTimeSeriesData(sensorData),
        options: { title: 'Sensor Readings Over Time' },
      },
      {
        type: 'bar',
        data: this.prepareNotificationFrequency(notifications),
        options: { title: 'Notification Frequency by Type' },
      },
      {
        type: 'pie',
        data: this.prepareDeviceStatusData(sensorData),
        options: { title: 'Device Status Distribution' },
      },
    ];
  }
}
```

## 🔧 Configuration Module
```typescript
// modules/configuration/configuration.service.ts
@Injectable()
export class ConfigurationService {
  constructor(
    @InjectRepository(NotificationRule)
    private ruleRepo: Repository<NotificationRule>,
    @InjectRepository(Device)
    private deviceRepo: Repository<Device>,
  ) {}

  async createNotificationRule(dto: CreateNotificationRuleDto) {
    const rule = this.ruleRepo.create({
      ...dto,
      isActive: true,
    });

    return await this.ruleRepo.save(rule);
  }

  async updateNotificationRule(id: string, dto: UpdateNotificationRuleDto) {
    await this.ruleRepo.update(id, dto);
    return this.ruleRepo.findOne({ where: { id } });
  }

  async getNotificationRules(filters?: any) {
    const query = this.ruleRepo
      .createQueryBuilder('rule')
      .leftJoinAndSelect('rule.sensor', 'sensor')
      .leftJoinAndSelect('rule.notificationType', 'type');

    if (filters?.sensorId) {
      query.where('sensor.id = :sensorId', { sensorId: filters.sensorId });
    }

    if (filters?.isActive !== undefined) {
      query.andWhere('rule.isActive = :isActive', { isActive: filters.isActive });
    }

    return await query.getMany();
  }

  async testNotification(ruleId: string) {
    const rule = await this.ruleRepo.findOne({
      where: { id: ruleId },
      relations: ['sensor', 'notificationType'],
    });

    if (!rule) {
      throw new NotFoundException('Notification rule not found');
    }

    // Trigger test notification
    const testValue = rule.maxValue || rule.minValue || 0;
    // ... trigger notification logic
  }
}
```

## 🚀 Main Application Setup
```typescript
// app.module.ts
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST'),
        port: configService.get('DB_PORT'),
        username: configService.get('DB_USERNAME'),
        password: configService.get('DB_PASSWORD'),
        database: configService.get('DB_NAME'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: configService.get('NODE_ENV') === 'development',
        logging: configService.get('NODE_ENV') === 'development',
      }),
      inject: [ConfigService],
    }),
    ScheduleModule.forRoot(),
    EventEmitterModule.forRoot(),
    // Feature modules
    SensorModule,
    NotificationModule,
    DeviceModule,
    ReportModule,
    ConfigurationModule,
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: TransformInterceptor,
    },
  ],
})
export class AppModule implements OnModuleInit {
  constructor(
    private mqttService: MqttService,
    private redisService: RedisService,
  ) {}

  async onModuleInit() {
    await this.redisService.connect();
    await this.mqttService.connect();
  }
}
```

## 📦 Package.json Dependencies
```json
{
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/platform-socket.io": "^10.0.0",
    "@nestjs/typeorm": "^10.0.0",
    "@nestjs/schedule": "^10.0.0",
    "@nestjs/config": "^3.0.0",
    "typeorm": "^0.3.0",
    "pg": "^8.11.0",
    "ioredis": "^5.3.0",
    "mqtt": "^5.0.0",
    "socket.io": "^4.5.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.0",
    "@nestjs/swagger": "^7.0.0",
    "nodemailer": "^6.9.0",
    "axios": "^1.4.0",
    "date-fns": "^2.30.0",
    "winston": "^3.9.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "jest": "^29.0.0"
  }
}
```

## 🎯 Environment Variables (.env)
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_NAME=notification_system

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# MQTT
MQTT_HOST=mqtt://localhost
MQTT_PORT=1883
MQTT_USERNAME=
MQTT_PASSWORD=

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-password

# LINE Messaging API
LINE_CHANNEL_ACCESS_TOKEN=your_line_token
LINE_CHANNEL_SECRET=your_line_secret

# Telegram Bot
TELEGRAM_BOT_TOKEN=your_bot_token

# Discord Webhook
DISCORD_WEBHOOK_URL=your_webhook_url

# SMS Gateway
SMS_API_KEY=your_sms_api_key
SMS_API_SECRET=your_sms_api_secret
```

## 🔄 Workflow Summary

1. **Data Ingestion**: MQTT receives sensor data
2. **Condition Check**: Compare with configured rules
3. **Cooldown Check**: Verify Redis cache for recent notifications
4. **Notification Creation**: Create notification record
5. **Multi-channel Delivery**: Send through all configured channels
6. **Status Update**: Update delivery status
7. **Real-time Update**: Broadcast via WebSocket
8. **Logging**: Record all activities
9. **Report Generation**: Create scheduled reports

## 🎨 Dashboard Features

1. Real-time sensor data visualization
2. Notification history with filters
3. Device status monitoring
4. Report generation interface
5. Notification rule management
6. Channel configuration
7. System health monitoring

ระบบนี้สามารถขยายได้โดยง่าย เพิ่มเซ็นเซอร์ประเภทใหม่ ช่องทางการแจ้งเตือนเพิ่มเติม หรือฟังก์ชันการทำงานพิเศษตามความต้องการ