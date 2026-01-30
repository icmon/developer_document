# ระบบ Notification System ด้วย NestJS

ผมต้องการสร้าง ระบบ notification  system โดยใช้
NustJS framwork By Node JS
หลักการทำงานของระบบ
1.รับข้อมูลจากเซ็นเซอร์ ผ่าน MQTT
2.ตรวจสอบเงื่อนไข กับค่าที่ตั้งไว้
3.อัปเดตสถานะ และบันทึกประวัติ
4.สร้างการแจ้งเตือน ตามระดับความสำคัญ
5.ตรวจสอบ cooldown ด้วย Redis หรือ notification  alarm configuration 
6.ส่งผ่านช่องทางต่างๆ ตามการตั้งค่า
	6.1.line notification
	6.2.discord notification
	6.3.telegram notification
	6.4.sms notification
	6.5.web dashboard notification
	6.7.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
7.บันทึกผลการส่ง และอัปเดตสถานะ แยก ประเภท 
	7.1.line notification
	7.2.discord notification
	7.3.telegram notification
	7.4.sms notification
	7.5.web dashboard notification
	7.7.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
8.แจ้งเตือนผ่าน WebSocket สำหรับ Real-time
	8.1.web dashboard notification
	8.2.ส่งค่าไป function สั่ง เปิด ปิด อุปกรณ์  หรือ สั่ง ให้ หุ่นยนต์ ทำงาน หรือ หยุดทำงาน 
9.จัดการการแจ้งซ้ำ ตามสถานะและเวลาที่กำหนด
  9.1.นำเวลาแจ่งเตียน ล่าสุด มา เทียเวลาปจุบัน เกิน ค่าที่กำหนดไหม เช่น 10 นาที 
     table prefix sd_
     table sd_notification_type
	   1.Normal  หากยัง มีสถานะ  
	   2.Worming 3.Recovery Worming  
	   3.Alarm    
	   4.Recovery Alarm  
   ให้เจ้งเตียนซ้ำทุก  10 นาที  หาก  Normal  ให้แเจ้งเตียน หยุด  สถานะ Normal แล้วหยุด แเจ้งเตียน
        table sd_notification_type
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
 



ออกแบบรูป monitorring  htnl 5 CSS  ICON 
URL : https://preview.tabler.io
ICON : https://preview.tabler.io/icons.html

การแสดง ข้อมูล 
1.ชื่อ Device sensor
2.ข้อมูล sensor เช่น  humidity  56 %
3.ข้อมูล สถานะ  เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
4.แสดงสัญลักษณ์ icon
5.แสดงสี  ไฟกระพริบ 1.Normal สีเขียว 2.Worming สีส้ม 3.Alarm  สีแดง
6.แสดง history log สถานะ

1.ชื่อ Device IO เช่น  Air Conditioner
2.ข้อมูล Device IO เช่น   Air  ON / OFF
3.ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
4.แสดงสัญลักษณ์ icon
5.แสดง history log สถานะ



ออกแบบรูป monitorring  htnl 5 CSS  ICON 
URL : https://preview.tabler.io
ICON : https://preview.tabler.io/icons.html

การแสดง ข้อมูล 
1.ชื่อ Device sensor
2.ข้อมูล sensor เช่น  humidity  56 %
3.ข้อมูล สถานะ  เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
4.แสดงสัญลักษณ์ icon
5.แสดงสี  ไฟกระพริบ 1.Normal สีเขียว 2.Worming สีส้ม 3.Alarm  สีแดง
6.แสดง history log สถานะ

1.ชื่อ Device IO เช่น  Air Conditioner
2.ข้อมูล Device IO เช่น   Air  ON / OFF
3.ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
4.แสดงสัญลักษณ์ icon
5.แสดง history log สถานะ


group 1
 sensor  
   - temperature sensor
   - humidity sensor
   - CO2 sensor 
   - O2 sensor (Oxygen Sensor)

group 2
 sensor 
    -temperature sensor
    -humidity sensor
    -Smoke Detector sensor
    	-Smoke Detector (เซ็นเซอร์ตรวจจับควัน)
    	-Heat Detector (เซ็นเซอร์ตรวจจับความร้อน):
	-Rate-of-Rise: ตรวจจับการเพิ่มขึ้นของอุณหภูมิอย่างรวดเร็ว.
	-Fixed Temperature: ตรวจจับเมื่ออุณหภูมิถึงระดับที่กำหนดไว้.

group 3
 sensor 
     -Temperature sensor
     -Volt sensor
     -Amp sensor
     -Water Leak Detection sensor
       --Wire and Spot Leak Detection
 IO
     -Switch ON  OFF status
group 4
  ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -input1 IO 
    -Air Conditioner 1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Air Conditioner 2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -water leak  สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -HSSD sensor  High Sensitivity Smoke Detection (ระบบตรวจจับควันไฟความไวสูง) 
      สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Door sensor ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง เซ็นเซอร์ประตู (Door Sensor) คืออุปกรณ์ตรวจจับการเปิด-ปิดประตู (หรือหน้าต่าง, ตู้) 

group 5.แสดง history log สถานะ
   1.ชื่อ Device 
   2.ข้อมูล Device เช่น  humidity  56 %
   3.วันเวลา
   4.สถานะ เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm




``` 


# ระบบ Notification System ด้วย NestJS

## 1. ออกแบบระบบ Notification Data Flow

```
Data Flow Diagram:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Device    │────▶│    MQTT     │────▶│  NestJS     │
│  (Sensor)   │     │   Broker    │     │   Server    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                                │
                                                ▼
                                       ┌─────────────────┐
                                       │  Redis Cache    │
                                       │  (Rate Limit)   │
                                       └─────────────────┘
                                                │
                                                ▼
                                       ┌─────────────────┐
                                       │  Notification   │
                                       │   Processor     │
                                       └──────┬──────┬──────┘
                                              │      │
                                              ▼      ▼
                                      ┌─────────┐ ┌─────────┐
                                      │PostgreSQL│ │Socket.IO│
                                      │ Database │ │ Clients │
                                      └─────────┘ └─────────┘
                                              │
                                              ▼
                                   ┌─────────────────────┐
                                   │ Notification        │
                                   │ Delivery Service    │
                                   └─┬──┬──┬──┬──┬──┬──┬┘
                                     │  │  │  │  │  │  │
                                     ▼  ▼  ▼  ▼  ▼  ▼  ▼
                                    LINE,Discord,Telegram,
                                    SMS,AI Bot,Email,etc.
```

## 2. ออกแบบ Table Database PostgreSQL

```sql
-- สร้าง Enum Types
CREATE TYPE notification_status AS ENUM ('PENDING', 'SENT', 'FAILED', 'READ');
CREATE TYPE alarm_status AS ENUM ('NORMAL', 'WARNING', 'RECOVERY_WARNING', 'ALARM', 'RECOVERY_ALARM');
CREATE TYPE channel_type AS ENUM ('LINE', 'DISCORD', 'TELEGRAM', 'SMS', 'AI_CHAT_BOT', 'EMAIL', 'WEB_PUSH');

-- ตารางอุปกรณ์
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_name VARCHAR(255) NOT NULL,
    device_type VARCHAR(100),
    description TEXT,
    location VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางข้อมูลเซ็นเซอร์
CREATE TABLE sensor_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    pressure DECIMAL(7,2),
    other_data JSONB,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_recorded (device_id, recorded_at DESC)
);

-- ตารางเงื่อนไขแจ้งเตือน
CREATE TABLE alarm_conditions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    condition_name VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(50) NOT NULL, -- 'temperature', 'humidity', etc.
    operator VARCHAR(10) NOT NULL, -- '>', '<', '>=', '<=', '=', '!='
    threshold_value DECIMAL(10,2) NOT NULL,
    alarm_status alarm_status NOT NULL DEFAULT 'WARNING',
    cooldown_minutes INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางประวัติสถานะ
CREATE TABLE alarm_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    alarm_condition_id UUID REFERENCES alarm_conditions(id),
    previous_status alarm_status,
    current_status alarm_status NOT NULL,
    sensor_value DECIMAL(10,2),
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovered_at TIMESTAMP,
    INDEX idx_device_status (device_id, current_status, triggered_at DESC)
);

-- ตารางช่องทางการแจ้งเตือน
CREATE TABLE notification_channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_type channel_type NOT NULL,
    channel_name VARCHAR(255) NOT NULL,
    config JSONB NOT NULL, -- เก็บ configuration เช่น token, webhook url
    is_active BOOLEAN DEFAULT true,
    rate_limit_per_minute INTEGER DEFAULT 60,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางการตั้งค่าแจ้งเตือนตามระดับ
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL DEFAULT 1, -- 1-5 (ระดับความสำคัญ)
    title_template VARCHAR(500),
    message_template VARCHAR(2000),
    require_acknowledgment BOOLEAN DEFAULT false,
    escalation_minutes INTEGER DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(alarm_status, notification_level)
);

-- ตารางการแมปช่องทางกับสถานะ
CREATE TABLE status_channel_mapping (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL,
    channel_id UUID REFERENCES notification_channels(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(alarm_status, notification_level, channel_id)
);

-- ตารางแจ้งเตือน
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id),
    alarm_history_id UUID REFERENCES alarm_history(id),
    notification_level INTEGER NOT NULL,
    title VARCHAR(500) NOT NULL,
    message TEXT NOT NULL,
    status notification_status DEFAULT 'PENDING',
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notification_status (status, scheduled_for),
    INDEX idx_device_notifications (device_id, created_at DESC)
);

-- ตารางรายงานการส่ง
CREATE TABLE notification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    channel_id UUID REFERENCES notification_channels(id),
    channel_type channel_type NOT NULL,
    status notification_status NOT NULL,
    response_data JSONB,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    retry_count INTEGER DEFAULT 0,
    INDEX idx_channel_logs (channel_id, attempted_at DESC)
);

-- ตารางผู้ใช้และการยืนยัน
CREATE TABLE user_acknowledgments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    user_id UUID, -- อ้างอิง users table ถ้ามี
    acknowledged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledgment_note TEXT,
    INDEX idx_user_ack (notification_id, user_id)
);
```

## 3. TypeORM Entities

```typescript
// src/entities/device.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { SensorData } from './sensor-data.entity';
import { AlarmCondition } from './alarm-condition.entity';

@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  deviceName: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  deviceType: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  location: string;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => SensorData, sensorData => sensorData.device)
  sensorData: SensorData[];

  @OneToMany(() => AlarmCondition, alarmCondition => alarmCondition.device)
  alarmConditions: AlarmCondition[];
}

// src/entities/sensor-data.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';

@Entity('sensor_data')
@Index(['deviceId', 'recordedAt'])
export class SensorData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.sensorData)
  device: Device;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  temperature: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  humidity: number;

  @Column({ type: 'decimal', precision: 7, scale: 2, nullable: true })
  pressure: number;

  @Column({ type: 'jsonb', nullable: true })
  otherData: Record<string, any>;

  @CreateDateColumn()
  recordedAt: Date;
}

// src/entities/alarm-condition.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Device } from './device.entity';

