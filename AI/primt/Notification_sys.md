# Notification System Design with NestJS

## Step 1: Entities & Modules Structure

### 1.1 Database Entities (TypeORM)
 
```typescript
// src/entities/sensor.entity.ts
@Entity('sd_sensors')
export class Sensor {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  deviceId: string;

  @Column({ type: 'varchar' })
  sensorType: SensorType; // temperature, humidity, co2, o2

  @Column({ nullable: true })
  location: string;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @Column({ type: 'float', nullable: true })
  lastValue: number;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  lastUpdated: Date;

  @OneToMany(() => SensorData, (data) => data.sensor)
  data: SensorData[];

  @OneToMany(() => NotificationRule, (rule) => rule.sensor)
  notificationRules: NotificationRule[];
}

// src/entities/device.entity.ts
@Entity('sd_devices')
export class Device {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column()
  deviceId: string;

  @Column({ type: 'varchar' })
  deviceType: DeviceType; // fan, ac, pump, light

  @Column({ type: 'varchar', default: DeviceStatus.OFF })
  status: DeviceStatus;

  @Column({ type: 'boolean', default: false })
  isOnline: boolean;

  @Column({ type: 'timestamp', nullable: true })
  lastStatusChange: Date;

  @Column({ type: 'jsonb', nullable: true })
  controlParams: Record<string, any>;

  @OneToMany(() => NotificationRule, (rule) => rule.device)
  notificationRules: NotificationRule[];
}

// src/entities/notification-rule.entity.ts
@Entity('sd_notification_rules')
export class NotificationRule {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @ManyToOne(() => Sensor, { nullable: true })
  @JoinColumn()
  sensor: Sensor;

  @ManyToOne(() => Device, { nullable: true })
  @JoinColumn()
  device: Device;

  @Column({ type: 'varchar' })
  notificationType: NotificationType; // Normal, Warning, Alarm, etc.

  @Column({ type: 'jsonb' })
  conditions: RuleCondition[];

  @Column({ type: 'jsonb' })
  channels: NotificationChannel[];

  @Column({ type: 'int', default: 600 }) // 10 minutes in seconds
  cooldownPeriod: number;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @Column({ type: 'jsonb', nullable: true })
  customActions: CustomAction[];

  @Column({ type: 'int', default: 1 })
  priority: number;

  @Column({ type: 'varchar', nullable: true })
  icon: string;
}

// src/entities/notification-log.entity.ts
@Entity('sd_notification_logs')
export class NotificationLog {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({ type: 'varchar' })
  notificationType: NotificationType;

  @Column({ type: 'jsonb' })
  data: Record<string, any>;

  @Column({ type: 'jsonb' })
  channels: ChannelLog[];

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  timestamp: Date;

  @Column({ type: 'boolean', default: false })
  isSent: boolean;

  @Column({ type: 'varchar', nullable: true })
  status: string;

  @Column({ type: 'varchar', nullable: true })
  icon: string;

  @ManyToOne(() => Sensor, { nullable: true })
  @JoinColumn()
  sensor: Sensor;

  @ManyToOne(() => Device, { nullable: true })
  @JoinColumn()
  device: Device;
}

// src/entities/sensor-data.entity.ts
@Entity('sd_sensor_data')
export class SensorData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Sensor, (sensor) => sensor.data)
  @JoinColumn()
  sensor: Sensor;

  @Column({ type: 'float' })
  value: number;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  timestamp: Date;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @Index()
  @Column({ type: 'varchar', nullable: true })
  status: string;
}

// src/entities/notification-channel-config.entity.ts
@Entity('sd_notification_channel_configs')
export class NotificationChannelConfig {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar' })
  channelType: ChannelType; // line, discord, telegram, sms, webhook

  @Column()
  configName: string;

  @Column({ type: 'jsonb' })
  config: Record<string, any>;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  createdAt: Date;
}
```

### 1.2 Enums