export enum AlarmStatus {
  NORMAL = 'NORMAL',
  WARNING = 'WARNING',
  RECOVERY_WARNING = 'RECOVERY_WARNING',
  ALARM = 'ALARM',
  RECOVERY_ALARM = 'RECOVERY_ALARM'
}

@Entity('alarm_conditions')
export class AlarmCondition {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.alarmConditions)
  device: Device;

  @Column({ type: 'varchar', length: 255 })
  conditionName: string;

  @Column({ type: 'varchar', length: 50 })
  sensorType: string;

  @Column({ type: 'varchar', length: 10 })
  operator: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  thresholdValue: number;

  @Column({ 
    type: 'enum', 
    enum: AlarmStatus,
    default: AlarmStatus.WARNING
  })
  alarmStatus: AlarmStatus;

  @Column({ type: 'int', default: 10 })
  cooldownMinutes: number;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;
}

// src/entities/notification.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';
import { AlarmHistory } from './alarm-history.entity';

export enum NotificationStatus {
  PENDING = 'PENDING',
  SENT = 'SENT',
  FAILED = 'FAILED',
  READ = 'READ'
}

@Entity('notifications')
@Index(['status', 'scheduledFor'])
@Index(['deviceId', 'createdAt'])
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid', { nullable: true })
  deviceId: string;

  @ManyToOne(() => Device, { nullable: true })
  device: Device;

  @Column('uuid', { nullable: true })
  alarmHistoryId: string;

  @ManyToOne(() => AlarmHistory, { nullable: true })
  alarmHistory: AlarmHistory;

  @Column({ type: 'int' })
  notificationLevel: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({
    type: 'enum',
    enum: NotificationStatus,
    default: NotificationStatus.PENDING
  })
  status: NotificationStatus;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  scheduledFor: Date;

  @Column({ type: 'timestamp', nullable: true })
  sentAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  readAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
```

## 4. Quit (Queue) System Design

### Redis Configuration:
```typescript
// src/config/redis.config.ts
export const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT) || 6379,
  password: process.env.REDIS_PASSWORD,
  db: parseInt(process.env.REDIS_DB) || 0,
  keyPrefix: 'notification:',
  ttl: {
    deviceStatus: 300, // 5 minutes
    rateLimit: 60, // 1 minute
    notificationLock: 30, // 30 seconds
  }
};
```

### Redis Queues:
```typescript
// src/queues/notification.queue.ts
import { Queue, Worker } from 'bullmq';
import IORedis from 'ioredis';

export class NotificationQueue {
  private connection: IORedis;
  private queue: Queue;
  
  constructor() {
    this.connection = new IORedis(redisConfig);
    this.queue = new Queue('notification-processing', { connection: this.connection });
  }
  
  async addNotificationJob(data: any) {
    return await this.queue.add('process-notification', data, {
      attempts: 3,
      backoff: {
        type: 'exponential',
        delay: 1000
      }
    });
  }
}

// Worker สำหรับประมวลผล
const notificationWorker = new Worker('notification-processing', async job => {
  // ประมวลผลการแจ้งเตือน
  console.log('Processing notification:', job.data);
}, { connection: new IORedis(redisConfig) });
```

### Socket.IO Configuration:
```typescript
// src/gateways/notification.gateway.ts
import { WebSocketGateway, WebSocketServer, SubscribeMessage, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { RedisService } from '../services/redis.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'notifications'
})
export class NotificationGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;
  
  private connectedClients = new Map<string, Socket>();
  
  constructor(private readonly redisService: RedisService) {}
  
  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    if (userId) {
      this.connectedClients.set(userId, client);
      client.join(`user:${userId}`);
      
      // ส่ง notification ที่ยังไม่ได้อ่าน
      this.sendUnreadNotifications(userId);
    }
  }
  
  handleDisconnect(client: Socket) {
    for (const [userId, socket] of this.connectedClients.entries()) {
      if (socket.id === client.id) {
        this.connectedClients.delete(userId);
        break;
      }
    }
  }
  
  @SubscribeMessage('acknowledge-notification')
  handleAcknowledge(client: Socket, data: { notificationId: string }) {
    // จัดการการยืนยันรับทราบ
    this.server.emit('notification-acknowledged', data);
  }
  
  sendNotificationToUser(userId: string, notification: any) {
    this.server.to(`user:${userId}`).emit('new-notification', notification);
  }
  
  sendNotificationToAll(notification: any) {
    this.server.emit('new-notification', notification);
  }
  
  private async sendUnreadNotifications(userId: string) {
    // ดึง notification ที่ยังไม่ได้อ่านจาก Redis/Database
    // ส่งไปยัง client
  }
}
```

### MQTT Integration:
```typescript
// src/services/mqtt.service.ts
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import * as mqtt from 'mqtt';
import { NotificationService } from './notification.service';

@Injectable()
export class MqttService implements OnModuleInit, OnModuleDestroy {
  private client: mqtt.MqttClient;
  
  constructor(private readonly notificationService: NotificationService) {}
  
  async onModuleInit() {
    this.client = mqtt.connect(process.env.MQTT_BROKER_URL || 'mqtt://localhost:1883', {
      username: process.env.MQTT_USERNAME,
      password: process.env.MQTT_PASSWORD,
      clientId: `notification-service-${process.pid}`
    });
    
    this.client.on('connect', () => {
      console.log('Connected to MQTT broker');
      this.client.subscribe('devices/+/sensors');
      this.client.subscribe('devices/+/status');
    });
    
    this.client.on('message', async (topic, message) => {
      await this.handleMessage(topic, message.toString());
    });
  }
  
  async handleMessage(topic: string, message: string) {
    try {
      const data = JSON.parse(message);
      const topicParts = topic.split('/');
      const deviceId = topicParts[1];
      
      switch (topicParts[2]) {
        case 'sensors':
          await this.notificationService.processSensorData(deviceId, data);
          break;
        case 'status':
          await this.notificationService.processDeviceStatus(deviceId, data);
          break;
      }
    } catch (error) {
      console.error('Error processing MQTT message:', error);
    }
  }
  
  onModuleDestroy() {
    if (this.client) {
      this.client.end();
    }
  }
}
```

## 5. ระบบตั้งค่า Notification

### Notification Configuration Service:
```typescript
// src/services/notification-config.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AlarmStatus, AlarmCondition } from '../entities/alarm-condition.entity';
import { NotificationSetting } from '../entities/notification-setting.entity';
import { StatusChannelMapping } from '../entities/status-channel-mapping.entity';

@Injectable()
export class NotificationConfigService {
  constructor(
    @InjectRepository(AlarmCondition)
    private alarmConditionRepo: Repository<AlarmCondition>,
    @InjectRepository(NotificationSetting)
    private notificationSettingRepo: Repository<NotificationSetting>,
    @InjectRepository(StatusChannelMapping)
    private channelMappingRepo: Repository<StatusChannelMapping>,
  ) {}
  
  // ตั้งค่าเงื่อนไขแจ้งเตือน
  async createAlarmCondition(data: Partial<AlarmCondition>) {
    return await this.alarmConditionRepo.save(data);
  }
  
  // ตั้งค่าระดับความสำคัญ
  async setNotificationLevel(alarmStatus: AlarmStatus, level: number, config: any) {
    const setting = await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level }
    });
    
    if (setting) {
      await this.notificationSettingRepo.update(setting.id, config);
    } else {
      await this.notificationSettingRepo.save({
        alarmStatus,
        notificationLevel: level,
        ...config
      });
    }
  }
  
  // เพิ่มช่องทางการแจ้งเตือนตามสถานะ
  async addChannelToStatus(
    alarmStatus: AlarmStatus,
    level: number,
    channelId: string,
    priority: number = 1
  ) {
    return await this.channelMappingRepo.save({
      alarmStatus,
      notificationLevel: level,
      channelId,
      priority,
      isActive: true
    });
  }
  
  // ดึงการตั้งค่าตามสถานะ
  async getNotificationConfig(alarmStatus: AlarmStatus, level: number) {
    return await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level },
      relations: ['channelMappings', 'channelMappings.channel']
    });
  }
}
```

## 6. Modules และ REST API

```typescript
// src/modules/notification/notification.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { NotificationGateway } from '../../gateways/notification.gateway';
import { MqttService } from '../../services/mqtt.service';
import { RedisService } from '../../services/redis.service';
import { NotificationQueue } from '../../queues/notification.queue';
import { 
  Device, 
  SensorData, 
  AlarmCondition, 
  AlarmHistory,
  Notification,
  NotificationLog,
  NotificationChannel,
  NotificationSetting,
  StatusChannelMapping
} from '../../entities';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Device,
      SensorData,
      AlarmCondition,
      AlarmHistory,
      Notification,
      NotificationLog,
      NotificationChannel,
      NotificationSetting,
      StatusChannelMapping
    ])
  ],
  controllers: [NotificationController],
  providers: [
    NotificationService,
    NotificationGateway,
    MqttService,
    RedisService,
    NotificationQueue
  ],
  exports: [NotificationService]
})
export class NotificationModule {}
```

```typescript
// src/modules/notification/notification.controller.ts
import { Controller, Get, Post, Put, Delete, Body, Param, Query } from '@nestjs/common';
import { NotificationService } from './notification.service';

@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}
  
  @Get()
  async getNotifications(@Query() query: any) {
    return await this.notificationService.getNotifications(query);
  }
  
  @Get('unread')
  async getUnreadNotifications(@Query('userId') userId: string) {
    return await this.notificationService.getUnreadNotifications(userId);
  }
  
  @Post('acknowledge/:id')
  async acknowledgeNotification(
    @Param('id') id: string,
    @Body() body: { userId: string, note?: string }
  ) {
    return await this.notificationService.acknowledgeNotification(id, body.userId, body.note);
  }
  
  @Get('reports/daily')
  async getDailyReport(@Query('date') date: string) {
    return await this.notificationService.getDailyReport(date);
  }
  
  @Get('reports/device/:deviceId')
  async getDeviceReport(
    @Param('deviceId') deviceId: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string
  ) {
    return await this.notificationService.getDeviceReport(deviceId, startDate, endDate);
  }
}
```

## 7. ระบบ Level Notification

```typescript
// src/services/notification-level.service.ts
import { Injectable } from '@nestjs/common';
import { AlarmStatus } from '../entities/alarm-condition.entity';

export enum NotificationLevel {
  INFO = 1,      // Normal status
  WARNING = 2,   // Warning status
  ALERT = 3,     // Recovery Warning
  CRITICAL = 4,  // Alarm status
  EMERGENCY = 5  // Recovery Alarm
}

@Injectable()
export class NotificationLevelService {
  private readonly statusToLevelMap: Map<AlarmStatus, NotificationLevel> = new Map([
    [AlarmStatus.NORMAL, NotificationLevel.INFO],
    [AlarmStatus.WARNING, NotificationLevel.WARNING],
    [AlarmStatus.RECOVERY_WARNING, NotificationLevel.ALERT],
    [AlarmStatus.ALARM, NotificationLevel.CRITICAL],
    [AlarmStatus.RECOVERY_ALARM, NotificationLevel.EMERGENCY]
  ]);
  
  private readonly levelConfig = {
    [NotificationLevel.INFO]: {
      cooldown: 0,           // ไม่ต้องแจ้งซ้ำ
      retryInterval: 0,
      escalationTime: 0,
      channels: ['WEB_PUSH']
    },
    [NotificationLevel.WARNING]: {
      cooldown: 10,          // 10 นาที
      retryInterval: 600000, // 10 นาทีในมิลลิวินาที
      escalationTime: 30,    // 30 นาทีถึงระดับถัดไป
      channels: ['WEB_PUSH', 'EMAIL']
    },
    [NotificationLevel.ALERT]: {
      cooldown: 5,           // 5 นาที
      retryInterval: 300000, // 5 นาที
      escalationTime: 15,    // 15 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE']
    },
    [NotificationLevel.CRITICAL]: {
      cooldown: 2,           // 2 นาที
      retryInterval: 120000, // 2 นาที
      escalationTime: 5,     // 5 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE', 'TELEGRAM', 'SMS']
    },
    [NotificationLevel.EMERGENCY]: {
      cooldown: 1,           // 1 นาที
      retryInterval: 60000,  // 1 นาที
      escalationTime: 2,     // 2 นาที
      channels: ['ALL_CHANNELS']
    }
  };
  
  getLevelForStatus(status: AlarmStatus): NotificationLevel {
    return this.statusToLevelMap.get(status) || NotificationLevel.INFO;
  }
  
  getLevelConfig(level: NotificationLevel) {
    return this.levelConfig[level] || this.levelConfig[NotificationLevel.INFO];
  }
  
  shouldResendNotification(
    lastSent: Date,
    currentLevel: NotificationLevel,
    currentStatus: AlarmStatus
  ): boolean {
    const config = this.getLevelConfig(currentLevel);
    
    // ถ้าเป็น NORMAL ไม่ต้องส่งซ้ำ
    if (currentStatus === AlarmStatus.NORMAL) {
      return false;
    }
    
    const now = new Date();
    const timeDiff = now.getTime() - lastSent.getTime();
    
    // เช็คว่าเกิน cooldown หรือยัง
    return timeDiff >= config.retryInterval;
  }
  
  getNextEscalationLevel(currentLevel: NotificationLevel): NotificationLevel {
    const levels = Object.values(NotificationLevel).filter(v => typeof v === 'number') as number[];
    const currentIndex = levels.indexOf(currentLevel);
    
    if (currentIndex < levels.length - 1) {
      return levels[currentIndex + 1] as NotificationLevel;
    }
    
    return currentLevel;
  }
}
```

## 8. หน้ารายงาน (Reporting Dashboard)

### Report Service:
```typescript
// src/services/report.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Notification } from '../entities/notification.entity';
import { AlarmHistory } from '../entities/alarm-history.entity';
import { NotificationLog } from '../entities/notification-log.entity';

@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,
    @InjectRepository(AlarmHistory)
    private alarmHistoryRepo: Repository<AlarmHistory>,
    @InjectRepository(NotificationLog)
    private notificationLogRepo: Repository<NotificationLog>,
  ) {}
  
  async getDailyReport(date: Date) {
    const startDate = new Date(date);
    startDate.setHours(0, 0, 0, 0);
    
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);
    
    const [notifications, alarms, logs] = await Promise.all([
      this.notificationRepo.find({
        where: {
          createdAt: Between(startDate, endDate)
        }
      }),
      this.alarmHistoryRepo.find({
        where: {
          triggeredAt: Between(startDate, endDate)
        }
      }),
      this.notificationLogRepo.createQueryBuilder('log')
        .select('channel_type, COUNT(*) as count, status')
        .where('log.attempted_at BETWEEN :start AND :end', {
          start: startDate,
          end: endDate
        })
        .groupBy('log.channel_type, log.status')
        .getRawMany()
    ]);
    
    return {
      date,
      summary: {
        totalNotifications: notifications.length,
        totalAlarms: alarms.length,
        sentNotifications: notifications.filter(n => n.status === 'SENT').length,
        failedNotifications: notifications.filter(n => n.status === 'FAILED').length,
        readNotifications: notifications.filter(n => n.readAt !== null).length,
      },
      byChannel: logs.reduce((acc, log) => {
        if (!acc[log.channel_type]) {
          acc[log.channel_type] = { sent: 0, failed: 0 };
        }
        if (log.status === 'SENT') {
          acc[log.channel_type].sent += parseInt(log.count);
        } else {
          acc[log.channel_type].failed += parseInt(log.count);
        }
        return acc;
      }, {}),
      recentAlarms: alarms.slice(0, 10),
      recentNotifications: notifications.slice(0, 10)
    };
  }
  
  async getDeviceReport(deviceId: string, startDate: Date, endDate: Date) {
    const [alarms, notifications] = await Promise.all([
      this.alarmHistoryRepo.find({
        where: {
          deviceId,
          triggeredAt: Between(startDate, endDate)
        },
        order: { triggeredAt: 'DESC' }
      }),
      this.notificationRepo.find({
        where: {
          deviceId,
          createdAt: Between(startDate, endDate)
        },
        order: { createdAt: 'DESC' }
      })
    ]);
    
    // คำนวณสถิติ
    const statusCount = alarms.reduce((acc, alarm) => {
      acc[alarm.current_status] = (acc[alarm.current_status] || 0) + 1;
      return acc;
    }, {});
    
    const averageResponseTime = await this.calculateAverageResponseTime(deviceId, startDate, endDate);
    
    return {
      deviceId,
      period: { startDate, endDate },
      statistics: {
        totalAlarms: alarms.length,
        totalNotifications: notifications.length,
        statusDistribution: statusCount,
        averageResponseTime,
        uptimePercentage: this.calculateUptime(alarms)
      },
      timeline: alarms.map(alarm => ({
        time: alarm.triggeredAt,
        status: alarm.current_status,
        value: alarm.sensor_value,
        notification: notifications.find(n => n.alarmHistoryId === alarm.id)
      }))
    };
  }
  
  private async calculateAverageResponseTime(deviceId: string, startDate: Date, endDate: Date): Promise<number> {
    const result = await this.alarmHistoryRepo.createQueryBuilder('alarm')
      .select('AVG(EXTRACT(EPOCH FROM (recovered_at - triggered_at)))', 'avgResponse')
      .where('device_id = :deviceId', { deviceId })
      .andWhere('recovered_at IS NOT NULL')
      .andWhere('triggered_at BETWEEN :start AND :end', { start: startDate, end: endDate })
      .getRawOne();
    
    return parseFloat(result?.avgResponse || '0');
  }
  
  private calculateUptime(alarms: AlarmHistory[]): number {
    if (alarms.length === 0) return 100;
    
    const normalAlarms = alarms.filter(a => a.current_status === 'NORMAL');
    return (normalAlarms.length / alarms.length) * 100;
  }
}
```

## 9. Main Application Structure

```typescript
// src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  
  const port = configService.get('PORT') || 3000;
  await app.listen(port);
  console.log(`Notification system running on port ${port}`);
}
bootstrap();

// src/app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { NotificationModule } from './modules/notification/notification.module';
import { ReportModule } from './modules/report/report.module';
import { ConfigurationModule } from './modules/configuration/configuration.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
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
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    NotificationModule,
    ReportModule,
    ConfigurationModule,
  ],
})
export class AppModule {}
```

## 10. Environment Variables (.env)

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
REDIS_DB=0

# MQTT
MQTT_BROKER_URL=mqtt://localhost:1883
MQTT_USERNAME=
MQTT_PASSWORD=

# Notification Channels
LINE_CHANNEL_ACCESS_TOKEN=
DISCORD_WEBHOOK_URL=
TELEGRAM_BOT_TOKEN=
SMS_PROVIDER_API_KEY=
AI_CHAT_BOT_WEBHOOK=

# Application
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key
```

## 11. Package.json Dependencies

```json
{
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/platform-socket.io": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "@nestjs/websockets": "^9.0.0",
    "@nestjs/schedule": "^9.0.0",
    "@nestjs/config": "^9.0.0",
    "typeorm": "^0.3.0",
    "pg": "^8.0.0",
    "socket.io": "^4.5.0",
    "mqtt": "^4.0.0",
    "ioredis": "^5.0.0",
    "bullmq": "^3.0.0",
    "axios": "^1.0.0",
    "class-validator": "^0.13.0",
    "class-transformer": "^0.5.0"
  }
}
```

## 12. การทำงานของระบบทั้งหมด

1. **รับข้อมูลจากเซ็นเซอร์** ผ่าน MQTT
2. **ตรวจสอบเงื่อนไข** กับค่าที่ตั้งไว้
3. **อัปเดตสถานะ** และบันทึกประวัติ
4. **สร้างการแจ้งเตือน** ตามระดับความสำคัญ
5. **ตรวจสอบ cooldown** ด้วย Redis
6. **ส่งผ่านช่องทางต่างๆ** ตามการตั้งค่า
7. **บันทึกผลการส่ง** และอัปเดตสถานะ
8. **แจ้งเตือนผ่าน WebSocket** สำหรับ Real-time
9. **จัดการการแจ้งซ้ำ** ตามสถานะและเวลาที่กำหนด
10. **เก็บข้อมูลรายงาน** สำหรับ Dashboard

ระบบนี้สามารถขยายได้ง่ายด้วยการเพิ่มช่องทางการแจ้งเตือนใหม่ หรือปรับแต่งเงื่อนไขการแจ้งเตือนผ่าน API ที่มีให้
 



ออกแบบรูป monitorring  htnl 5 CSS  ICON 
URL : https://preview.tabler.io
ICON : https://preview.tabler.io/icons.html

การแสดง ข้อมูล 
1.ชื่อ Device sensor
2.ข้อมูล sensor เช่น  humidity  56 %
3.ข้อมูล สถานะ  เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm
4.แสดงสัญลักษณ์ icon
5.แสดงสี  ไฟกระพริบ 1.Normal สีเขียว 2.Worming สีส้ม 3.Alarm  สีแดง
6.แสดง history log สถานะ

1.ชื่อ Device IO เช่น  Air Conditioner
2.ข้อมูล Device IO เช่น   Air  ON / OFF
3.ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
4.แสดงสัญลักษณ์ icon
5.แสดง history log สถานะ


group 1
 sensor  
   - temperature sensor
   - humidity sensor
   - CO2 sensor 
   - O2 sensor (Oxygen Sensor)

group 2
 sensor 
    -temperature sensor
    -humidity sensor
    -Smoke Detector sensor
    	-Smoke Detector (เซ็นเซอร์ตรวจจับควัน)
    	-Heat Detector (เซ็นเซอร์ตรวจจับความร้อน):
	-Rate-of-Rise: ตรวจจับการเพิ่มขึ้นของอุณหภูมิอย่างรวดเร็ว.
	-Fixed Temperature: ตรวจจับเมื่ออุณหภูมิถึงระดับที่กำหนดไว้.

group 3
 sensor 
     -Temperature sensor
     -Volt sensor
     -Amp sensor
     -Water Leak Detection sensor
       --Wire and Spot Leak Detection
 IO
     -Switch ON  OFF status