```typescript
// src/enums/notification.enum.ts
export enum NotificationType {
  NORMAL = 'normal',
  WARNING = 'warning',
  RECOVERY_WARNING = 'recovery_warning',
  ALARM = 'alarm',
  RECOVERY_ALARM = 'recovery_alarm'
}

export enum ChannelType {
  LINE = 'line',
  DISCORD = 'discord',
  TELEGRAM = 'telegram',
  SMS = 'sms',
  WEB_DASHBOARD = 'web_dashboard',
  DEVICE_CONTROL = 'device_control',
  AI_CHATBOT = 'ai_chatbot'
}

export enum SensorType {
  TEMPERATURE = 'temperature',
  HUMIDITY = 'humidity',
  CO2 = 'co2',
  O2 = 'o2'
}

export enum DeviceType {
  FAN = 'fan',
  AC = 'ac',
  WATER_PUMP = 'water_pump',
  LIGHT = 'light',
  ROBOT = 'robot'
}

export enum DeviceStatus {
  ON = 'on',
  OFF = 'off',
  ERROR = 'error',
  DISCONNECTED = 'disconnected'
}

export enum ConditionOperator {
  GREATER_THAN = 'gt',
  GREATER_THAN_EQUAL = 'gte',
  LESS_THAN = 'lt',
  LESS_THAN_EQUAL = 'lte',
  EQUAL = 'eq',
  NOT_EQUAL = 'neq',
  BETWEEN = 'between'
}
```

### 1.3 DTOs and Interfaces

```typescript
// src/interfaces/notification.interface.ts
export interface RuleCondition {
  field: string;
  operator: ConditionOperator;
  value: any;
  value2?: any; // For BETWEEN operator
}

export interface NotificationChannel {
  type: ChannelType;
  configId?: string;
  recipients?: string[];
  template?: string;
  enabled: boolean;
}

export interface CustomAction {
  type: 'device_control' | 'webhook' | 'function_call';
  target: string;
  action: string;
  parameters: Record<string, any>;
}

export interface ChannelLog {
  channel: ChannelType;
  sentAt: Date;
  status: 'success' | 'failed' | 'pending';
  error?: string;
  response?: any;
}

export interface MQTTPayload {
  deviceId: string;
  sensorType?: string;
  value: number;
  timestamp: string;
  metadata?: Record<string, any>;
}
```

## Step 2: System Architecture & Data Flow

### 2.1 Module Structure

```
src/
├── modules/
│   ├── mqtt/
│   │   ├── mqtt.module.ts
│   │   ├── mqtt.service.ts
│   │   └── mqtt.controller.ts
│   ├── notification/
│   │   ├── notification.module.ts
│   │   ├── notification.service.ts
│   │   ├── notification.controller.ts
│   │   ├── notification.processor.ts
│   │   └── channels/
│   │       ├── line.service.ts
│   │       ├── discord.service.ts
│   │       ├── telegram.service.ts
│   │       ├── sms.service.ts
│   │       ├── web-dashboard.service.ts
│   │       └── device-control.service.ts
│   ├── sensor/
│   │   ├── sensor.module.ts
│   │   ├── sensor.service.ts
│   │   └── sensor.controller.ts
│   ├── device/
│   │   ├── device.module.ts
│   │   ├── device.service.ts
│   │   └── device.controller.ts
│   ├── redis/
│   │   ├── redis.module.ts
│   │   └── redis.service.ts
│   ├── websocket/
│   │   ├── websocket.module.ts
│   │   ├── websocket.gateway.ts
│   │   └── websocket.service.ts
│   └── report/
│       ├── report.module.ts
│       ├── report.service.ts
│       └── report.controller.ts
├── entities/
├── repositories/
├── config/
└── common/
```

### 2.2 Database Schema

```sql
-- Tables for step 9-10: Reporting and Dashboard
CREATE TABLE sd_notification_summary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_type VARCHAR(50) NOT NULL,
    sensor_id UUID REFERENCES sensors(id),
    device_id UUID REFERENCES devices(id),
    count INT DEFAULT 0,
    period_start TIMESTAMP NOT NULL,
    period_end TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sd_sensor_trend_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sensor_id UUID REFERENCES sensors(id),
    avg_value DECIMAL(10,2),
    min_value DECIMAL(10,2),
    max_value DECIMAL(10,2),
    sample_count INT,
    time_bucket TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sd_device_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id),
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_by VARCHAR(100),
    reason TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_sensor_data_timestamp ON sensor_data(timestamp);
CREATE INDEX idx_notification_logs_timestamp ON notification_logs(timestamp);
CREATE INDEX idx_sensor_trend_data_time_bucket ON sensor_trend_data(time_bucket);
```

### 2.3 Data Flow Diagram