group 4
  ข้อมูล สถานะการทำงาน  Device IO เช่น  ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -input1 IO 
    -Air Conditioner 1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Air Conditioner 2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS1 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -UPS2 สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -water leak  สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -HSSD sensor  High Sensitivity Smoke Detection (ระบบตรวจจับควันไฟความไวสูง) 
      สถานะการทำงาน   ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง
    -Door sensor ไฟกระพริบ 1.ON สีเขียว 2.OFF  สีแดง เซ็นเซอร์ประตู (Door Sensor) คืออุปกรณ์ตรวจจับการเปิด-ปิดประตู (หรือหน้าต่าง, ตู้) 

group 5.แสดง history log สถานะ
   1.ชื่อ Device 
   2.ข้อมูล Device เช่น  humidity  56 %
   3.วันเวลา
   4.สถานะ เช่น  1.Normal  2.Worming 3.Recovery Worming  3.Alarm    4.Recovery Alarm




``` 


# ระบบ Notification System ด้วย NestJS

## 1. ออกแบบระบบ Notification Data Flow

```
Data Flow Diagram:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Device    │────▶│    MQTT     │────▶│  NestJS     │
│  (Sensor)   │     │   Broker    │     │   Server    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                                │
                                                ▼
                                       ┌─────────────────┐
                                       │  Redis Cache    │
                                       │  (Rate Limit)   │
                                       └─────────────────┘
                                                │
                                                ▼
                                       ┌─────────────────┐
                                       │  Notification   │
                                       │   Processor     │
                                       └──────┬──────┬──────┘
                                              │      │
                                              ▼      ▼
                                      ┌─────────┐ ┌─────────┐
                                      │PostgreSQL│ │Socket.IO│
                                      │ Database │ │ Clients │
                                      └─────────┘ └─────────┘
                                              │
                                              ▼
                                   ┌─────────────────────┐
                                   │ Notification        │
                                   │ Delivery Service    │
                                   └─┬──┬──┬──┬──┬──┬──┬┘
                                     │  │  │  │  │  │  │
                                     ▼  ▼  ▼  ▼  ▼  ▼  ▼
                                    LINE,Discord,Telegram,
                                    SMS,AI Bot,Email,etc.
```

## 2. ออกแบบ Table Database PostgreSQL

```sql
-- สร้าง Enum Types
CREATE TYPE notification_status AS ENUM ('PENDING', 'SENT', 'FAILED', 'READ');
CREATE TYPE alarm_status AS ENUM ('NORMAL', 'WARNING', 'RECOVERY_WARNING', 'ALARM', 'RECOVERY_ALARM');
CREATE TYPE channel_type AS ENUM ('LINE', 'DISCORD', 'TELEGRAM', 'SMS', 'AI_CHAT_BOT', 'EMAIL', 'WEB_PUSH');

-- ตารางอุปกรณ์
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_name VARCHAR(255) NOT NULL,
    device_type VARCHAR(100),
    description TEXT,
    location VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางข้อมูลเซ็นเซอร์
CREATE TABLE sensor_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    pressure DECIMAL(7,2),
    other_data JSONB,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_recorded (device_id, recorded_at DESC)
);

-- ตารางเงื่อนไขแจ้งเตือน
CREATE TABLE alarm_conditions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    condition_name VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(50) NOT NULL, -- 'temperature', 'humidity', etc.
    operator VARCHAR(10) NOT NULL, -- '>', '<', '>=', '<=', '=', '!='
    threshold_value DECIMAL(10,2) NOT NULL,
    alarm_status alarm_status NOT NULL DEFAULT 'WARNING',
    cooldown_minutes INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางประวัติสถานะ
CREATE TABLE alarm_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    alarm_condition_id UUID REFERENCES alarm_conditions(id),
    previous_status alarm_status,
    current_status alarm_status NOT NULL,
    sensor_value DECIMAL(10,2),
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovered_at TIMESTAMP,
    INDEX idx_device_status (device_id, current_status, triggered_at DESC)
);

-- ตารางช่องทางการแจ้งเตือน
CREATE TABLE notification_channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_type channel_type NOT NULL,
    channel_name VARCHAR(255) NOT NULL,
    config JSONB NOT NULL, -- เก็บ configuration เช่น token, webhook url
    is_active BOOLEAN DEFAULT true,
    rate_limit_per_minute INTEGER DEFAULT 60,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางการตั้งค่าแจ้งเตือนตามระดับ
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL DEFAULT 1, -- 1-5 (ระดับความสำคัญ)
    title_template VARCHAR(500),
    message_template VARCHAR(2000),
    require_acknowledgment BOOLEAN DEFAULT false,
    escalation_minutes INTEGER DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(alarm_status, notification_level)
);

-- ตารางการแมปช่องทางกับสถานะ
CREATE TABLE status_channel_mapping (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL,
    channel_id UUID REFERENCES notification_channels(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(alarm_status, notification_level, channel_id)
);

-- ตารางแจ้งเตือน
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id),
    alarm_history_id UUID REFERENCES alarm_history(id),
    notification_level INTEGER NOT NULL,
    title VARCHAR(500) NOT NULL,
    message TEXT NOT NULL,
    status notification_status DEFAULT 'PENDING',
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notification_status (status, scheduled_for),
    INDEX idx_device_notifications (device_id, created_at DESC)
);

-- ตารางรายงานการส่ง
CREATE TABLE notification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    channel_id UUID REFERENCES notification_channels(id),
    channel_type channel_type NOT NULL,
    status notification_status NOT NULL,
    response_data JSONB,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    retry_count INTEGER DEFAULT 0,
    INDEX idx_channel_logs (channel_id, attempted_at DESC)
);

-- ตารางผู้ใช้และการยืนยัน
CREATE TABLE user_acknowledgments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    user_id UUID, -- อ้างอิง users table ถ้ามี
    acknowledged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledgment_note TEXT,
    INDEX idx_user_ack (notification_id, user_id)
);
```

## 3. TypeORM Entities

```typescript
// src/entities/device.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { SensorData } from './sensor-data.entity';
import { AlarmCondition } from './alarm-condition.entity';

@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  deviceName: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  deviceType: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  location: string;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => SensorData, sensorData => sensorData.device)
  sensorData: SensorData[];

  @OneToMany(() => AlarmCondition, alarmCondition => alarmCondition.device)
  alarmConditions: AlarmCondition[];
}

// src/entities/sensor-data.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';

@Entity('sensor_data')
@Index(['deviceId', 'recordedAt'])
export class SensorData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.sensorData)
  device: Device;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  temperature: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  humidity: number;

  @Column({ type: 'decimal', precision: 7, scale: 2, nullable: true })
  pressure: number;

  @Column({ type: 'jsonb', nullable: true })
  otherData: Record<string, any>;

  @CreateDateColumn()
  recordedAt: Date;
}

// src/entities/alarm-condition.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Device } from './device.entity';

export enum AlarmStatus {
  NORMAL = 'NORMAL',
  WARNING = 'WARNING',
  RECOVERY_WARNING = 'RECOVERY_WARNING',
  ALARM = 'ALARM',
  RECOVERY_ALARM = 'RECOVERY_ALARM'
}

@Entity('alarm_conditions')
export class AlarmCondition {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.alarmConditions)
  device: Device;

  @Column({ type: 'varchar', length: 255 })
  conditionName: string;

  @Column({ type: 'varchar', length: 50 })
  sensorType: string;

  @Column({ type: 'varchar', length: 10 })
  operator: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  thresholdValue: number;

  @Column({ 
    type: 'enum', 
    enum: AlarmStatus,
    default: AlarmStatus.WARNING
  })
  alarmStatus: AlarmStatus;

  @Column({ type: 'int', default: 10 })
  cooldownMinutes: number;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;
}

// src/entities/notification.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';
import { AlarmHistory } from './alarm-history.entity';

export enum NotificationStatus {
  PENDING = 'PENDING',
  SENT = 'SENT',
  FAILED = 'FAILED',
  READ = 'READ'
}

@Entity('notifications')
@Index(['status', 'scheduledFor'])
@Index(['deviceId', 'createdAt'])
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid', { nullable: true })
  deviceId: string;

  @ManyToOne(() => Device, { nullable: true })
  device: Device;

  @Column('uuid', { nullable: true })
  alarmHistoryId: string;

  @ManyToOne(() => AlarmHistory, { nullable: true })
  alarmHistory: AlarmHistory;

  @Column({ type: 'int' })
  notificationLevel: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({
    type: 'enum',
    enum: NotificationStatus,
    default: NotificationStatus.PENDING
  })
  status: NotificationStatus;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  scheduledFor: Date;

  @Column({ type: 'timestamp', nullable: true })
  sentAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  readAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
```

## 4. Quit (Queue) System Design

### Redis Configuration:
```typescript
// src/config/redis.config.ts
export const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT) || 6379,
  password: process.env.REDIS_PASSWORD,
  db: parseInt(process.env.REDIS_DB) || 0,
  keyPrefix: 'notification:',
  ttl: {
    deviceStatus: 300, // 5 minutes
    rateLimit: 60, // 1 minute
    notificationLock: 30, // 30 seconds
  }
};
```

### Redis Queues:
```typescript
// src/queues/notification.queue.ts
import { Queue, Worker } from 'bullmq';
import IORedis from 'ioredis';

export class NotificationQueue {
  private connection: IORedis;
  private queue: Queue;
  
  constructor() {
    this.connection = new IORedis(redisConfig);
    this.queue = new Queue('notification-processing', { connection: this.connection });
  }
  
  async addNotificationJob(data: any) {
    return await this.queue.add('process-notification', data, {
      attempts: 3,
      backoff: {
        type: 'exponential',
        delay: 1000
      }
    });
  }
}

// Worker สำหรับประมวลผล
const notificationWorker = new Worker('notification-processing', async job => {
  // ประมวลผลการแจ้งเตือน
  console.log('Processing notification:', job.data);
}, { connection: new IORedis(redisConfig) });
```

### Socket.IO Configuration:
```typescript
// src/gateways/notification.gateway.ts
import { WebSocketGateway, WebSocketServer, SubscribeMessage, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { RedisService } from '../services/redis.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'notifications'
})
export class NotificationGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;
  
  private connectedClients = new Map<string, Socket>();
  
  constructor(private readonly redisService: RedisService) {}
  
  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    if (userId) {
      this.connectedClients.set(userId, client);
      client.join(`user:${userId}`);
      
      // ส่ง notification ที่ยังไม่ได้อ่าน
      this.sendUnreadNotifications(userId);
    }
  }
  
  handleDisconnect(client: Socket) {
    for (const [userId, socket] of this.connectedClients.entries()) {
      if (socket.id === client.id) {
        this.connectedClients.delete(userId);
        break;
      }
    }
  }
  
  @SubscribeMessage('acknowledge-notification')
  handleAcknowledge(client: Socket, data: { notificationId: string }) {
    // จัดการการยืนยันรับทราบ
    this.server.emit('notification-acknowledged', data);
  }
  
  sendNotificationToUser(userId: string, notification: any) {
    this.server.to(`user:${userId}`).emit('new-notification', notification);
  }
  
  sendNotificationToAll(notification: any) {
    this.server.emit('new-notification', notification);
  }
  
  private async sendUnreadNotifications(userId: string) {
    // ดึง notification ที่ยังไม่ได้อ่านจาก Redis/Database
    // ส่งไปยัง client
  }
}
```

### MQTT Integration:
```typescript
// src/services/mqtt.service.ts
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import * as mqtt from 'mqtt';
import { NotificationService } from './notification.service';