```
MQTT Broker → MQTT Service → Notification Processor
                                      ↓
                                Rule Evaluation
                                      ↓
                        Redis (Cooldown Check) → [Skip if in cooldown]
                                      ↓
                              Status Determination
                                      ↓
                        Create Notification Log
                                      ↓
                    Parallel Channel Processing
        ┌───────────┬───────────┬─────────────┬─────────────┐
        ↓           ↓           ↓             ↓             ↓
    Line         Discord    Telegram        SMS      Web Dashboard
    Service      Service    Service       Service     Service (WS)
        │           │           │             │             │
        └───────────┴───────────┴─────────────┴─────────────┘
                                      ↓
                            Update Notification Log
                                      ↓
                           Trigger Custom Actions
                                      ↓
                          Report Generation (Async)
```

## Step 3: Notification Alarm Configuration Service

```typescript
// src/modules/notification/notification.service.ts
@Injectable()
export class NotificationService {
  constructor(
    @InjectRepository(NotificationRule)
    private ruleRepository: Repository<NotificationRule>,
    @InjectRepository(NotificationLog)
    private logRepository: Repository<NotificationLog>,
    @InjectRepository(Sensor)
    private sensorRepository: Repository<Sensor>,
    @InjectRepository(Device)
    private deviceRepository: Repository<Device>,
    private redisService: RedisService,
    private mqttService: MqttService,
    private webSocketService: WebSocketService,
    private lineService: LineService,
    private discordService: DiscordService,
    private telegramService: TelegramService,
    private smsService: SmsService,
    private deviceControlService: DeviceControlService,
  ) {}

  async processSensorData(payload: MQTTPayload): Promise<void> {
    // 1. Update sensor data
    const sensor = await this.sensorRepository.findOne({
      where: { deviceId: payload.deviceId, sensorType: payload.sensorType },
    });

    if (!sensor) return;

    // Save sensor data
    await this.saveSensorData(sensor, payload);

    // 2. Check notification rules
    const rules = await this.ruleRepository.find({
      where: { sensor: { id: sensor.id }, isActive: true },
      relations: ['sensor'],
    });

    for (const rule of rules) {
      await this.evaluateRule(rule, sensor, payload);
    }
  }

  private async evaluateRule(
    rule: NotificationRule,
    sensor: Sensor,
    payload: MQTTPayload,
  ): Promise<void> {
    // Check conditions
    const conditionsMet = this.checkConditions(rule.conditions, payload.value);
    
    if (!conditionsMet) return;

    // Check cooldown in Redis
    const cooldownKey = `notification:cooldown:${rule.id}:${sensor.id}`;
    const lastSent = await this.redisService.get(cooldownKey);
    
    if (lastSent) {
      const lastSentTime = new Date(lastSent).getTime();
      const now = Date.now();
      const elapsedMinutes = (now - lastSentTime) / (1000 * 60);
      
      if (elapsedMinutes < (rule.cooldownPeriod / 60)) {
        return; // Still in cooldown
      }
    }

    // Determine notification type based on value
    const notificationType = this.determineNotificationType(
      payload.value,
      rule.conditions,
    );

    // Create notification
    await this.createNotification(rule, sensor, payload, notificationType);

    // Set cooldown in Redis
    await this.redisService.set(
      cooldownKey,
      new Date().toISOString(),
      rule.cooldownPeriod,
    );
  }

  private determineNotificationType(
    value: number,
    conditions: RuleCondition[],
  ): NotificationType {
    // Logic to determine type based on conditions and value
    // This should be customized based on your rules
    return NotificationType.ALARM;
  }

  private async createNotification(
    rule: NotificationRule,
    sensor: Sensor,
    payload: MQTTPayload,
    notificationType: NotificationType,
  ): Promise<void> {
    // Create notification log
    const notificationLog = this.logRepository.create({
      title: `Alert: ${sensor.name}`,
      message: this.generateMessage(sensor, payload, notificationType),
      notificationType,
      data: {
        sensorId: sensor.id,
        value: payload.value,
        threshold: rule.conditions,
        timestamp: payload.timestamp,
      },
      channels: [],
      sensor,
      status: 'pending',
      icon: rule.icon,
    });

    await this.logRepository.save(notificationLog);

    // Process through all enabled channels
    await this.processNotificationChannels(
      notificationLog,
      rule.channels,
      rule.customActions,
    );
  }

  private async processNotificationChannels(
    log: NotificationLog,
    channels: NotificationChannel[],
    customActions: CustomAction[] = [],
  ): Promise<void> {
    const channelPromises = channels
      .filter(ch => ch.enabled)
      .map(async channel => {
        try {
          const channelLog: ChannelLog = {
            channel: channel.type,
            sentAt: new Date(),
            status: 'pending',
          };

          switch (channel.type) {
            case ChannelType.LINE:
              await this.lineService.sendNotification(log, channel);
              break;
            case ChannelType.DISCORD:
              await this.discordService.sendNotification(log, channel);
              break;
            case ChannelType.TELEGRAM:
              await this.telegramService.sendNotification(log, channel);
              break;
            case ChannelType.SMS:
              await this.smsService.sendNotification(log, channel);
              break;
            case ChannelType.WEB_DASHBOARD:
              await this.webSocketService.broadcastNotification(log);
              break;
            case ChannelType.DEVICE_CONTROL:
              await this.deviceControlService.executeActions(customActions);
              break;
          }

          channelLog.status = 'success';
          return channelLog;
        } catch (error) {
          return {
            channel: channel.type,
            sentAt: new Date(),
            status: 'failed',
            error: error.message,
          } as ChannelLog;
        }
      });

    const results = await Promise.all(channelPromises);
    
    // Update log with results
    log.channels = results;
    log.isSent = results.some(r => r.status === 'success');
    log.status = log.isSent ? 'sent' : 'failed';
    
    await this.logRepository.save(log);
  }

  // Re-notification logic for step 9
  async checkAndResendNotifications(): Promise<void> {
    const pendingNotifications = await this.logRepository.find({
      where: {
        isSent: true,
        notificationType: In([
          NotificationType.WARNING,
          NotificationType.ALARM,
        ]),
      },
      relations: ['sensor'],
      order: { timestamp: 'DESC' },
    });

    for (const notification of pendingNotifications) {
      // Group by sensor and notification type
      const key = `${notification.sensor.id}:${notification.notificationType}`;
      const lastSent = await this.redisService.get(`resend:${key}`);
      
      if (!lastSent) {
        // Check if condition still exists
        const rules = await this.ruleRepository.find({
          where: {
            sensor: { id: notification.sensor.id },
            notificationType: notification.notificationType,
            isActive: true,
          },
        });

        if (rules.length > 0) {
          // Resend notification
          await this.resendNotification(notification, rules[0]);
          
          // Update Redis with new timestamp
          await this.redisService.set(
            `resend:${key}`,
            new Date().toISOString(),
            600, // 10 minutes cooldown
          );
        }
      }
    }
  }

  private generateMessage(
    sensor: Sensor,
    payload: MQTTPayload,
    type: NotificationType,
  ): string {
    const typeLabels = {
      [NotificationType.NORMAL]: '✅ Normal',
      [NotificationType.WARNING]: '⚠️ Warning',
      [NotificationType.RECOVERY_WARNING]: '🔄 Warning Recovery',
      [NotificationType.ALARM]: '🚨 Alarm',
      [NotificationType.RECOVERY_ALARM]: '🔄 Alarm Recovery',
    };

    return `${typeLabels[type]}: ${sensor.name} 
Value: ${payload.value}
Time: ${new Date(payload.timestamp).toLocaleString()}`;
  }
}
```

## Step 4: Channel Services Implementation

### 4.1 Line Notification Service

```typescript
// src/modules/notification/channels/line.service.ts
@Injectable()
export class LineService {
  private readonly lineClient: messagingApi.MessagingApiClient;

  constructor(private configService: ConfigService) {
    const channelAccessToken = this.configService.get('LINE_CHANNEL_ACCESS_TOKEN');
    this.lineClient = new messagingApi.MessagingApiClient({
      channelAccessToken,
    });
  }

  async sendNotification(
    log: NotificationLog,
    channel: NotificationChannel,
  ): Promise<void> {
    for (const recipient of channel.recipients || []) {
      await this.lineClient.pushMessage({
        to: recipient,
        messages: [
          {
            type: 'text',
            text: `${log.title}\n\n${log.message}`,
          },
        ],
      });
    }
  }
}
```

### 4.2 Discord Service

```typescript
// src/modules/notification/channels/discord.service.ts
@Injectable()
export class DiscordService {
  private webhookClients: Map<string, WebhookClient> = new Map();

  async sendNotification(
    log: NotificationLog,
    channel: NotificationChannel,
  ): Promise<void> {
    const webhookUrl = channel.configId; // Should be webhook URL
    let client = this.webhookClients.get(webhookUrl);

    if (!client) {
      client = new WebhookClient({ url: webhookUrl });
      this.webhookClients.set(webhookUrl, client);
    }

    const embed = new EmbedBuilder()
      .setTitle(log.title)
      .setDescription(log.message)
      .setColor(this.getColorForType(log.notificationType))
      .setTimestamp(new Date())
      .setFooter({ text: 'Notification System' });

    if (log.icon) {
      embed.setThumbnail(log.icon);
    }

    await client.send({
      embeds: [embed],
    });
  }

  private getColorForType(type: NotificationType): number {
    const colors = {
      [NotificationType.NORMAL]: 0x00ff00,
      [NotificationType.WARNING]: 0xffa500,
      [NotificationType.RECOVERY_WARNING]: 0x90ee90,
      [NotificationType.ALARM]: 0xff0000,
      [NotificationType.RECOVERY_ALARM]: 0x90ee90,
    };
    return colors[type] || 0x808080;
  }
}
```