@Injectable()
export class MqttService implements OnModuleInit, OnModuleDestroy {
  private client: mqtt.MqttClient;
  
  constructor(private readonly notificationService: NotificationService) {}
  
  async onModuleInit() {
    this.client = mqtt.connect(process.env.MQTT_BROKER_URL || 'mqtt://localhost:1883', {
      username: process.env.MQTT_USERNAME,
      password: process.env.MQTT_PASSWORD,
      clientId: `notification-service-${process.pid}`
    });
    
    this.client.on('connect', () => {
      console.log('Connected to MQTT broker');
      this.client.subscribe('devices/+/sensors');
      this.client.subscribe('devices/+/status');
    });
    
    this.client.on('message', async (topic, message) => {
      await this.handleMessage(topic, message.toString());
    });
  }
  
  async handleMessage(topic: string, message: string) {
    try {
      const data = JSON.parse(message);
      const topicParts = topic.split('/');
      const deviceId = topicParts[1];
      
      switch (topicParts[2]) {
        case 'sensors':
          await this.notificationService.processSensorData(deviceId, data);
          break;
        case 'status':
          await this.notificationService.processDeviceStatus(deviceId, data);
          break;
      }
    } catch (error) {
      console.error('Error processing MQTT message:', error);
    }
  }
  
  onModuleDestroy() {
    if (this.client) {
      this.client.end();
    }
  }
}
```

## 5. ระบบตั้งค่า Notification

### Notification Configuration Service:
```typescript
// src/services/notification-config.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AlarmStatus, AlarmCondition } from '../entities/alarm-condition.entity';
import { NotificationSetting } from '../entities/notification-setting.entity';
import { StatusChannelMapping } from '../entities/status-channel-mapping.entity';

@Injectable()
export class NotificationConfigService {
  constructor(
    @InjectRepository(AlarmCondition)
    private alarmConditionRepo: Repository<AlarmCondition>,
    @InjectRepository(NotificationSetting)
    private notificationSettingRepo: Repository<NotificationSetting>,
    @InjectRepository(StatusChannelMapping)
    private channelMappingRepo: Repository<StatusChannelMapping>,
  ) {}
  
  // ตั้งค่าเงื่อนไขแจ้งเตือน
  async createAlarmCondition(data: Partial<AlarmCondition>) {
    return await this.alarmConditionRepo.save(data);
  }
  
  // ตั้งค่าระดับความสำคัญ
  async setNotificationLevel(alarmStatus: AlarmStatus, level: number, config: any) {
    const setting = await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level }
    });
    
    if (setting) {
      await this.notificationSettingRepo.update(setting.id, config);
    } else {
      await this.notificationSettingRepo.save({
        alarmStatus,
        notificationLevel: level,
        ...config
      });
    }
  }
  
  // เพิ่มช่องทางการแจ้งเตือนตามสถานะ
  async addChannelToStatus(
    alarmStatus: AlarmStatus,
    level: number,
    channelId: string,
    priority: number = 1
  ) {
    return await this.channelMappingRepo.save({
      alarmStatus,
      notificationLevel: level,
      channelId,
      priority,
      isActive: true
    });
  }
  
  // ดึงการตั้งค่าตามสถานะ
  async getNotificationConfig(alarmStatus: AlarmStatus, level: number) {
    return await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level },
      relations: ['channelMappings', 'channelMappings.channel']
    });
  }
}
```

## 6. Modules และ REST API

```typescript
// src/modules/notification/notification.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { NotificationGateway } from '../../gateways/notification.gateway';
import { MqttService } from '../../services/mqtt.service';
import { RedisService } from '../../services/redis.service';
import { NotificationQueue } from '../../queues/notification.queue';
import { 
  Device, 
  SensorData, 
  AlarmCondition, 
  AlarmHistory,
  Notification,
  NotificationLog,
  NotificationChannel,
  NotificationSetting,
  StatusChannelMapping
} from '../../entities';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Device,
      SensorData,
      AlarmCondition,
      AlarmHistory,
      Notification,
      NotificationLog,
      NotificationChannel,
      NotificationSetting,
      StatusChannelMapping
    ])
  ],
  controllers: [NotificationController],
  providers: [
    NotificationService,
    NotificationGateway,
    MqttService,
    RedisService,
    NotificationQueue
  ],
  exports: [NotificationService]
})
export class NotificationModule {}
```

```typescript
// src/modules/notification/notification.controller.ts
import { Controller, Get, Post, Put, Delete, Body, Param, Query } from '@nestjs/common';
import { NotificationService } from './notification.service';

@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}
  
  @Get()
  async getNotifications(@Query() query: any) {
    return await this.notificationService.getNotifications(query);
  }
  
  @Get('unread')
  async getUnreadNotifications(@Query('userId') userId: string) {
    return await this.notificationService.getUnreadNotifications(userId);
  }
  
  @Post('acknowledge/:id')
  async acknowledgeNotification(
    @Param('id') id: string,
    @Body() body: { userId: string, note?: string }
  ) {
    return await this.notificationService.acknowledgeNotification(id, body.userId, body.note);
  }
  
  @Get('reports/daily')
  async getDailyReport(@Query('date') date: string) {
    return await this.notificationService.getDailyReport(date);
  }
  
  @Get('reports/device/:deviceId')
  async getDeviceReport(
    @Param('deviceId') deviceId: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string
  ) {
    return await this.notificationService.getDeviceReport(deviceId, startDate, endDate);
  }
}
```

## 7. ระบบ Level Notification

```typescript
// src/services/notification-level.service.ts
import { Injectable } from '@nestjs/common';
import { AlarmStatus } from '../entities/alarm-condition.entity';

export enum NotificationLevel {
  INFO = 1,      // Normal status
  WARNING = 2,   // Warning status
  ALERT = 3,     // Recovery Warning
  CRITICAL = 4,  // Alarm status
  EMERGENCY = 5  // Recovery Alarm
}

@Injectable()
export class NotificationLevelService {
  private readonly statusToLevelMap: Map<AlarmStatus, NotificationLevel> = new Map([
    [AlarmStatus.NORMAL, NotificationLevel.INFO],
    [AlarmStatus.WARNING, NotificationLevel.WARNING],
    [AlarmStatus.RECOVERY_WARNING, NotificationLevel.ALERT],
    [AlarmStatus.ALARM, NotificationLevel.CRITICAL],
    [AlarmStatus.RECOVERY_ALARM, NotificationLevel.EMERGENCY]
  ]);
  
  private readonly levelConfig = {
    [NotificationLevel.INFO]: {
      cooldown: 0,           // ไม่ต้องแจ้งซ้ำ
      retryInterval: 0,
      escalationTime: 0,
      channels: ['WEB_PUSH']
    },
    [NotificationLevel.WARNING]: {
      cooldown: 10,          // 10 นาที
      retryInterval: 600000, // 10 นาทีในมิลลิวินาที
      escalationTime: 30,    // 30 นาทีถึงระดับถัดไป
      channels: ['WEB_PUSH', 'EMAIL']
    },
    [NotificationLevel.ALERT]: {
      cooldown: 5,           // 5 นาที
      retryInterval: 300000, // 5 นาที
      escalationTime: 15,    // 15 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE']
    },
    [NotificationLevel.CRITICAL]: {
      cooldown: 2,           // 2 นาที
      retryInterval: 120000, // 2 นาที
      escalationTime: 5,     // 5 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE', 'TELEGRAM', 'SMS']
    },
    [NotificationLevel.EMERGENCY]: {
      cooldown: 1,           // 1 นาที
      retryInterval: 60000,  // 1 นาที
      escalationTime: 2,     // 2 นาที
      channels: ['ALL_CHANNELS']
    }
  };
  
  getLevelForStatus(status: AlarmStatus): NotificationLevel {
    return this.statusToLevelMap.get(status) || NotificationLevel.INFO;
  }
  
  getLevelConfig(level: NotificationLevel) {
    return this.levelConfig[level] || this.levelConfig[NotificationLevel.INFO];
  }
  
  shouldResendNotification(
    lastSent: Date,
    currentLevel: NotificationLevel,
    currentStatus: AlarmStatus
  ): boolean {
    const config = this.getLevelConfig(currentLevel);
    
    // ถ้าเป็น NORMAL ไม่ต้องส่งซ้ำ
    if (currentStatus === AlarmStatus.NORMAL) {
      return false;
    }
    
    const now = new Date();
    const timeDiff = now.getTime() - lastSent.getTime();
    
    // เช็คว่าเกิน cooldown หรือยัง
    return timeDiff >= config.retryInterval;
  }
  
  getNextEscalationLevel(currentLevel: NotificationLevel): NotificationLevel {
    const levels = Object.values(NotificationLevel).filter(v => typeof v === 'number') as number[];
    const currentIndex = levels.indexOf(currentLevel);
    
    if (currentIndex < levels.length - 1) {
      return levels[currentIndex + 1] as NotificationLevel;
    }
    
    return currentLevel;
  }
}
```

## 8. หน้ารายงาน (Reporting Dashboard)

### Report Service:
```typescript
// src/services/report.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Notification } from '../entities/notification.entity';
import { AlarmHistory } from '../entities/alarm-history.entity';
import { NotificationLog } from '../entities/notification-log.entity';