### 4.3 Device Control Service

```typescript
// src/modules/notification/channels/device-control.service.ts
@Injectable()
export class DeviceControlService {
  constructor(
    private mqttService: MqttService,
    private deviceRepository: Repository<Device>,
  ) {}

  async executeActions(actions: CustomAction[]): Promise<void> {
    for (const action of actions) {
      switch (action.type) {
        case 'device_control':
          await this.controlDevice(action);
          break;
        case 'webhook':
          await this.callWebhook(action);
          break;
        case 'function_call':
          await this.callFunction(action);
          break;
      }
    }
  }

  private async controlDevice(action: CustomAction): Promise<void> {
    const device = await this.deviceRepository.findOne({
      where: { deviceId: action.target },
    });

    if (!device) {
      throw new Error(`Device ${action.target} not found`);
    }

    // Publish MQTT command
    const topic = `devices/${action.target}/control`;
    const payload = {
      command: action.action,
      parameters: action.parameters,
      timestamp: new Date().toISOString(),
    };

    await this.mqttService.publish(topic, payload);

    // Update device status in database
    device.status = action.action as DeviceStatus;
    device.lastStatusChange = new Date();
    await this.deviceRepository.save(device);

    // Log status change
    await this.logStatusChange(device, action);
  }

  private async callWebhook(action: CustomAction): Promise<void> {
    const response = await axios.post(action.target, action.parameters, {
      headers: { 'Content-Type': 'application/json' },
    });

    if (response.status !== 200) {
      throw new Error(`Webhook call failed: ${response.statusText}`);
    }
  }

  private async callFunction(action: CustomAction): Promise<void> {
    // Implement function calling logic
    // This could call external services, Python FastAPI, etc.
    const functionUrl = action.target;
    
    try {
      const response = await axios.post(functionUrl, action.parameters);
      
      if (response.status !== 200) {
        throw new Error(`Function call failed: ${response.data}`);
      }
    } catch (error) {
      console.error('Function call error:', error);
      throw error;
    }
  }
}
```

## Step 5: WebSocket & Real-time Updates

```typescript
// src/modules/websocket/websocket.gateway.ts
@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class WebSocketGateway {
  @WebSocketServer()
  server: Server;

  constructor(private notificationService: NotificationService) {}

  @SubscribeMessage('subscribe')
  handleSubscribe(
    @MessageBody() data: { topics: string[] },
    @ConnectedSocket() client: Socket,
  ): void {
    data.topics.forEach(topic => {
      client.join(topic);
    });
  }

  @SubscribeMessage('unsubscribe')
  handleUnsubscribe(
    @MessageBody() data: { topics: string[] },
    @ConnectedSocket() client: Socket,
  ): void {
    data.topics.forEach(topic => {
      client.leave(topic);
    });
  }

  broadcastNotification(notification: NotificationLog): void {
    this.server.to('notifications').emit('notification', {
      id: notification.id,
      title: notification.title,
      message: notification.message,
      type: notification.notificationType,
      timestamp: notification.timestamp,
      icon: notification.icon,
      data: notification.data,
    });
  }

  broadcastDeviceStatus(device: Device): void {
    this.server.to(`device-${device.id}`).emit('device-status', {
      deviceId: device.deviceId,
      status: device.status,
      isOnline: device.isOnline,
      lastStatusChange: device.lastStatusChange,
    });
  }
}
```