@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,
    @InjectRepository(AlarmHistory)
    private alarmHistoryRepo: Repository<AlarmHistory>,
    @InjectRepository(NotificationLog)
    private notificationLogRepo: Repository<NotificationLog>,
  ) {}
  
  async getDailyReport(date: Date) {
    const startDate = new Date(date);
    startDate.setHours(0, 0, 0, 0);
    
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);
    
    const [notifications, alarms, logs] = await Promise.all([
      this.notificationRepo.find({
        where: {
          createdAt: Between(startDate, endDate)
        }
      }),
      this.alarmHistoryRepo.find({
        where: {
          triggeredAt: Between(startDate, endDate)
        }
      }),
      this.notificationLogRepo.createQueryBuilder('log')
        .select('channel_type, COUNT(*) as count, status')
        .where('log.attempted_at BETWEEN :start AND :end', {
          start: startDate,
          end: endDate
        })
        .groupBy('log.channel_type, log.status')
        .getRawMany()
    ]);
    
    return {
      date,
      summary: {
        totalNotifications: notifications.length,
        totalAlarms: alarms.length,
        sentNotifications: notifications.filter(n => n.status === 'SENT').length,
        failedNotifications: notifications.filter(n => n.status === 'FAILED').length,
        readNotifications: notifications.filter(n => n.readAt !== null).length,
      },
      byChannel: logs.reduce((acc, log) => {
        if (!acc[log.channel_type]) {
          acc[log.channel_type] = { sent: 0, failed: 0 };
        }
        if (log.status === 'SENT') {
          acc[log.channel_type].sent += parseInt(log.count);
        } else {
          acc[log.channel_type].failed += parseInt(log.count);
        }
        return acc;
      }, {}),
      recentAlarms: alarms.slice(0, 10),
      recentNotifications: notifications.slice(0, 10)
    };
  }
  
  async getDeviceReport(deviceId: string, startDate: Date, endDate: Date) {
    const [alarms, notifications] = await Promise.all([
      this.alarmHistoryRepo.find({
        where: {
          deviceId,
          triggeredAt: Between(startDate, endDate)
        },
        order: { triggeredAt: 'DESC' }
      }),
      this.notificationRepo.find({
        where: {
          deviceId,
          createdAt: Between(startDate, endDate)
        },
        order: { createdAt: 'DESC' }
      })
    ]);
    
    // คำนวณสถิติ
    const statusCount = alarms.reduce((acc, alarm) => {
      acc[alarm.current_status] = (acc[alarm.current_status] || 0) + 1;
      return acc;
    }, {});
    
    const averageResponseTime = await this.calculateAverageResponseTime(deviceId, startDate, endDate);
    
    return {
      deviceId,
      period: { startDate, endDate },
      statistics: {
        totalAlarms: alarms.length,
        totalNotifications: notifications.length,
        statusDistribution: statusCount,
        averageResponseTime,
        uptimePercentage: this.calculateUptime(alarms)
      },
      timeline: alarms.map(alarm => ({
        time: alarm.triggeredAt,
        status: alarm.current_status,
        value: alarm.sensor_value,
        notification: notifications.find(n => n.alarmHistoryId === alarm.id)
      }))
    };
  }
  
  private async calculateAverageResponseTime(deviceId: string, startDate: Date, endDate: Date): Promise<number> {
    const result = await this.alarmHistoryRepo.createQueryBuilder('alarm')
      .select('AVG(EXTRACT(EPOCH FROM (recovered_at - triggered_at)))', 'avgResponse')
      .where('device_id = :deviceId', { deviceId })
      .andWhere('recovered_at IS NOT NULL')
      .andWhere('triggered_at BETWEEN :start AND :end', { start: startDate, end: endDate })
      .getRawOne();
    
    return parseFloat(result?.avgResponse || '0');
  }
  
  private calculateUptime(alarms: AlarmHistory[]): number {
    if (alarms.length === 0) return 100;
    
    const normalAlarms = alarms.filter(a => a.current_status === 'NORMAL');
    return (normalAlarms.length / alarms.length) * 100;
  }
}
```

## 9. Main Application Structure

```typescript
// src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  
  const port = configService.get('PORT') || 3000;
  await app.listen(port);
  console.log(`Notification system running on port ${port}`);
}
bootstrap();

// src/app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { NotificationModule } from './modules/notification/notification.module';
import { ReportModule } from './modules/report/report.module';
import { ConfigurationModule } from './modules/configuration/configuration.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
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
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    NotificationModule,
    ReportModule,
    ConfigurationModule,
  ],
})
export class AppModule {}
```

## 10. Environment Variables (.env)

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
REDIS_DB=0

# MQTT
MQTT_BROKER_URL=mqtt://localhost:1883
MQTT_USERNAME=
MQTT_PASSWORD=

# Notification Channels
LINE_CHANNEL_ACCESS_TOKEN=
DISCORD_WEBHOOK_URL=
TELEGRAM_BOT_TOKEN=
SMS_PROVIDER_API_KEY=
AI_CHAT_BOT_WEBHOOK=

# Application
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key
```

## 11. Package.json Dependencies

```json
{
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/platform-socket.io": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "@nestjs/websockets": "^9.0.0",
    "@nestjs/schedule": "^9.0.0",
    "@nestjs/config": "^9.0.0",
    "typeorm": "^0.3.0",
    "pg": "^8.0.0",
    "socket.io": "^4.5.0",
    "mqtt": "^4.0.0",
    "ioredis": "^5.0.0",
    "bullmq": "^3.0.0",
    "axios": "^1.0.0",
    "class-validator": "^0.13.0",
    "class-transformer": "^0.5.0"
  }
}
```

## 12. การทำงานของระบบทั้งหมด

1. **รับข้อมูลจากเซ็นเซอร์** ผ่าน MQTT
2. **ตรวจสอบเงื่อนไข** กับค่าที่ตั้งไว้
3. **อัปเดตสถานะ** และบันทึกประวัติ
4. **สร้างการแจ้งเตือน** ตามระดับความสำคัญ
5. **ตรวจสอบ cooldown** ด้วย Redis
6. **ส่งผ่านช่องทางต่างๆ** ตามการตั้งค่า
7. **บันทึกผลการส่ง** และอัปเดตสถานะ
8. **แจ้งเตือนผ่าน WebSocket** สำหรับ Real-time
9. **จัดการการแจ้งซ้ำ** ตามสถานะและเวลาที่กำหนด
10. **เก็บข้อมูลรายงาน** สำหรับ Dashboard

ระบบนี้สามารถขยายได้ง่ายด้วยการเพิ่มช่องทางการแจ้งเตือนใหม่ หรือปรับแต่งเงื่อนไขการแจ้งเตือนผ่าน API ที่มีให้


## 1. ออกแบบระบบ Notification Data Flow

```
Data Flow Diagram:
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Device    │────▶│    MQTT     │────▶│  NestJS     │
│  (Sensor)   │     │   Broker    │     │   Server    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                                │
                                                ▼
                                       ┌─────────────────┐
                                       │  Redis Cache    │
                                       │  (Rate Limit)   │
                                       └─────────────────┘
                                                │
                                                ▼
                                       ┌────────────────────┐
                                       │  Notification      │
                                       │   Processor        │
                                       └──────┬──────┬──────┘
                                              │      │
                                              ▼      ▼
                                      ┌──────────┐ ┌─────────┐
                                      │PostgreSQL│ │Socket.IO│
                                      │ Database │ │ Clients │
                                      └──────────┘ └─────────┘
                                              │
                                              ▼
                                   ┌─────────────────────┐
                                   │ Notification        │
                                   │ Delivery Service    │
                                   └─┬──┬──┬──┬──┬──┬──┬─┘
                                     │  │  │  │  │  │  │
                                     ▼  ▼  ▼  ▼  ▼  ▼  ▼
                                    LINE,Discord,Telegram,
                                    SMS,AI Bot,Email,etc.
```

## 2. ออกแบบ Table Database PostgreSQL

```sql
-- สร้าง Enum Types
CREATE TYPE notification_status AS ENUM ('PENDING', 'SENT', 'FAILED', 'READ');
CREATE TYPE alarm_status AS ENUM ('NORMAL', 'WARNING', 'RECOVERY_WARNING', 'ALARM', 'RECOVERY_ALARM');
CREATE TYPE channel_type AS ENUM ('LINE', 'DISCORD', 'TELEGRAM', 'SMS', 'AI_CHAT_BOT', 'EMAIL', 'WEB_PUSH');

-- ตารางอุปกรณ์
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_name VARCHAR(255) NOT NULL,
    device_type VARCHAR(100),
    description TEXT,
    location VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางข้อมูลเซ็นเซอร์
CREATE TABLE sensor_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    pressure DECIMAL(7,2),
    other_data JSONB,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_device_recorded (device_id, recorded_at DESC)
);

-- ตารางเงื่อนไขแจ้งเตือน
CREATE TABLE alarm_conditions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    condition_name VARCHAR(255) NOT NULL,
    sensor_type VARCHAR(50) NOT NULL, -- 'temperature', 'humidity', etc.
    operator VARCHAR(10) NOT NULL, -- '>', '<', '>=', '<=', '=', '!='
    threshold_value DECIMAL(10,2) NOT NULL,
    alarm_status alarm_status NOT NULL DEFAULT 'WARNING',
    cooldown_minutes INTEGER DEFAULT 10,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางประวัติสถานะ
CREATE TABLE alarm_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    alarm_condition_id UUID REFERENCES alarm_conditions(id),
    previous_status alarm_status,
    current_status alarm_status NOT NULL,
    sensor_value DECIMAL(10,2),
    triggered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recovered_at TIMESTAMP,
    INDEX idx_device_status (device_id, current_status, triggered_at DESC)
);

-- ตารางช่องทางการแจ้งเตือน
CREATE TABLE notification_channels (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    channel_type channel_type NOT NULL,
    channel_name VARCHAR(255) NOT NULL,
    config JSONB NOT NULL, -- เก็บ configuration เช่น token, webhook url
    is_active BOOLEAN DEFAULT true,
    rate_limit_per_minute INTEGER DEFAULT 60,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ตารางการตั้งค่าแจ้งเตือนตามระดับ
CREATE TABLE notification_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL DEFAULT 1, -- 1-5 (ระดับความสำคัญ)
    title_template VARCHAR(500),
    message_template VARCHAR(2000),
    require_acknowledgment BOOLEAN DEFAULT false,
    escalation_minutes INTEGER DEFAULT 30,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(alarm_status, notification_level)
);

-- ตารางการแมปช่องทางกับสถานะ
CREATE TABLE status_channel_mapping (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alarm_status alarm_status NOT NULL,
    notification_level INTEGER NOT NULL,
    channel_id UUID REFERENCES notification_channels(id) ON DELETE CASCADE,
    priority INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(alarm_status, notification_level, channel_id)
);

-- ตารางแจ้งเตือน
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id UUID REFERENCES devices(id),
    alarm_history_id UUID REFERENCES alarm_history(id),
    notification_level INTEGER NOT NULL,
    title VARCHAR(500) NOT NULL,
    message TEXT NOT NULL,
    status notification_status DEFAULT 'PENDING',
    scheduled_for TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_notification_status (status, scheduled_for),
    INDEX idx_device_notifications (device_id, created_at DESC)
);

-- ตารางรายงานการส่ง
CREATE TABLE notification_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    channel_id UUID REFERENCES notification_channels(id),
    channel_type channel_type NOT NULL,
    status notification_status NOT NULL,
    response_data JSONB,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at TIMESTAMP,
    retry_count INTEGER DEFAULT 0,
    INDEX idx_channel_logs (channel_id, attempted_at DESC)
);

-- ตารางผู้ใช้และการยืนยัน
CREATE TABLE user_acknowledgments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,
    user_id UUID, -- อ้างอิง users table ถ้ามี
    acknowledged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    acknowledgment_note TEXT,
    INDEX idx_user_ack (notification_id, user_id)
);
```

## 3. TypeORM Entities

```typescript
// src/entities/device.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { SensorData } from './sensor-data.entity';
import { AlarmCondition } from './alarm-condition.entity';

@Entity('devices')
export class Device {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'varchar', length: 255 })
  deviceName: string;

  @Column({ type: 'varchar', length: 100, nullable: true })
  deviceType: string;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  location: string;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @OneToMany(() => SensorData, sensorData => sensorData.device)
  sensorData: SensorData[];

  @OneToMany(() => AlarmCondition, alarmCondition => alarmCondition.device)
  alarmConditions: AlarmCondition[];
}

// src/entities/sensor-data.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';

@Entity('sensor_data')
@Index(['deviceId', 'recordedAt'])
export class SensorData {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.sensorData)
  device: Device;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  temperature: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, nullable: true })
  humidity: number;

  @Column({ type: 'decimal', precision: 7, scale: 2, nullable: true })
  pressure: number;

  @Column({ type: 'jsonb', nullable: true })
  otherData: Record<string, any>;

  @CreateDateColumn()
  recordedAt: Date;
}

// src/entities/alarm-condition.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Device } from './device.entity';

export enum AlarmStatus {
  NORMAL = 'NORMAL',
  WARNING = 'WARNING',
  RECOVERY_WARNING = 'RECOVERY_WARNING',
  ALARM = 'ALARM',
  RECOVERY_ALARM = 'RECOVERY_ALARM'
}

@Entity('alarm_conditions')
export class AlarmCondition {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  deviceId: string;

  @ManyToOne(() => Device, device => device.alarmConditions)
  device: Device;

  @Column({ type: 'varchar', length: 255 })
  conditionName: string;

  @Column({ type: 'varchar', length: 50 })
  sensorType: string;

  @Column({ type: 'varchar', length: 10 })
  operator: string;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  thresholdValue: number;

  @Column({ 
    type: 'enum', 
    enum: AlarmStatus,
    default: AlarmStatus.WARNING
  })
  alarmStatus: AlarmStatus;

  @Column({ type: 'int', default: 10 })
  cooldownMinutes: number;

  @Column({ type: 'boolean', default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;
}

// src/entities/notification.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, Index } from 'typeorm';
import { Device } from './device.entity';
import { AlarmHistory } from './alarm-history.entity';

export enum NotificationStatus {
  PENDING = 'PENDING',
  SENT = 'SENT',
  FAILED = 'FAILED',
  READ = 'READ'
}

@Entity('notifications')
@Index(['status', 'scheduledFor'])
@Index(['deviceId', 'createdAt'])
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid', { nullable: true })
  deviceId: string;

  @ManyToOne(() => Device, { nullable: true })
  device: Device;

  @Column('uuid', { nullable: true })
  alarmHistoryId: string;

  @ManyToOne(() => AlarmHistory, { nullable: true })
  alarmHistory: AlarmHistory;

  @Column({ type: 'int' })
  notificationLevel: number;

  @Column({ type: 'varchar', length: 500 })
  title: string;

  @Column({ type: 'text' })
  message: string;

  @Column({
    type: 'enum',
    enum: NotificationStatus,
    default: NotificationStatus.PENDING
  })
  status: NotificationStatus;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  scheduledFor: Date;

  @Column({ type: 'timestamp', nullable: true })
  sentAt: Date;

  @Column({ type: 'timestamp', nullable: true })
  readAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
```

## 4. Quit (Queue) System Design

### Redis Configuration:
```typescript
// src/config/redis.config.ts
export const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT) || 6379,
  password: process.env.REDIS_PASSWORD,
  db: parseInt(process.env.REDIS_DB) || 0,
  keyPrefix: 'notification:',
  ttl: {
    deviceStatus: 300, // 5 minutes
    rateLimit: 60, // 1 minute
    notificationLock: 30, // 30 seconds
  }
};
```

### Redis Queues:
```typescript
// src/queues/notification.queue.ts
import { Queue, Worker } from 'bullmq';
import IORedis from 'ioredis';

export class NotificationQueue {
  private connection: IORedis;
  private queue: Queue;
  
  constructor() {
    this.connection = new IORedis(redisConfig);
    this.queue = new Queue('notification-processing', { connection: this.connection });
  }
  
  async addNotificationJob(data: any) {
    return await this.queue.add('process-notification', data, {
      attempts: 3,
      backoff: {
        type: 'exponential',
        delay: 1000
      }
    });
  }
}

// Worker สำหรับประมวลผล
const notificationWorker = new Worker('notification-processing', async job => {
  // ประมวลผลการแจ้งเตือน
  console.log('Processing notification:', job.data);
}, { connection: new IORedis(redisConfig) });
```

### Socket.IO Configuration:
```typescript
// src/gateways/notification.gateway.ts
import { WebSocketGateway, WebSocketServer, SubscribeMessage, OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { RedisService } from '../services/redis.service';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
  namespace: 'notifications'
})
export class NotificationGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;
  
  private connectedClients = new Map<string, Socket>();
  
  constructor(private readonly redisService: RedisService) {}
  
  handleConnection(client: Socket) {
    const userId = client.handshake.query.userId as string;
    if (userId) {
      this.connectedClients.set(userId, client);
      client.join(`user:${userId}`);
      
      // ส่ง notification ที่ยังไม่ได้อ่าน
      this.sendUnreadNotifications(userId);
    }
  }
  
  handleDisconnect(client: Socket) {
    for (const [userId, socket] of this.connectedClients.entries()) {
      if (socket.id === client.id) {
        this.connectedClients.delete(userId);
        break;
      }
    }
  }
  
  @SubscribeMessage('acknowledge-notification')
  handleAcknowledge(client: Socket, data: { notificationId: string }) {
    // จัดการการยืนยันรับทราบ
    this.server.emit('notification-acknowledged', data);
  }
  
  sendNotificationToUser(userId: string, notification: any) {
    this.server.to(`user:${userId}`).emit('new-notification', notification);
  }
  
  sendNotificationToAll(notification: any) {
    this.server.emit('new-notification', notification);
  }
  
  private async sendUnreadNotifications(userId: string) {
    // ดึง notification ที่ยังไม่ได้อ่านจาก Redis/Database
    // ส่งไปยัง client
  }
}
```

### MQTT Integration:
```typescript
// src/services/mqtt.service.ts
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import * as mqtt from 'mqtt';
import { NotificationService } from './notification.service';

@Injectable()
export class MqttService implements OnModuleInit, OnModuleDestroy {
  private client: mqtt.MqttClient;
  
  constructor(private readonly notificationService: NotificationService) {}
  
  async onModuleInit() {
    this.client = mqtt.connect(process.env.MQTT_BROKER_URL || 'mqtt://localhost:1883', {
      username: process.env.MQTT_USERNAME,
      password: process.env.MQTT_PASSWORD,
      clientId: `notification-service-${process.pid}`
    });
    
    this.client.on('connect', () => {
      console.log('Connected to MQTT broker');
      this.client.subscribe('devices/+/sensors');
      this.client.subscribe('devices/+/status');
    });
    
    this.client.on('message', async (topic, message) => {
      await this.handleMessage(topic, message.toString());
    });
  }
  
  async handleMessage(topic: string, message: string) {
    try {
      const data = JSON.parse(message);
      const topicParts = topic.split('/');
      const deviceId = topicParts[1];
      
      switch (topicParts[2]) {
        case 'sensors':
          await this.notificationService.processSensorData(deviceId, data);
          break;
        case 'status':
          await this.notificationService.processDeviceStatus(deviceId, data);
          break;
      }
    } catch (error) {
      console.error('Error processing MQTT message:', error);
    }
  }
  
  onModuleDestroy() {
    if (this.client) {
      this.client.end();
    }
  }
}
```

## 5. ระบบตั้งค่า Notification

### Notification Configuration Service:
```typescript
// src/services/notification-config.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AlarmStatus, AlarmCondition } from '../entities/alarm-condition.entity';
import { NotificationSetting } from '../entities/notification-setting.entity';
import { StatusChannelMapping } from '../entities/status-channel-mapping.entity';

@Injectable()
export class NotificationConfigService {
  constructor(
    @InjectRepository(AlarmCondition)
    private alarmConditionRepo: Repository<AlarmCondition>,
    @InjectRepository(NotificationSetting)
    private notificationSettingRepo: Repository<NotificationSetting>,
    @InjectRepository(StatusChannelMapping)
    private channelMappingRepo: Repository<StatusChannelMapping>,
  ) {}
  
  // ตั้งค่าเงื่อนไขแจ้งเตือน
  async createAlarmCondition(data: Partial<AlarmCondition>) {
    return await this.alarmConditionRepo.save(data);
  }
  
  // ตั้งค่าระดับความสำคัญ
  async setNotificationLevel(alarmStatus: AlarmStatus, level: number, config: any) {
    const setting = await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level }
    });
    
    if (setting) {
      await this.notificationSettingRepo.update(setting.id, config);
    } else {
      await this.notificationSettingRepo.save({
        alarmStatus,
        notificationLevel: level,
        ...config
      });
    }
  }
  
  // เพิ่มช่องทางการแจ้งเตือนตามสถานะ
  async addChannelToStatus(
    alarmStatus: AlarmStatus,
    level: number,
    channelId: string,
    priority: number = 1
  ) {
    return await this.channelMappingRepo.save({
      alarmStatus,
      notificationLevel: level,
      channelId,
      priority,
      isActive: true
    });
  }
  
  // ดึงการตั้งค่าตามสถานะ
  async getNotificationConfig(alarmStatus: AlarmStatus, level: number) {
    return await this.notificationSettingRepo.findOne({
      where: { alarmStatus, notificationLevel: level },
      relations: ['channelMappings', 'channelMappings.channel']
    });
  }
}
```

## 6. Modules และ REST API

```typescript
// src/modules/notification/notification.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';
import { NotificationGateway } from '../../gateways/notification.gateway';
import { MqttService } from '../../services/mqtt.service';
import { RedisService } from '../../services/redis.service';
import { NotificationQueue } from '../../queues/notification.queue';
import { 
  Device, 
  SensorData, 
  AlarmCondition, 
  AlarmHistory,
  Notification,
  NotificationLog,
  NotificationChannel,
  NotificationSetting,
  StatusChannelMapping
} from '../../entities';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Device,
      SensorData,
      AlarmCondition,
      AlarmHistory,
      Notification,
      NotificationLog,
      NotificationChannel,
      NotificationSetting,
      StatusChannelMapping
    ])
  ],
  controllers: [NotificationController],
  providers: [
    NotificationService,
    NotificationGateway,
    MqttService,
    RedisService,
    NotificationQueue
  ],
  exports: [NotificationService]
})
export class NotificationModule {}
```

```typescript
// src/modules/notification/notification.controller.ts
import { Controller, Get, Post, Put, Delete, Body, Param, Query } from '@nestjs/common';
import { NotificationService } from './notification.service';

@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}
  
  @Get()
  async getNotifications(@Query() query: any) {
    return await this.notificationService.getNotifications(query);
  }
  
  @Get('unread')
  async getUnreadNotifications(@Query('userId') userId: string) {
    return await this.notificationService.getUnreadNotifications(userId);
  }
  
  @Post('acknowledge/:id')
  async acknowledgeNotification(
    @Param('id') id: string,
    @Body() body: { userId: string, note?: string }
  ) {
    return await this.notificationService.acknowledgeNotification(id, body.userId, body.note);
  }
  
  @Get('reports/daily')
  async getDailyReport(@Query('date') date: string) {
    return await this.notificationService.getDailyReport(date);
  }
  
  @Get('reports/device/:deviceId')
  async getDeviceReport(
    @Param('deviceId') deviceId: string,
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string
  ) {
    return await this.notificationService.getDeviceReport(deviceId, startDate, endDate);
  }
}
```