## Step 6: Main Application Module

```typescript
// src/app.module.ts
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
        database: configService.get('DB_DATABASE'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    ScheduleModule.forRoot(),
    MqttModule,
    NotificationModule,
    SensorModule,
    DeviceModule,
    RedisModule,
    WebSocketModule,
    ReportModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule implements OnModuleInit {
  constructor(
    private notificationService: NotificationService,
    private schedulerRegistry: SchedulerRegistry,
  ) {}

  onModuleInit() {
    // Schedule re-notification check every minute
    const interval = setInterval(
      () => this.notificationService.checkAndResendNotifications(),
      60000,
    );

    this.schedulerRegistry.addInterval('re-notification-check', interval);
  }
}
```

## Step 7: Configuration Files

```typescript
// src/config/notification.config.ts
export default () => ({
  notification: {
    cooldownPeriods: {
      normal: 0,
      warning: 300, // 5 minutes
      alarm: 600,   // 10 minutes
    },
    channels: {
      line: {
        enabled: process.env.LINE_ENABLED === 'true',
        accessToken: process.env.LINE_ACCESS_TOKEN,
      },
      discord: {
        enabled: process.env.DISCORD_ENABLED === 'true',
      },
      telegram: {
        enabled: process.env.TELEGRAM_ENABLED === 'true',
        botToken: process.env.TELEGRAM_BOT_TOKEN,
      },
      sms: {
        enabled: process.env.SMS_ENABLED === 'true',
        provider: process.env.SMS_PROVIDER,
        apiKey: process.env.SMS_API_KEY,
      },
    },
    mqtt: {
      brokerUrl: process.env.MQTT_BROKER_URL || 'mqtt://localhost:1883',
      topics: [
        'sensors/+/data',
        'devices/+/status',
        'devices/+/control',
      ],
    },
    redis: {
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT || '6379', 10),
      password: process.env.REDIS_PASSWORD,
    },
  },
});
```

## Installation & Setup

```bash
# 1. Create new NestJS project
npm i -g @nestjs/cli
nest new notification-system
cd notification-system

# 2. Install required dependencies
npm install @nestjs/typeorm typeorm pg
npm install @nestjs/microservices mqtt
npm install @nestjs/websocket socket.io
npm install @nestjs/schedule
npm install redis ioredis
npm install @line/bot-sdk discord.js node-telegram-bot-api twilio
npm install axios class-validator class-transformer
npm install @nestjs/config

# 3. Environment variables (.env)
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_DATABASE=notification_system
MQTT_BROKER_URL=mqtt://localhost:1883
REDIS_HOST=localhost
REDIS_PORT=6379
LINE_ENABLED=false
LINE_ACCESS_TOKEN=your_line_token
DISCORD_ENABLED=false
TELEGRAM_ENABLED=false
TELEGRAM_BOT_TOKEN=your_telegram_token
SMS_ENABLED=false
SMS_PROVIDER=twilio
SMS_API_KEY=your_sms_api_key

# 4. Run migrations
npm run typeorm migration:generate -- -n InitialSetup
npm run typeorm migration:run

# 5. Start the application
npm run start:dev
```

## Key Features Implemented:

1. **MQTT Integration**: Real-time sensor data ingestion
2. **Rule-based Notification**: Flexible condition checking
3. **Multi-channel Support**: Line, Discord, Telegram, SMS, Web Dashboard
4. **Cooldown Management**: Using Redis for rate limiting
5. **Real-time Updates**: WebSocket for dashboard notifications
6. **Device Control**: MQTT commands for device control
7. **Re-notification**: Automatic resend based on status
8. **Comprehensive Logging**: All notifications tracked
9. **Reporting Ready**: Structured data for dashboards
10. **Scalable Architecture**: Module-based, extensible design

This system provides a robust foundation that can be extended with additional features like AI chatbot integration, advanced reporting, and machine learning-based anomaly detection.