## 7. ระบบ Level Notification

```typescript
// src/services/notification-level.service.ts
import { Injectable } from '@nestjs/common';
import { AlarmStatus } from '../entities/alarm-condition.entity';

export enum NotificationLevel {
  INFO = 1,      // Normal status
  WARNING = 2,   // Warning status
  ALERT = 3,     // Recovery Warning
  CRITICAL = 4,  // Alarm status
  EMERGENCY = 5  // Recovery Alarm
}

@Injectable()
export class NotificationLevelService {
  private readonly statusToLevelMap: Map<AlarmStatus, NotificationLevel> = new Map([
    [AlarmStatus.NORMAL, NotificationLevel.INFO],
    [AlarmStatus.WARNING, NotificationLevel.WARNING],
    [AlarmStatus.RECOVERY_WARNING, NotificationLevel.ALERT],
    [AlarmStatus.ALARM, NotificationLevel.CRITICAL],
    [AlarmStatus.RECOVERY_ALARM, NotificationLevel.EMERGENCY]
  ]);
  
  private readonly levelConfig = {
    [NotificationLevel.INFO]: {
      cooldown: 0,           // ไม่ต้องแจ้งซ้ำ
      retryInterval: 0,
      escalationTime: 0,
      channels: ['WEB_PUSH']
    },
    [NotificationLevel.WARNING]: {
      cooldown: 10,          // 10 นาที
      retryInterval: 600000, // 10 นาทีในมิลลิวินาที
      escalationTime: 30,    // 30 นาทีถึงระดับถัดไป
      channels: ['WEB_PUSH', 'EMAIL']
    },
    [NotificationLevel.ALERT]: {
      cooldown: 5,           // 5 นาที
      retryInterval: 300000, // 5 นาที
      escalationTime: 15,    // 15 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE']
    },
    [NotificationLevel.CRITICAL]: {
      cooldown: 2,           // 2 นาที
      retryInterval: 120000, // 2 นาที
      escalationTime: 5,     // 5 นาที
      channels: ['WEB_PUSH', 'EMAIL', 'LINE', 'TELEGRAM', 'SMS']
    },
    [NotificationLevel.EMERGENCY]: {
      cooldown: 1,           // 1 นาที
      retryInterval: 60000,  // 1 นาที
      escalationTime: 2,     // 2 นาที
      channels: ['ALL_CHANNELS']
    }
  };
  
  getLevelForStatus(status: AlarmStatus): NotificationLevel {
    return this.statusToLevelMap.get(status) || NotificationLevel.INFO;
  }
  
  getLevelConfig(level: NotificationLevel) {
    return this.levelConfig[level] || this.levelConfig[NotificationLevel.INFO];
  }
  
  shouldResendNotification(
    lastSent: Date,
    currentLevel: NotificationLevel,
    currentStatus: AlarmStatus
  ): boolean {
    const config = this.getLevelConfig(currentLevel);
    
    // ถ้าเป็น NORMAL ไม่ต้องส่งซ้ำ
    if (currentStatus === AlarmStatus.NORMAL) {
      return false;
    }
    
    const now = new Date();
    const timeDiff = now.getTime() - lastSent.getTime();
    
    // เช็คว่าเกิน cooldown หรือยัง
    return timeDiff >= config.retryInterval;
  }
  
  getNextEscalationLevel(currentLevel: NotificationLevel): NotificationLevel {
    const levels = Object.values(NotificationLevel).filter(v => typeof v === 'number') as number[];
    const currentIndex = levels.indexOf(currentLevel);
    
    if (currentIndex < levels.length - 1) {
      return levels[currentIndex + 1] as NotificationLevel;
    }
    
    return currentLevel;
  }
}
```

## 8. หน้ารายงาน (Reporting Dashboard)

### Report Service:
```typescript
// src/services/report.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Notification } from '../entities/notification.entity';
import { AlarmHistory } from '../entities/alarm-history.entity';
import { NotificationLog } from '../entities/notification-log.entity';

@Injectable()
export class ReportService {
  constructor(
    @InjectRepository(Notification)
    private notificationRepo: Repository<Notification>,
    @InjectRepository(AlarmHistory)
    private alarmHistoryRepo: Repository<AlarmHistory>,
    @InjectRepository(NotificationLog)
    private notificationLogRepo: Repository<NotificationLog>,
  ) {}
  
  async getDailyReport(date: Date) {
    const startDate = new Date(date);
    startDate.setHours(0, 0, 0, 0);
    
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);
    
    const [notifications, alarms, logs] = await Promise.all([
      this.notificationRepo.find({
        where: {
          createdAt: Between(startDate, endDate)
        }
      }),
      this.alarmHistoryRepo.find({
        where: {
          triggeredAt: Between(startDate, endDate)
        }
      }),
      this.notificationLogRepo.createQueryBuilder('log')
        .select('channel_type, COUNT(*) as count, status')
        .where('log.attempted_at BETWEEN :start AND :end', {
          start: startDate,
          end: endDate
        })
        .groupBy('log.channel_type, log.status')
        .getRawMany()
    ]);
    
    return {
      date,
      summary: {
        totalNotifications: notifications.length,
        totalAlarms: alarms.length,
        sentNotifications: notifications.filter(n => n.status === 'SENT').length,
        failedNotifications: notifications.filter(n => n.status === 'FAILED').length,
        readNotifications: notifications.filter(n => n.readAt !== null).length,
      },
      byChannel: logs.reduce((acc, log) => {
        if (!acc[log.channel_type]) {
          acc[log.channel_type] = { sent: 0, failed: 0 };
        }
        if (log.status === 'SENT') {
          acc[log.channel_type].sent += parseInt(log.count);
        } else {
          acc[log.channel_type].failed += parseInt(log.count);
        }
        return acc;
      }, {}),
      recentAlarms: alarms.slice(0, 10),
      recentNotifications: notifications.slice(0, 10)
    };
  }
  
  async getDeviceReport(deviceId: string, startDate: Date, endDate: Date) {
    const [alarms, notifications] = await Promise.all([
      this.alarmHistoryRepo.find({
        where: {
          deviceId,
          triggeredAt: Between(startDate, endDate)
        },
        order: { triggeredAt: 'DESC' }
      }),
      this.notificationRepo.find({
        where: {
          deviceId,
          createdAt: Between(startDate, endDate)
        },
        order: { createdAt: 'DESC' }
      })
    ]);
    
    // คำนวณสถิติ
    const statusCount = alarms.reduce((acc, alarm) => {
      acc[alarm.current_status] = (acc[alarm.current_status] || 0) + 1;
      return acc;
    }, {});
    
    const averageResponseTime = await this.calculateAverageResponseTime(deviceId, startDate, endDate);
    
    return {
      deviceId,
      period: { startDate, endDate },
      statistics: {
        totalAlarms: alarms.length,
        totalNotifications: notifications.length,
        statusDistribution: statusCount,
        averageResponseTime,
        uptimePercentage: this.calculateUptime(alarms)
      },
      timeline: alarms.map(alarm => ({
        time: alarm.triggeredAt,
        status: alarm.current_status,
        value: alarm.sensor_value,
        notification: notifications.find(n => n.alarmHistoryId === alarm.id)
      }))
    };
  }
  
  private async calculateAverageResponseTime(deviceId: string, startDate: Date, endDate: Date): Promise<number> {
    const result = await this.alarmHistoryRepo.createQueryBuilder('alarm')
      .select('AVG(EXTRACT(EPOCH FROM (recovered_at - triggered_at)))', 'avgResponse')
      .where('device_id = :deviceId', { deviceId })
      .andWhere('recovered_at IS NOT NULL')
      .andWhere('triggered_at BETWEEN :start AND :end', { start: startDate, end: endDate })
      .getRawOne();
    
    return parseFloat(result?.avgResponse || '0');
  }
  
  private calculateUptime(alarms: AlarmHistory[]): number {
    if (alarms.length === 0) return 100;
    
    const normalAlarms = alarms.filter(a => a.current_status === 'NORMAL');
    return (normalAlarms.length / alarms.length) * 100;
  }
}
```

## 9. Main Application Structure

```typescript
// src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);
  
  app.useGlobalPipes(new ValidationPipe());
  app.enableCors();
  
  const port = configService.get('PORT') || 3000;
  await app.listen(port);
  console.log(`Notification system running on port ${port}`);
}
bootstrap();

// src/app.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { ScheduleModule } from '@nestjs/schedule';
import { NotificationModule } from './modules/notification/notification.module';
import { ReportModule } from './modules/report/report.module';
import { ConfigurationModule } from './modules/configuration/configuration.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    ScheduleModule.forRoot(),
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
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    NotificationModule,
    ReportModule,
    ConfigurationModule,
  ],
})
export class AppModule {}
```

## 10. Environment Variables (.env)

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
REDIS_DB=0

# MQTT
MQTT_BROKER_URL=mqtt://localhost:1883
MQTT_USERNAME=
MQTT_PASSWORD=

# Notification Channels
LINE_CHANNEL_ACCESS_TOKEN=
DISCORD_WEBHOOK_URL=
TELEGRAM_BOT_TOKEN=
SMS_PROVIDER_API_KEY=
AI_CHAT_BOT_WEBHOOK=

# Application
PORT=3000
NODE_ENV=development
JWT_SECRET=your-secret-key
```

## 11. Package.json Dependencies

```json
{
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/platform-socket.io": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "@nestjs/websockets": "^9.0.0",
    "@nestjs/schedule": "^9.0.0",
    "@nestjs/config": "^9.0.0",
    "typeorm": "^0.3.0",
    "pg": "^8.0.0",
    "socket.io": "^4.5.0",
    "mqtt": "^4.0.0",
    "ioredis": "^5.0.0",
    "bullmq": "^3.0.0",
    "axios": "^1.0.0",
    "class-validator": "^0.13.0",
    "class-transformer": "^0.5.0"
  }
}
```

## 12. การทำงานของระบบทั้งหมด

1. **รับข้อมูลจากเซ็นเซอร์** ผ่าน MQTT
2. **ตรวจสอบเงื่อนไข** กับค่าที่ตั้งไว้
3. **อัปเดตสถานะ** และบันทึกประวัติ
4. **สร้างการแจ้งเตือน** ตามระดับความสำคัญ
5. **ตรวจสอบ cooldown** ด้วย Redis
6. **ส่งผ่านช่องทางต่างๆ** ตามการตั้งค่า
7. **บันทึกผลการส่ง** และอัปเดตสถานะ
8. **แจ้งเตือนผ่าน WebSocket** สำหรับ Real-time
9. **จัดการการแจ้งซ้ำ** ตามสถานะและเวลาที่กำหนด
10. **เก็บข้อมูลรายงาน** สำหรับ Dashboard

ระบบนี้สามารถขยายได้ง่ายด้วยการเพิ่มช่องทางการแจ้งเตือนใหม่ หรือปรับแต่งเงื่อนไขการแจ้งเตือนผ่าน API ที่มีให้