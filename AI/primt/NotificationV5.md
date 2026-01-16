# 🍃 ระบบ Carbon Footprint บน Notification System

## 📊 โครงสร้างระบบ Carbon Footprint

### 1. **Core Concept**
- คำนวณ **คาร์บอนฟุตปริ้นส์** จากอุปกรณ์ IoT และเซ็นเซอร์
- แปลง **พลังงานไฟฟ้า** เป็น CO₂e (Carbon Dioxide Equivalent)
- ติดตาม **การปล่อยก๊าซเรือนกระจก** แบบ Real-time
- สร้าง **รายงานและแดชบอร์ด** สำหรับ Carbon Management

---

## 2. **Database Design (เพิ่ม Entities)**

### `src/modules/carbon/entities/carbon-emission.entity.ts`
```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  Index,
  CreateDateColumn,
} from 'typeorm';
import { Device } from '../../device/entities/device.entity';
import { Sensor } from '../../sensor/entities/sensor.entity';

@Entity('carbon_emissions')
@Index(['device', 'timestamp'])
@Index(['sensor', 'timestamp'])
export class CarbonEmission {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Device, { nullable: true })
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @ManyToOne(() => Sensor, { nullable: true })
  @JoinColumn({ name: 'sensor_id' })
  sensor: Sensor;

  @Column('decimal', { precision: 12, scale: 6 })
  co2e: number; // Carbon Dioxide Equivalent in kg

  @Column('decimal', { precision: 12, scale: 6 })
  energyConsumption: number; // Energy in kWh

  @Column({ length: 50 })
  energyUnit: string; // kWh, MWh, etc.

  @Column('decimal', { precision: 10, scale: 6, nullable: true })
  emissionFactor: number; // kg CO2e per unit energy

  @Column({ length: 100, nullable: true })
  emissionSource: string; // Electricity, Fuel, Process, etc.

  @Column('decimal', { precision: 12, scale: 6, nullable: true })
  ch4: number; // Methane in kg

  @Column('decimal', { precision: 12, scale: 6, nullable: true })
  n2o: number; // Nitrous Oxide in kg

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  timestamp: Date;

  @Column('jsonb', { nullable: true })
  calculationData: {
    power: number; // Power in watts
    duration: number; // Duration in hours
    voltage?: number;
    current?: number;
    powerFactor?: number;
    gridCarbonIntensity?: number; // kg CO2e/kWh ของการไฟฟ้า
  };

  @Column({ default: false })
  isCalculated: boolean;

  @Column({ length: 50, nullable: true })
  calculationMethod: string; // Real-time, Estimated, Average

  @CreateDateColumn()
  createdAt: Date;
}
```

### `src/modules/carbon/entities/carbon-target.entity.ts`
```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Device } from '../../device/entities/device.entity';

@Entity('carbon_targets')
export class CarbonTarget {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Device, { nullable: true })
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @Column({ length: 100 })
  name: string;

  @Column('decimal', { precision: 12, scale: 6 })
  targetValue: number; // Target CO2e in kg

  @Column({
    type: 'enum',
    enum: ['DAILY', 'WEEKLY', 'MONTHLY', 'QUARTERLY', 'YEARLY'],
  })
  period: string;

  @Column({ type: 'date' })
  startDate: Date;

  @Column({ type: 'date' })
  endDate: Date;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  currentValue: number;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  progressPercentage: number;

  @Column({
    type: 'enum',
    enum: ['ACTIVE', 'COMPLETED', 'FAILED', 'IN_PROGRESS'],
    default: 'ACTIVE',
  })
  status: string;

  @Column('jsonb', { nullable: true })
  notifications: {
    enabled: boolean;
    threshold: number; // Percentage
    channels: string[];
  };

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### `src/modules/carbon/entities/carbon-offset.entity.ts`
```typescript
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Device } from '../../device/entities/device.entity';

@Entity('carbon_offsets')
export class CarbonOffset {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Device, { nullable: true })
  @JoinColumn({ name: 'device_id' })
  device: Device;

  @Column({ length: 100 })
  projectName: string;

  @Column({
    type: 'enum',
    enum: ['AFFORESTATION', 'RENEWABLE_ENERGY', 'CARBON_CAPTURE', 'ENERGY_EFFICIENCY'],
  })
  projectType: string;

  @Column('decimal', { precision: 12, scale: 6 })
  offsetAmount: number; // CO2e offset in kg

  @Column('decimal', { precision: 12, scale: 6, nullable: true })
  creditCost: number; // Cost in local currency

  @Column({ length: 3, nullable: true })
  currency: string;

  @Column({ type: 'date' })
  offsetDate: Date;

  @Column({ length: 100, nullable: true })
  certification: string; // VER, CER, Gold Standard, etc.

  @Column('jsonb', { nullable: true })
  details: {
    location?: string;
    area?: number; // in hectares
    treesPlanted?: number;
    renewableCapacity?: number; // in kW
    durationYears?: number;
  };

  @Column({ default: false })
  isVerified: boolean;

  @Column({ type: 'timestamp', nullable: true })
  verifiedAt: Date;

  @CreateDateColumn()
  createdAt: Date;
}
```

### `src/modules/carbon/entities/grid-intensity.entity.ts`
```typescript
import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('grid_intensities')
@Index(['region', 'timestamp'])
export class GridIntensity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  region: string; // e.g., 'MEA', 'EGAT', 'PEA'

  @Column('decimal', { precision: 10, scale: 6 })
  carbonIntensity: number; // kg CO2e per kWh

  @Column({ length: 50, nullable: true })
  fuelMix: string; // e.g., 'Coal:40%, Gas:35%, Hydro:15%, Solar:10%'

  @Column('jsonb', { nullable: true })
  breakdown: {
    coal: number;
    naturalGas: number;
    oil: number;
    hydro: number;
    solar: number;
    wind: number;
    biomass: number;
    nuclear: number;
    other: number;
  };

  @Column({ type: 'timestamp' })
  timestamp: Date;

  @Column({ type: 'timestamp' })
  validFrom: Date;

  @Column({ type: 'timestamp' })
  validTo: Date;

  @Column({ default: true })
  isActive: boolean;

  @Column('jsonb', { nullable: true })
  source: {
    name: string;
    url: string;
    reliability: number; // 0-100
  };
}
```

---

## 3. **Carbon Calculation Service**

### `src/modules/carbon/services/carbon-calculator.service.ts`
```typescript
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ConfigService } from '@nestjs/config';

import { Device } from '../../device/entities/device.entity';
import { Sensor } from '../../sensor/entities/sensor.entity';
import { CarbonEmission } from '../entities/carbon-emission.entity';
import { GridIntensity } from '../entities/grid-intensity.entity';

@Injectable()
export class CarbonCalculatorService {
  private readonly logger = new Logger(CarbonCalculatorService.name);

  // Default emission factors (kg CO2e per kWh)
  private readonly DEFAULT_EMISSION_FACTORS = {
    THAILAND_GRID: 0.52, // Thailand grid average
    COAL: 0.98,
    NATURAL_GAS: 0.42,
    OIL: 0.73,
    HYDRO: 0.004,
    SOLAR: 0.045,
    WIND: 0.011,
    BIOMASS: 0.23,
    NUCLEAR: 0.012,
    DIESEL_GENERATOR: 0.78,
  };

  // Device type specific consumption profiles
  private readonly DEVICE_PROFILES = {
    FAN: {
      powerRange: { min: 50, max: 200 }, // watts
      typicalUsage: 8, // hours per day
      powerFactor: 0.85,
    },
    AC: {
      powerRange: { min: 1000, max: 3500 },
      typicalUsage: 6,
      powerFactor: 0.9,
    },
    WATER_PUMP: {
      powerRange: { min: 500, max: 1500 },
      typicalUsage: 2,
      powerFactor: 0.88,
    },
    LIGHT: {
      powerRange: { min: 10, max: 100 },
      typicalUsage: 10,
      powerFactor: 0.95,
    },
    ROBOT: {
      powerRange: { min: 200, max: 800 },
      typicalUsage: 4,
      powerFactor: 0.87,
    },
    HEATER: {
      powerRange: { min: 1500, max: 3000 },
      typicalUsage: 3,
      powerFactor: 0.92,
    },
    COOLER: {
      powerRange: { min: 800, max: 2000 },
      typicalUsage: 5,
      powerFactor: 0.89,
    },
  };

  constructor(
    @InjectRepository(CarbonEmission)
    private carbonEmissionRepo: Repository<CarbonEmission>,
    
    @InjectRepository(GridIntensity)
    private gridIntensityRepo: Repository<GridIntensity>,
    
    private configService: ConfigService,
  ) {}

  /**
   * Calculate carbon emissions from energy consumption
   */
  async calculateFromEnergy(
    energyKwh: number,
    options: {
      device?: Device;
      sensor?: Sensor;
      timestamp?: Date;
      region?: string;
      emissionFactor?: number;
    } = {},
  ): Promise<CarbonEmission> {
    try {
      const {
        device,
        sensor,
        timestamp = new Date(),
        region = 'THAILAND_GRID',
        emissionFactor: customFactor,
      } = options;

      // Get emission factor
      let emissionFactor = customFactor;
      
      if (!emissionFactor) {
        emissionFactor = await this.getEmissionFactor(region, timestamp);
      }

      // Calculate CO2e
      const co2e = energyKwh * emissionFactor;

      // Create carbon emission record
      const carbonEmission = this.carbonEmissionRepo.create({
        device,
        sensor,
        energyConsumption: energyKwh,
        energyUnit: 'kWh',
        co2e,
        emissionFactor,
        emissionSource: 'ELECTRICITY',
        timestamp,
        calculationData: {
          power: 0, // Will be filled if device info available
          duration: 0,
          gridCarbonIntensity: emissionFactor,
        },
        isCalculated: true,
        calculationMethod: customFactor ? 'CUSTOM' : 'GRID_AVERAGE',
      });

      // Add device-specific data if available
      if (device) {
        await this.enrichWithDeviceData(carbonEmission, device, energyKwh);
      }

      return await this.carbonEmissionRepo.save(carbonEmission);
    } catch (error) {
      this.logger.error(`Failed to calculate carbon emissions: ${error.message}`, error.stack);
      throw error;
    }
  }

  /**
   * Calculate carbon emissions from power and duration
   */
  async calculateFromPower(
    powerWatts: number,
    durationHours: number,
    options: {
      device?: Device;
      sensor?: Sensor;
      timestamp?: Date;
      region?: string;
      powerFactor?: number;
    } = {},
  ): Promise<CarbonEmission> {
    try {
      const {
        device,
        sensor,
        timestamp = new Date(),
        region = 'THAILAND_GRID',
        powerFactor = 0.9,
      } = options;

      // Calculate energy consumption (kWh)
      const energyKwh = (powerWatts * durationHours * powerFactor) / 1000;

      // Calculate carbon emissions
      return await this.calculateFromEnergy(energyKwh, {
        device,
        sensor,
        timestamp,
        region,
      });
    } catch (error) {
      this.logger.error(`Failed to calculate from power: ${error.message}`, error.stack);
      throw error;
    }
  }

  /**
   * Calculate carbon emissions from device status data
   */
  async calculateFromDevice(
    device: Device,
    statusData: {
      power?: number;
      current?: number;
      voltage?: number;
      powerFactor?: number;
      operatingHours?: number;
      timestamp?: Date;
    },
  ): Promise<CarbonEmission> {
    try {
      const {
        power,
        current,
        voltage = 220, // Default voltage for Thailand
        powerFactor = 0.9,
        operatingHours = 1,
        timestamp = new Date(),
      } = statusData;

      let calculatedPower = power;

      // Calculate power from current and voltage if power not provided
      if (!calculatedPower && current && voltage) {
        calculatedPower = current * voltage * powerFactor; // P = I * V * PF
      }

      // Use device profile if no power data
      if (!calculatedPower && device.type in this.DEVICE_PROFILES) {
        const profile = this.DEVICE_PROFILES[device.type];
        calculatedPower = (profile.powerRange.min + profile.powerRange.max) / 2;
      }

      if (!calculatedPower) {
        throw new Error(`Cannot calculate power for device ${device.id}`);
      }

      // Calculate carbon emissions
      return await this.calculateFromPower(
        calculatedPower,
        operatingHours,
        {
          device,
          timestamp,
          powerFactor,
        },
      );
    } catch (error) {
      this.logger.error(`Failed to calculate from device: ${error.message}`, error.stack);
      throw error;
    }
  }

  /**
   * Calculate carbon emissions from sensor data
   */
  async calculateFromSensor(
    sensor: Sensor,
    value: number,
    timestamp: Date,
  ): Promise<CarbonEmission | null> {
    try {
      // Map sensor types to carbon calculation methods
      const calculationMap = {
        TEMPERATURE: this.calculateFromTemperature.bind(this),
        HUMIDITY: this.calculateFromHumidity.bind(this),
        CO2: this.calculateFromCO2Sensor.bind(this),
        POWER: this.calculateFromPowerSensor.bind(this),
        CURRENT: this.calculateFromCurrentSensor.bind(this),
        VOLTAGE: this.calculateFromVoltageSensor.bind(this),
      };

      const calculator = calculationMap[sensor.type];
      
      if (calculator) {
        return await calculator(sensor, value, timestamp);
      }

      return null;
    } catch (error) {
      this.logger.error(`Failed to calculate from sensor: ${error.message}`, error.stack);
      return null;
    }
  }

  /**
   * Get emission factor for a region and time
   */
  private async getEmissionFactor(region: string, timestamp: Date): Promise<number> {
    try {
      // Try to get specific grid intensity data
      const gridIntensity = await this.gridIntensityRepo.findOne({
        where: {
          region,
          validFrom: new Date(timestamp.getTime() - 3600000), // Within last hour
          validTo: new Date(timestamp.getTime() + 3600000), // Next hour
          isActive: true,
        },
        order: { timestamp: 'DESC' },
      });

      if (gridIntensity) {
        return gridIntensity.carbonIntensity;
      }

      // Use default factor based on region
      if (region in this.DEFAULT_EMISSION_FACTORS) {
        return this.DEFAULT_EMISSION_FACTORS[region];
      }

      // Default to Thailand grid average
      return this.DEFAULT_EMISSION_FACTORS.THAILAND_GRID;
    } catch (error) {
      this.logger.warn(`Failed to get emission factor for ${region}: ${error.message}`);
      return this.DEFAULT_EMISSION_FACTORS.THAILAND_GRID;
    }
  }

  /**
   * Enrich carbon emission with device data
   */
  private async enrichWithDeviceData(
    carbonEmission: CarbonEmission,
    device: Device,
    energyKwh: number,
  ): Promise<void> {
    if (device.configuration) {
      const config = device.configuration;
      
      // Update calculation data
      if (carbonEmission.calculationData) {
        carbonEmission.calculationData = {
          ...carbonEmission.calculationData,
          power: config.power || 0,
          voltage: config.voltage || 220,
          current: config.current || 0,
          powerFactor: config.powerFactor || 0.9,
          duration: energyKwh * 1000 / (config.power || 1), // Calculate duration
        };
      }

      // Update emission source based on device type
      if (device.type === 'SOLAR_PANEL' || device.type === 'WIND_TURBINE') {
        carbonEmission.emissionSource = 'RENEWABLE_ENERGY';
        carbonEmission.co2e = 0; // Renewable energy has zero emissions
      }
    }
  }

  /**
   * Calculate carbon from temperature sensor
   * (Indirect calculation through HVAC energy use)
   */
  private async calculateFromTemperature(
    sensor: Sensor,
    temperature: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Simplified model: Each degree above/below setpoint increases HVAC energy
    const setpoint = 25; // Standard setpoint
    const deviation = Math.abs(temperature - setpoint);
    const hvacEnergyPerDegree = 0.1; // kWh per degree deviation per hour

    const energyKwh = deviation * hvacEnergyPerDegree;
    
    return this.calculateFromEnergy(energyKwh, {
      sensor,
      timestamp,
      emissionFactor: this.DEFAULT_EMISSION_FACTORS.THAILAND_GRID,
    });
  }

  /**
   * Calculate carbon from humidity sensor
   */
  private async calculateFromHumidity(
    sensor: Sensor,
    humidity: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Dehumidifier/air conditioner energy based on humidity
    const idealHumidity = 50;
    const deviation = Math.abs(humidity - idealHumidity);
    const dehumidifierEnergy = deviation * 0.05; // kWh per % deviation

    const energyKwh = Math.max(dehumidifierEnergy, 0.01); // Minimum energy
    
    return this.calculateFromEnergy(energyKwh, {
      sensor,
      timestamp,
    });
  }

  /**
   * Calculate carbon from CO2 sensor
   */
  private async calculateFromCO2Sensor(
    sensor: Sensor,
    co2ppm: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Ventilation energy based on CO2 levels
    const targetCO2 = 800; // ppm
    const excessCO2 = Math.max(co2ppm - targetCO2, 0);
    const ventilationEnergy = excessCO2 * 0.0001; // kWh per ppm excess

    const energyKwh = Math.max(ventilationEnergy, 0.01);
    
    return this.calculateFromEnergy(energyKwh, {
      sensor,
      timestamp,
    });
  }

  /**
   * Calculate carbon from power sensor
   */
  private async calculateFromPowerSensor(
    sensor: Sensor,
    powerWatts: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Direct power measurement
    const durationHours = 1; // Assume 1 hour for instant reading
    const energyKwh = (powerWatts * durationHours) / 1000;
    
    return this.calculateFromEnergy(energyKwh, {
      sensor,
      timestamp,
    });
  }

  /**
   * Calculate carbon from current sensor
   */
  private async calculateFromCurrentSensor(
    sensor: Sensor,
    currentAmps: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Calculate power from current (assume 220V, 0.9 PF)
    const voltage = 220;
    const powerFactor = 0.9;
    const powerWatts = currentAmps * voltage * powerFactor;
    
    return this.calculateFromPowerSensor(sensor, powerWatts, timestamp);
  }

  /**
   * Calculate carbon from voltage sensor
   */
  private async calculateFromVoltageSensor(
    sensor: Sensor,
    voltage: number,
    timestamp: Date,
  ): Promise<CarbonEmission> {
    // Voltage alone doesn't determine power, need current
    // Return minimal energy for now
    return this.calculateFromEnergy(0.01, {
      sensor,
      timestamp,
    });
  }

  /**
   * Get total carbon emissions for a period
   */
  async getTotalEmissions(
    startDate: Date,
    endDate: Date,
    filters?: {
      deviceId?: string;
      sensorId?: string;
      emissionSource?: string;
    },
  ): Promise<{
    totalCO2e: number;
    totalEnergy: number;
    byDevice: Record<string, number>;
    bySource: Record<string, number>;
    timeline: Array<{ date: string; co2e: number }>;
  }> {
    const query = this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .where('emission.timestamp BETWEEN :startDate AND :endDate', {
        startDate,
        endDate,
      });

    if (filters?.deviceId) {
      query.andWhere('emission.deviceId = :deviceId', { deviceId: filters.deviceId });
    }

    if (filters?.sensorId) {
      query.andWhere('emission.sensorId = :sensorId', { sensorId: filters.sensorId });
    }

    if (filters?.emissionSource) {
      query.andWhere('emission.emissionSource = :source', { source: filters.emissionSource });
    }

    const emissions = await query.getMany();

    // Calculate totals
    const totalCO2e = emissions.reduce((sum, e) => sum + parseFloat(e.co2e.toString()), 0);
    const totalEnergy = emissions.reduce((sum, e) => sum + parseFloat(e.energyConsumption.toString()), 0);

    // Group by device
    const byDevice = emissions.reduce((acc, e) => {
      const deviceName = e.device?.name || 'Unknown';
      acc[deviceName] = (acc[deviceName] || 0) + parseFloat(e.co2e.toString());
      return acc;
    }, {} as Record<string, number>);

    // Group by source
    const bySource = emissions.reduce((acc, e) => {
      const source = e.emissionSource || 'UNKNOWN';
      acc[source] = (acc[source] || 0) + parseFloat(e.co2e.toString());
      return acc;
    }, {} as Record<string, number>);

    // Create timeline (daily)
    const timelineMap = new Map<string, number>();
    emissions.forEach(e => {
      const date = e.timestamp.toISOString().split('T')[0];
      timelineMap.set(date, (timelineMap.get(date) || 0) + parseFloat(e.co2e.toString()));
    });

    const timeline = Array.from(timelineMap.entries())
      .map(([date, co2e]) => ({ date, co2e }))
      .sort((a, b) => a.date.localeCompare(b.date));

    return {
      totalCO2e,
      totalEnergy,
      byDevice,
      bySource,
      timeline,
    };
  }

  /**
   * Calculate carbon intensity (CO2e per unit of output)
   */
  async calculateCarbonIntensity(
    co2e: number,
    output: number,
    outputUnit: string,
  ): Promise<{
    intensity: number;
    unit: string;
    rating: string;
  }> {
    const intensity = co2e / output;
    
    // Determine rating based on intensity
    let rating = 'VERY_HIGH';
    if (intensity < 0.1) rating = 'VERY_LOW';
    else if (intensity < 0.3) rating = 'LOW';
    else if (intensity < 0.6) rating = 'MEDIUM';
    else if (intensity < 1.0) rating = 'HIGH';

    return {
      intensity,
      unit: `kg CO2e per ${outputUnit}`,
      rating,
    };
  }

  /**
   * Convert emissions to understandable equivalents
   */
  convertToEquivalents(co2eKg: number): {
    treesNeeded: number;
    carKm: number;
    smartphoneCharges: number;
    flights: number;
  } {
    // Conversion factors
    const TREE_ABSORPTION = 21.77; // kg CO2 per tree per year
    const CAR_EMISSIONS = 0.12; // kg CO2 per km
    const SMARTPHONE_CHARGE = 0.006; // kg CO2 per full charge
    const FLIGHT_EMISSIONS = 250; // kg CO2 per hour of flight

    return {
      treesNeeded: co2eKg / TREE_ABSORPTION,
      carKm: co2eKg / CAR_EMISSIONS,
      smartphoneCharges: co2eKg / SMARTPHONE_CHARGE,
      flights: co2eKg / FLIGHT_EMISSIONS,
    };
  }
}
```

---

## 4. **Carbon Monitoring Service**

### `src/modules/carbon/services/carbon-monitor.service.ts`
```typescript
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Cron, CronExpression } from '@nestjs/schedule';

import { CarbonEmission } from '../entities/carbon-emission.entity';
import { CarbonTarget } from '../entities/carbon-target.entity';
import { Device } from '../../device/entities/device.entity';
import { NotificationService } from '../../notification/notification.service';
import { RedisService } from '../../../core/redis/redis.service';

@Injectable()
export class CarbonMonitorService {
  private readonly logger = new Logger(CarbonMonitorService.name);

  constructor(
    @InjectRepository(CarbonEmission)
    private carbonEmissionRepo: Repository<CarbonEmission>,
    
    @InjectRepository(CarbonTarget)
    private carbonTargetRepo: Repository<CarbonTarget>,
    
    @InjectRepository(Device)
    private deviceRepo: Repository<Device>,
    
    private notificationService: NotificationService,
    private redisService: RedisService,
  ) {}

  /**
   * Monitor real-time carbon emissions
   */
  async monitorRealTimeEmissions(): Promise<void> {
    try {
      const oneHourAgo = new Date(Date.now() - 3600000);
      
      // Get recent emissions
      const recentEmissions = await this.carbonEmissionRepo.find({
        where: {
          timestamp: Between(oneHourAgo, new Date()),
        },
        relations: ['device', 'sensor'],
      });

      // Check for anomalies
      for (const emission of recentEmissions) {
        await this.checkForAnomalies(emission);
      }

      // Update carbon targets
      await this.updateCarbonTargets();

      // Generate hourly summary
      await this.generateHourlySummary();

      this.logger.debug(`Monitored ${recentEmissions.length} emissions`);
    } catch (error) {
      this.logger.error(`Failed to monitor emissions: ${error.message}`, error.stack);
    }
  }

  /**
   * Check for carbon emission anomalies
   */
  private async checkForAnomalies(emission: CarbonEmission): Promise<void> {
    const device = emission.device;
    if (!device) return;

    const cacheKey = `carbon:baseline:${device.id}`;
    
    // Get baseline for this device
    let baseline = await this.redisService.hget(cacheKey, 'baseline');
    
    if (!baseline) {
      // Calculate baseline from historical data
      baseline = await this.calculateBaseline(device.id);
      await this.redisService.hset(cacheKey, 'baseline', baseline);
      await this.redisService.expire(cacheKey, 86400); // 24 hours
    }

    // Check if emission exceeds baseline
    const threshold = baseline * 1.5; // 50% above baseline
    const currentEmission = parseFloat(emission.co2e.toString());

    if (currentEmission > threshold) {
      await this.triggerAnomalyAlert(emission, baseline, currentEmission);
    }
  }

  /**
   * Calculate baseline emissions for a device
   */
  private async calculateBaseline(deviceId: string): Promise<number> {
    const sevenDaysAgo = new Date(Date.now() - 7 * 86400000);
    
    const avgEmission = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('AVG(emission.co2e)', 'average')
      .where('emission.deviceId = :deviceId', { deviceId })
      .andWhere('emission.timestamp >= :date', { date: sevenDaysAgo })
      .getRawOne();

    return avgEmission?.average || 0;
  }

  /**
   * Trigger anomaly alert
   */
  private async triggerAnomalyAlert(
    emission: CarbonEmission,
    baseline: number,
    current: number,
  ): Promise<void> {
    const increasePercentage = ((current - baseline) / baseline) * 100;
    
    // Check if alert was recently sent
    const alertKey = `carbon:alert:${emission.device.id}:${emission.timestamp.toISOString().split('T')[0]}`;
    const hasAlerted = await this.redisService.get(alertKey);
    
    if (hasAlerted) {
      return;
    }

    // Create alert notification
    const alertMessage = `
🚨 **Carbon Emission Anomaly Detected**

**Device:** ${emission.device.name}
**Current Emission:** ${current.toFixed(3)} kg CO2e
**Baseline:** ${baseline.toFixed(3)} kg CO2e
**Increase:** ${increasePercentage.toFixed(1)}%

**Time:** ${emission.timestamp.toLocaleString()}
**Location:** ${emission.device.location || 'Not specified'}

**Recommended Actions:**
1. Check device for malfunctions
2. Verify power consumption
3. Consider maintenance or replacement
    `;

    // Send notification through multiple channels
    // This would integrate with your existing notification system
    this.logger.warn(alertMessage);

    // Mark as alerted for today
    await this.redisService.set(alertKey, 'true', 86400); // 24 hours
  }

  /**
   * Update carbon targets progress
   */
  private async updateCarbonTargets(): Promise<void> {
    const activeTargets = await this.carbonTargetRepo.find({
      where: { status: 'ACTIVE' },
    });

    const now = new Date();

    for (const target of activeTargets) {
      // Calculate emissions for target period
      const emissions = await this.getEmissionsForPeriod(
        target.startDate,
        target.endDate,
        target.device?.id,
      );

      const totalCO2e = emissions.reduce((sum, e) => 
        sum + parseFloat(e.co2e.toString()), 0
      );

      // Update target progress
      target.currentValue = totalCO2e;
      target.progressPercentage = (totalCO2e / target.targetValue) * 100;

      // Update status
      if (now > target.endDate) {
        if (totalCO2e <= target.targetValue) {
          target.status = 'COMPLETED';
          await this.triggerTargetCompleted(target);
        } else {
          target.status = 'FAILED';
          await this.triggerTargetFailed(target);
        }
      } else if (target.progressPercentage >= 100) {
        target.status = 'COMPLETED';
        await this.triggerTargetCompleted(target);
      } else {
        target.status = 'IN_PROGRESS';
        
        // Check if threshold notification should be sent
        if (target.notifications?.enabled) {
          await this.checkTargetThreshold(target);
        }
      }

      await this.carbonTargetRepo.save(target);
    }
  }

  /**
   * Get emissions for a specific period
   */
  private async getEmissionsForPeriod(
    startDate: Date,
    endDate: Date,
    deviceId?: string,
  ): Promise<CarbonEmission[]> {
    const query = this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      });

    if (deviceId) {
      query.andWhere('emission.deviceId = :deviceId', { deviceId });
    }

    return await query.getMany();
  }

  /**
   * Trigger target completion notification
   */
  private async triggerTargetCompleted(target: CarbonTarget): Promise<void> {
    const message = `
🎉 **Carbon Target Achieved!**

**Target:** ${target.name}
**Period:** ${target.startDate.toLocaleDateString()} - ${target.endDate.toLocaleDateString()}
**Target Value:** ${target.targetValue} kg CO2e
**Actual Value:** ${target.currentValue.toFixed(2)} kg CO2e
**Achievement:** ${(100 - target.progressPercentage).toFixed(1)}% under target!

**Congratulations on reducing your carbon footprint!**
    `;

    this.logger.log(message);
    // Send notification through your notification channels
  }

  /**
   * Trigger target failure notification
   */
  private async triggerTargetFailed(target: CarbonTarget): Promise<void> {
    const message = `
⚠️ **Carbon Target Not Met**

**Target:** ${target.name}
**Period:** ${target.startDate.toLocaleDateString()} - ${target.endDate.toLocaleDateString()}
**Target Value:** ${target.targetValue} kg CO2e
**Actual Value:** ${target.currentValue.toFixed(2)} kg CO2e
**Exceeded by:** ${(target.progressPercentage - 100).toFixed(1)}%

**Recommendations:**
1. Review energy consumption patterns
2. Implement energy efficiency measures
3. Consider carbon offset options
    `;

    this.logger.warn(message);
    // Send notification through your notification channels
  }

  /**
   * Check target threshold for notifications
   */
  private async checkTargetThreshold(target: CarbonTarget): Promise<void> {
    const thresholds = [90, 95, 100]; // Percentage thresholds
    const notificationKey = `carbon:target:${target.id}:threshold`;

    for (const threshold of thresholds) {
      if (target.progressPercentage >= threshold) {
        const notified = await this.redisService.hget(notificationKey, threshold.toString());
        
        if (!notified) {
          await this.sendThresholdNotification(target, threshold);
          await this.redisService.hset(notificationKey, threshold.toString(), 'true');
        }
      }
    }
  }

  /**
   * Send threshold notification
   */
  private async sendThresholdNotification(
    target: CarbonTarget,
    threshold: number,
  ): Promise<void> {
    const message = `
📊 **Carbon Target Progress Update**

**Target:** ${target.name}
**Progress:** ${target.progressPercentage.toFixed(1)}%
**Threshold Reached:** ${threshold}%

**Remaining Budget:** ${Math.max(target.targetValue - target.currentValue, 0).toFixed(2)} kg CO2e
**Days Remaining:** ${this.calculateDaysRemaining(target.endDate)}

**Keep up the good work!**
    `;

    this.logger.log(message);
    // Send notification through your notification channels
  }

  /**
   * Calculate days remaining until target end date
   */
  private calculateDaysRemaining(endDate: Date): number {
    const now = new Date();
    const timeDiff = endDate.getTime() - now.getTime();
    return Math.ceil(timeDiff / (1000 * 3600 * 24));
  }

  /**
   * Generate hourly carbon summary
   */
  private async generateHourlySummary(): Promise<void> {
    const oneHourAgo = new Date(Date.now() - 3600000);
    const now = new Date();

    const hourlyEmissions = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('emission.deviceId', 'deviceId')
      .addSelect('SUM(emission.co2e)', 'totalCO2e')
      .addSelect('SUM(emission.energyConsumption)', 'totalEnergy')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: oneHourAgo,
        end: now,
      })
      .groupBy('emission.deviceId')
      .getRawMany();

    // Store summary in Redis for quick access
    const summaryKey = `carbon:summary:hourly:${now.toISOString().split(':')[0]}`;
    await this.redisService.set(summaryKey, {
      timestamp: now,
      period: 'HOURLY',
      emissions: hourlyEmissions,
      totalCO2e: hourlyEmissions.reduce((sum, e) => sum + parseFloat(e.totalCO2e), 0),
      totalEnergy: hourlyEmissions.reduce((sum, e) => sum + parseFloat(e.totalEnergy), 0),
    }, 3600); // Expire in 1 hour
  }

  /**
   * Get carbon footprint insights
   */
  async getCarbonInsights(period: 'DAY' | 'WEEK' | 'MONTH'): Promise<any> {
    const now = new Date();
    let startDate: Date;

    switch (period) {
      case 'DAY':
        startDate = new Date(now.getTime() - 86400000);
        break;
      case 'WEEK':
        startDate = new Date(now.getTime() - 7 * 86400000);
        break;
      case 'MONTH':
        startDate = new Date(now.getTime() - 30 * 86400000);
        break;
      default:
        startDate = new Date(now.getTime() - 86400000);
    }

    const emissions = await this.carbonEmissionRepo.find({
      where: {
        timestamp: Between(startDate, now),
      },
      relations: ['device'],
    });

    // Calculate insights
    const totalCO2e = emissions.reduce((sum, e) => sum + parseFloat(e.co2e.toString()), 0);
    const avgDailyCO2e = totalCO2e / ((now.getTime() - startDate.getTime()) / 86400000);
    
    // Find peak emission time
    const hourlyEmissions = new Map<number, number>();
    emissions.forEach(e => {
      const hour = e.timestamp.getHours();
      hourlyEmissions.set(hour, (hourlyEmissions.get(hour) || 0) + parseFloat(e.co2e.toString()));
    });

    let peakHour = 0;
    let peakEmission = 0;
    hourlyEmissions.forEach((emission, hour) => {
      if (emission > peakEmission) {
        peakEmission = emission;
        peakHour = hour;
      }
    });

    // Top emitting devices
    const deviceEmissions = new Map<string, number>();
    emissions.forEach(e => {
      if (e.device) {
        const deviceName = e.device.name;
        deviceEmissions.set(deviceName, (deviceEmissions.get(deviceName) || 0) + parseFloat(e.co2e.toString()));
      }
    });

    const topDevices = Array.from(deviceEmissions.entries())
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([name, co2e]) => ({ name, co2e }));

    // Calculate carbon intensity trends
    const trends = await this.calculateTrends(startDate, now);

    return {
      period,
      totalCO2e: totalCO2e.toFixed(2),
      avgDailyCO2e: avgDailyCO2e.toFixed(2),
      peakEmissionTime: `${peakHour}:00`,
      peakEmissionValue: peakEmission.toFixed(2),
      topEmittingDevices: topDevices,
      trends,
      equivalents: this.convertToEquivalents(totalCO2e),
      recommendations: this.generateRecommendations(totalCO2e, topDevices, trends),
    };
  }

  /**
   * Calculate carbon emission trends
   */
  private async calculateTrends(startDate: Date, endDate: Date): Promise<any> {
    const days = Math.ceil((endDate.getTime() - startDate.getTime()) / 86400000);
    const dailyTrends = [];

    for (let i = 0; i < days; i++) {
      const dayStart = new Date(startDate.getTime() + i * 86400000);
      const dayEnd = new Date(dayStart.getTime() + 86400000);

      const dayEmissions = await this.carbonEmissionRepo
        .createQueryBuilder('emission')
        .select('SUM(emission.co2e)', 'totalCO2e')
        .where('emission.timestamp BETWEEN :start AND :end', {
          start: dayStart,
          end: dayEnd,
        })
        .getRawOne();

      dailyTrends.push({
        date: dayStart.toISOString().split('T')[0],
        co2e: parseFloat(dayEmissions?.totalCO2e || 0),
      });
    }

    // Calculate trend line (simple linear regression)
    let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    dailyTrends.forEach((day, i) => {
      sumX += i;
      sumY += day.co2e;
      sumXY += i * day.co2e;
      sumX2 += i * i;
    });

    const n = dailyTrends.length;
    const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;

    const trendDirection = slope > 0 ? 'INCREASING' : slope < 0 ? 'DECREASING' : 'STABLE';
    const trendStrength = Math.abs(slope) > 0.1 ? 'STRONG' : 'WEAK';

    return {
      dailyTrends,
      slope: slope.toFixed(4),
      intercept: intercept.toFixed(2),
      trendDirection,
      trendStrength,
      predictedNextDay: (slope * n + intercept).toFixed(2),
    };
  }

  /**
   * Convert emissions to understandable equivalents
   */
  private convertToEquivalents(co2eKg: number): any {
    const TREE_ABSORPTION = 21.77; // kg CO2 per tree per year
    const CAR_EMISSIONS = 0.12; // kg CO2 per km
    const SMARTPHONE_CHARGE = 0.006; // kg CO2 per full charge
    const FLIGHT_EMISSIONS = 250; // kg CO2 per hour of flight

    return {
      treesNeeded: (co2eKg / TREE_ABSORPTION).toFixed(0),
      carKm: (co2eKg / CAR_EMISSIONS).toFixed(0),
      smartphoneCharges: (co2eKg / SMARTPHONE_CHARGE).toFixed(0),
      flightHours: (co2eKg / FLIGHT_EMISSIONS).toFixed(1),
    };
  }

  /**
   * Generate carbon reduction recommendations
   */
  private generateRecommendations(
    totalCO2e: number,
    topDevices: Array<{ name: string; co2e: number }>,
    trends: any,
  ): string[] {
    const recommendations = [];

    // High emission recommendation
    if (totalCO2e > 100) {
      recommendations.push('Consider implementing energy efficiency measures across all devices');
    }

    // Top device recommendations
    if (topDevices.length > 0) {
      const topDevice = topDevices[0];
      recommendations.push(`Focus on reducing emissions from ${topDevice.name} (${topDevice.co2e.toFixed(2)} kg CO2e)`);
    }

    // Trend-based recommendations
    if (trends.trendDirection === 'INCREASING' && trends.trendStrength === 'STRONG') {
      recommendations.push('Emissions are increasing significantly. Review recent changes to operations.');
    }

    if (trends.trendDirection === 'DECREASING') {
      recommendations.push('Great work! Emissions are decreasing. Keep up the good practices.');
    }

    // General recommendations
    recommendations.push('Consider scheduling high-energy devices during off-peak hours');
    recommendations.push('Regular maintenance can improve device efficiency by 10-20%');
    recommendations.push('Explore renewable energy options for high-emission devices');

    return recommendations.slice(0, 5); // Return top 5 recommendations
  }

  /**
   * Scheduled monitoring tasks
   */
  @Cron(CronExpression.EVERY_HOUR)
  async hourlyMonitoring() {
    await this.monitorRealTimeEmissions();
  }

  @Cron(CronExpression.EVERY_DAY_AT_MIDNIGHT)
  async dailySummary() {
    await this.generateDailySummary();
  }

  @Cron(CronExpression.EVERY_WEEK)
  async weeklyReport() {
    await this.generateWeeklyReport();
  }

  /**
   * Generate daily carbon summary
   */
  private async generateDailySummary(): Promise<void> {
    const yesterday = new Date(Date.now() - 86400000);
    yesterday.setHours(0, 0, 0, 0);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const emissions = await this.getEmissionsForPeriod(yesterday, today);
    const totalCO2e = emissions.reduce((sum, e) => sum + parseFloat(e.co2e.toString()), 0);

    const summary = {
      date: yesterday.toISOString().split('T')[0],
      totalCO2e: totalCO2e.toFixed(2),
      deviceCount: new Set(emissions.map(e => e.device?.id)).size,
      peakHour: await this.findPeakHour(yesterday, today),
      topDevices: await this.findTopDevices(yesterday, today, 3),
    };

    // Store in Redis for dashboard
    const summaryKey = `carbon:summary:daily:${yesterday.toISOString().split('T')[0]}`;
    await this.redisService.set(summaryKey, summary, 604800); // 7 days
  }

  /**
   * Find peak emission hour
   */
  private async findPeakHour(startDate: Date, endDate: Date): Promise<any> {
    const hourlyData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('EXTRACT(HOUR FROM emission.timestamp)', 'hour')
      .addSelect('SUM(emission.co2e)', 'totalCO2e')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .groupBy('EXTRACT(HOUR FROM emission.timestamp)')
      .orderBy('totalCO2e', 'DESC')
      .limit(1)
      .getRawOne();

    return hourlyData || { hour: 0, totalCO2e: 0 };
  }

  /**
   * Find top emitting devices
   */
  private async findTopDevices(
    startDate: Date,
    endDate: Date,
    limit: number,
  ): Promise<Array<{ name: string; co2e: number }>> {
    const deviceData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('device.name', 'name')
      .addSelect('SUM(emission.co2e)', 'co2e')
      .leftJoin('emission.device', 'device')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .andWhere('device.id IS NOT NULL')
      .groupBy('device.name')
      .orderBy('co2e', 'DESC')
      .limit(limit)
      .getRawMany();

    return deviceData.map(d => ({
      name: d.name,
      co2e: parseFloat(d.co2e),
    }));
  }

  /**
   * Generate weekly report
   */
  private async generateWeeklyReport(): Promise<void> {
    const oneWeekAgo = new Date(Date.now() - 7 * 86400000);
    oneWeekAgo.setHours(0, 0, 0, 0);

    const report = await this.getCarbonInsights('WEEK');
    
    // Store report
    const reportKey = `carbon:report:weekly:${oneWeekAgo.toISOString().split('T')[0]}`;
    await this.redisService.set(reportKey, report, 2592000); // 30 days

    // Send report notification
    await this.sendWeeklyReportNotification(report);
  }

  /**
   * Send weekly report notification
   */
  private async sendWeeklyReportNotification(report: any): Promise<void> {
    const message = `
📊 **Weekly Carbon Footprint Report**

**Period:** ${report.period}
**Total CO2e:** ${report.totalCO2e} kg
**Average Daily:** ${report.avgDailyCO2e} kg

**Top Emitting Devices:**
${report.topEmittingDevices.map((d: any, i: number) => 
  `${i + 1}. ${d.name}: ${d.co2e.toFixed(2)} kg`
).join('\n')}

**Trend:** ${report.trends.trendDirection} (${report.trends.trendStrength})

**Equivalents:**
🌳 ${report.equivalents.treesNeeded} trees needed to absorb
🚗 ${report.equivalents.carKm} km driven
📱 ${report.equivalents.smartphoneCharges} smartphone charges
✈️ ${report.equivalents.flightHours} hours of flight

**Recommendations:**
${report.recommendations.map((r: string, i: number) => 
  `${i + 1}. ${r}`
).join('\n')}
    `;

    this.logger.log(message);
    // Send through notification channels
  }
}
```

---

## 5. **Carbon Dashboard Service**

### `src/modules/carbon/services/carbon-dashboard.service.ts`
```typescript
import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { format, subDays, startOfDay, endOfDay } from 'date-fns';

import { CarbonEmission } from '../entities/carbon-emission.entity';
import { CarbonTarget } from '../entities/carbon-target.entity';
import { CarbonOffset } from '../entities/carbon-offset.entity';
import { Device } from '../../device/entities/device.entity';
import { RedisService } from '../../../core/redis/redis.service';

@Injectable()
export class CarbonDashboardService {
  private readonly logger = new Logger(CarbonDashboardService.name);

  constructor(
    @InjectRepository(CarbonEmission)
    private carbonEmissionRepo: Repository<CarbonEmission>,
    
    @InjectRepository(CarbonTarget)
    private carbonTargetRepo: Repository<CarbonTarget>,
    
    @InjectRepository(CarbonOffset)
    private carbonOffsetRepo: Repository<CarbonOffset>,
    
    @InjectRepository(Device)
    private deviceRepo: Repository<Device>,
    
    private redisService: RedisService,
  ) {}

  /**
   * Get dashboard overview
   */
  async getDashboardOverview(period: 'TODAY' | 'WEEK' | 'MONTH' | 'YEAR'): Promise<any> {
    const now = new Date();
    let startDate: Date;

    switch (period) {
      case 'TODAY':
        startDate = startOfDay(now);
        break;
      case 'WEEK':
        startDate = subDays(now, 7);
        break;
      case 'MONTH':
        startDate = subDays(now, 30);
        break;
      case 'YEAR':
        startDate = subDays(now, 365);
        break;
      default:
        startDate = subDays(now, 7);
    }

    // Get emissions data
    const emissions = await this.getEmissionsData(startDate, now);
    
    // Get targets data
    const targets = await this.getTargetsData();
    
    // Get offsets data
    const offsets = await this.getOffsetsData(startDate, now);
    
    // Get device data
    const devices = await this.getDevicesData(startDate, now);

    // Calculate metrics
    const totalEmissions = emissions.reduce((sum, e) => sum + e.co2e, 0);
    const totalOffsets = offsets.reduce((sum, o) => sum + o.offsetAmount, 0);
    const netEmissions = totalEmissions - totalOffsets;

    // Calculate intensity
    const totalEnergy = emissions.reduce((sum, e) => sum + e.energyConsumption, 0);
    const carbonIntensity = totalEnergy > 0 ? totalEmissions / totalEnergy : 0;

    // Calculate target progress
    const targetProgress = await this.calculateTargetProgress(targets);

    // Generate charts data
    const charts = await this.generateChartsData(startDate, now);

    return {
      period,
      metrics: {
        totalEmissions: totalEmissions.toFixed(2),
        totalOffsets: totalOffsets.toFixed(2),
        netEmissions: netEmissions.toFixed(2),
        carbonIntensity: carbonIntensity.toFixed(3),
        energyConsumed: totalEnergy.toFixed(2),
        devicesMonitored: devices.length,
        activeTargets: targets.filter(t => t.status === 'ACTIVE').length,
      },
      targets: targetProgress,
      topEmitters: await this.getTopEmitters(startDate, now, 5),
      recentEmissions: await this.getRecentEmissions(10),
      charts,
      recommendations: this.generateDashboardRecommendations(totalEmissions, targetProgress, devices),
    };
  }

  /**
   * Get emissions data for period
   */
  private async getEmissionsData(startDate: Date, endDate: Date): Promise<any[]> {
    const emissions = await this.carbonEmissionRepo.find({
      where: {
        timestamp: Between(startDate, endDate),
      },
    });

    return emissions.map(e => ({
      id: e.id,
      co2e: parseFloat(e.co2e.toString()),
      energyConsumption: parseFloat(e.energyConsumption.toString()),
      timestamp: e.timestamp,
      device: e.device?.name,
      source: e.emissionSource,
    }));
  }

  /**
   * Get active targets data
   */
  private async getTargetsData(): Promise<any[]> {
    const targets = await this.carbonTargetRepo.find({
      where: { isActive: true },
      relations: ['device'],
    });

    return targets.map(t => ({
      id: t.id,
      name: t.name,
      targetValue: t.targetValue,
      currentValue: t.currentValue,
      progressPercentage: t.progressPercentage,
      status: t.status,
      period: t.period,
      startDate: t.startDate,
      endDate: t.endDate,
      device: t.device?.name,
    }));
  }

  /**
   * Get carbon offsets data
   */
  private async getOffsetsData(startDate: Date, endDate: Date): Promise<any[]> {
    const offsets = await this.carbonOffsetRepo.find({
      where: {
        offsetDate: Between(startDate, endDate),
        isVerified: true,
      },
      relations: ['device'],
    });

    return offsets.map(o => ({
      id: o.id,
      projectName: o.projectName,
      projectType: o.projectType,
      offsetAmount: o.offsetAmount,
      offsetDate: o.offsetDate,
      device: o.device?.name,
      certification: o.certification,
    }));
  }

  /**
   * Get devices data with emissions
   */
  private async getDevicesData(startDate: Date, endDate: Date): Promise<any[]> {
    const devices = await this.deviceRepo.find({
      where: { isActive: true },
    });

    const devicesWithEmissions = await Promise.all(
      devices.map(async (device) => {
        const emissions = await this.carbonEmissionRepo.find({
          where: {
            device: { id: device.id },
            timestamp: Between(startDate, endDate),
          },
        });

        const totalCO2e = emissions.reduce((sum, e) => 
          sum + parseFloat(e.co2e.toString()), 0
        );

        const totalEnergy = emissions.reduce((sum, e) => 
          sum + parseFloat(e.energyConsumption.toString()), 0
        );

        return {
          id: device.id,
          name: device.name,
          type: device.type,
          status: device.status,
          location: device.location,
          totalCO2e: totalCO2e.toFixed(2),
          totalEnergy: totalEnergy.toFixed(2),
          efficiency: totalEnergy > 0 ? (totalCO2e / totalEnergy).toFixed(3) : 'N/A',
        };
      })
    );

    return devicesWithEmissions;
  }

  /**
   * Calculate target progress
   */
  private async calculateTargetProgress(targets: any[]): Promise<any> {
    const now = new Date();
    
    return targets.map(target => {
      const daysRemaining = Math.ceil(
        (new Date(target.endDate).getTime() - now.getTime()) / (1000 * 3600 * 24)
      );

      const dailyBudget = daysRemaining > 0 
        ? (target.targetValue - target.currentValue) / daysRemaining
        : 0;

      const statusColor = this.getTargetStatusColor(target.progressPercentage);

      return {
        ...target,
        daysRemaining: Math.max(daysRemaining, 0),
        dailyBudget: dailyBudget.toFixed(2),
        statusColor,
        isOnTrack: dailyBudget >= 0 && target.progressPercentage <= 100,
      };
    });
  }

  /**
   * Get target status color
   */
  private getTargetStatusColor(progress: number): string {
    if (progress <= 70) return '#4CAF50'; // Green
    if (progress <= 90) return '#FFC107'; // Yellow
    if (progress <= 100) return '#FF9800'; // Orange
    return '#F44336'; // Red
  }

  /**
   * Get top emitting devices
   */
  private async getTopEmitters(
    startDate: Date,
    endDate: Date,
    limit: number,
  ): Promise<any[]> {
    const topEmitters = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('device.name', 'deviceName')
      .addSelect('device.type', 'deviceType')
      .addSelect('SUM(emission.co2e)', 'totalCO2e')
      .addSelect('SUM(emission.energyConsumption)', 'totalEnergy')
      .leftJoin('emission.device', 'device')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .andWhere('device.id IS NOT NULL')
      .groupBy('device.name, device.type')
      .orderBy('totalCO2e', 'DESC')
      .limit(limit)
      .getRawMany();

    return topEmitters.map(e => ({
      deviceName: e.deviceName,
      deviceType: e.deviceType,
      totalCO2e: parseFloat(e.totalCO2e).toFixed(2),
      totalEnergy: parseFloat(e.totalEnergy).toFixed(2),
      intensity: (parseFloat(e.totalCO2e) / parseFloat(e.totalEnergy)).toFixed(3),
    }));
  }

  /**
   * Get recent emissions
   */
  private async getRecentEmissions(limit: number): Promise<any[]> {
    const emissions = await this.carbonEmissionRepo.find({
      where: {},
      relations: ['device'],
      order: { timestamp: 'DESC' },
      take: limit,
    });

    return emissions.map(e => ({
      id: e.id,
      device: e.device?.name || 'Unknown',
      co2e: parseFloat(e.co2e.toString()).toFixed(3),
      energy: parseFloat(e.energyConsumption.toString()).toFixed(3),
      timestamp: e.timestamp,
      source: e.emissionSource,
    }));
  }

  /**
   * Generate charts data
   */
  private async generateChartsData(startDate: Date, endDate: Date): Promise<any> {
    // Daily emissions trend
    const dailyTrend = await this.getDailyTrend(startDate, endDate);
    
    // Device-wise breakdown
    const deviceBreakdown = await this.getDeviceBreakdown(startDate, endDate);
    
    // Hourly pattern
    const hourlyPattern = await this.getHourlyPattern(startDate, endDate);
    
    // Source-wise breakdown
    const sourceBreakdown = await this.getSourceBreakdown(startDate, endDate);

    return {
      dailyTrend: {
        type: 'line',
        title: 'Daily Carbon Emissions Trend',
        data: dailyTrend,
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'CO2e (kg)',
              },
            },
            x: {
              title: {
                display: true,
                text: 'Date',
              },
            },
          },
        },
      },
      deviceBreakdown: {
        type: 'doughnut',
        title: 'Emissions by Device',
        data: deviceBreakdown,
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'right',
            },
          },
        },
      },
      hourlyPattern: {
        type: 'bar',
        title: 'Hourly Emission Pattern',
        data: hourlyPattern,
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'CO2e (kg)',
              },
            },
            x: {
              title: {
                display: true,
                text: 'Hour of Day',
              },
            },
          },
        },
      },
      sourceBreakdown: {
        type: 'pie',
        title: 'Emissions by Source',
        data: sourceBreakdown,
        options: {
          responsive: true,
          plugins: {
            legend: {
              position: 'bottom',
            },
          },
        },
      },
    };
  }

  /**
   * Get daily trend data
   */
  private async getDailyTrend(startDate: Date, endDate: Date): Promise<any> {
    const dailyData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select("DATE(emission.timestamp)", "date")
      .addSelect('SUM(emission.co2e)', 'co2e')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .groupBy('DATE(emission.timestamp)')
      .orderBy('date', 'ASC')
      .getRawMany();

    return {
      labels: dailyData.map(d => format(new Date(d.date), 'MMM dd')),
      datasets: [{
        label: 'CO2e (kg)',
        data: dailyData.map(d => parseFloat(d.co2e).toFixed(2)),
        borderColor: '#F44336',
        backgroundColor: 'rgba(244, 67, 54, 0.1)',
        tension: 0.4,
      }],
    };
  }

  /**
   * Get device breakdown data
   */
  private async getDeviceBreakdown(startDate: Date, endDate: Date): Promise<any> {
    const deviceData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('device.name', 'deviceName')
      .addSelect('SUM(emission.co2e)', 'co2e')
      .leftJoin('emission.device', 'device')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .andWhere('device.id IS NOT NULL')
      .groupBy('device.name')
      .getRawMany();

    // Color palette for devices
    const colors = [
      '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', 
      '#9966FF', '#FF9F40', '#8AC926', '#1982C4',
      '#6A4C93', '#FF595E'
    ];

    return {
      labels: deviceData.map(d => d.deviceName),
      datasets: [{
        data: deviceData.map(d => parseFloat(d.co2e).toFixed(2)),
        backgroundColor: deviceData.map((_, i) => colors[i % colors.length]),
        borderWidth: 1,
      }],
    };
  }

  /**
   * Get hourly pattern data
   */
  private async getHourlyPattern(startDate: Date, endDate: Date): Promise<any> {
    const hourlyData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('EXTRACT(HOUR FROM emission.timestamp)', 'hour')
      .addSelect('AVG(emission.co2e)', 'avgCO2e')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .groupBy('EXTRACT(HOUR FROM emission.timestamp)')
      .orderBy('hour', 'ASC')
      .getRawMany();

    // Fill missing hours
    const hours = Array.from({ length: 24 }, (_, i) => i);
    const hourMap = new Map(
      hourlyData.map(d => [parseInt(d.hour), parseFloat(d.avgCO2e)])
    );

    const data = hours.map(hour => hourMap.get(hour) || 0);

    return {
      labels: hours.map(h => `${h}:00`),
      datasets: [{
        label: 'Average CO2e (kg)',
        data: data.map(d => d.toFixed(3)),
        backgroundColor: hours.map(hour => {
          // Color based on hour (darker for peak hours)
          const intensity = hour >= 9 && hour <= 17 ? 0.8 : 0.4;
          return `rgba(244, 67, 54, ${intensity})`;
        }),
        borderColor: '#F44336',
        borderWidth: 1,
      }],
    };
  }

  /**
   * Get source breakdown data
   */
  private async getSourceBreakdown(startDate: Date, endDate: Date): Promise<any> {
    const sourceData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('emission.emissionSource', 'source')
      .addSelect('SUM(emission.co2e)', 'co2e')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .andWhere('emission.emissionSource IS NOT NULL')
      .groupBy('emission.emissionSource')
      .getRawMany();

    // Color mapping for sources
    const sourceColors: Record<string, string> = {
      ELECTRICITY: '#FF6384',
      FUEL: '#36A2EB',
      PROCESS: '#FFCE56',
      RENEWABLE_ENERGY: '#4BC0C0',
      TRANSPORTATION: '#9966FF',
      OTHER: '#C9CBCF',
    };

    return {
      labels: sourceData.map(d => d.source),
      datasets: [{
        data: sourceData.map(d => parseFloat(d.co2e).toFixed(2)),
        backgroundColor: sourceData.map(d => 
          sourceColors[d.source] || sourceColors.OTHER
        ),
        borderWidth: 1,
      }],
    };
  }

  /**
   * Generate dashboard recommendations
   */
  private generateDashboardRecommendations(
    totalEmissions: number,
    targets: any[],
    devices: any[],
  ): string[] {
    const recommendations = [];

    // High emission recommendation
    if (totalEmissions > 1000) {
      recommendations.push('Consider implementing a comprehensive carbon reduction strategy');
    }

    // Target-related recommendations
    const offTrackTargets = targets.filter(t => !t.isOnTrack);
    if (offTrackTargets.length > 0) {
      recommendations.push(
        `${offTrackTargets.length} carbon targets are off-track. Review and adjust strategies.`
      );
    }

    // Device efficiency recommendations
    const inefficientDevices = devices.filter(d => 
      d.efficiency !== 'N/A' && parseFloat(d.efficiency) > 0.6
    );
    if (inefficientDevices.length > 0) {
      recommendations.push(
        `${inefficientDevices.length} devices have high carbon intensity. Consider upgrades or replacements.`
      );
    }

    // Time-based recommendations
    const now = new Date();
    const hour = now.getHours();
    if (hour >= 9 && hour <= 17) {
      recommendations.push('Currently in peak hours. Consider reducing non-essential energy use.');
    }

    // General recommendations
    recommendations.push('Regular maintenance can reduce emissions by 10-15%');
    recommendations.push('Consider shifting high-energy tasks to off-peak hours');
    recommendations.push('Explore carbon offset projects to neutralize remaining emissions');

    return recommendations.slice(0, 5);
  }

  /**
   * Get carbon footprint comparison
   */
  async getFootprintComparison(
    period: 'WEEK' | 'MONTH' | 'QUARTER',
  ): Promise<any> {
    const now = new Date();
    let comparisonPeriods: Array<{ start: Date; end: Date; label: string }> = [];

    switch (period) {
      case 'WEEK':
        comparisonPeriods = Array.from({ length: 4 }, (_, i) => {
          const end = new Date(now.getTime() - i * 7 * 86400000);
          const start = new Date(end.getTime() - 7 * 86400000);
          return {
            start,
            end,
            label: `Week ${4 - i}`,
          };
        });
        break;
      case 'MONTH':
        comparisonPeriods = Array.from({ length: 6 }, (_, i) => {
          const end = new Date(now.getFullYear(), now.getMonth() - i + 1, 0);
          const start = new Date(now.getFullYear(), now.getMonth() - i, 1);
          return {
            start,
            end,
            label: format(start, 'MMM yyyy'),
          };
        });
        break;
      case 'QUARTER':
        comparisonPeriods = Array.from({ length: 4 }, (_, i) => {
          const quarter = Math.floor((now.getMonth() - i * 3) / 3);
          const year = now.getFullYear() - Math.floor((now.getMonth() - i * 3) / 12);
          const startMonth = quarter * 3;
          const endMonth = startMonth + 2;
          const start = new Date(year, startMonth, 1);
          const end = new Date(year, endMonth + 1, 0);
          return {
            start,
            end,
            label: `Q${quarter + 1} ${year}`,
          };
        });
        break;
    }

    // Get emissions for each period
    const periodData = await Promise.all(
      comparisonPeriods.map(async (period) => {
        const emissions = await this.carbonEmissionRepo.find({
          where: {
            timestamp: Between(period.start, period.end),
          },
        });

        const totalCO2e = emissions.reduce((sum, e) => 
          sum + parseFloat(e.co2e.toString()), 0
        );

        const totalEnergy = emissions.reduce((sum, e) => 
          sum + parseFloat(e.energyConsumption.toString()), 0
        );

        return {
          ...period,
          totalCO2e: totalCO2e.toFixed(2),
          totalEnergy: totalEnergy.toFixed(2),
          intensity: totalEnergy > 0 ? (totalCO2e / totalEnergy).toFixed(3) : '0',
          deviceCount: new Set(emissions.map(e => e.device?.id)).size,
        };
      })
    );

    // Calculate trends
    const co2eTrend = this.calculateTrend(
      periodData.map(p => parseFloat(p.totalCO2e))
    );
    const intensityTrend = this.calculateTrend(
      periodData.filter(p => p.intensity !== '0').map(p => parseFloat(p.intensity))
    );

    return {
      period,
      periods: periodData.reverse(), // Most recent first
      trends: {
        co2e: co2eTrend,
        intensity: intensityTrend,
      },
      summary: {
        currentTotal: periodData[0]?.totalCO2e || '0',
        previousTotal: periodData[1]?.totalCO2e || '0',
        changePercentage: this.calculateChangePercentage(
          parseFloat(periodData[0]?.totalCO2e || '0'),
          parseFloat(periodData[1]?.totalCO2e || '0')
        ),
        bestPeriod: periodData.reduce((best, current) => 
          parseFloat(current.totalCO2e) < parseFloat(best.totalCO2e) ? current : best
        ),
      },
    };
  }

  /**
   * Calculate trend direction
   */
  private calculateTrend(values: number[]): {
    direction: 'INCREASING' | 'DECREASING' | 'STABLE';
    strength: number;
    description: string;
  } {
    if (values.length < 2) {
      return {
        direction: 'STABLE',
        strength: 0,
        description: 'Insufficient data',
      };
    }

    // Simple linear regression
    const n = values.length;
    let sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
    
    values.forEach((y, i) => {
      sumX += i;
      sumY += y;
      sumXY += i * y;
      sumX2 += i * i;
    });

    const slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    const rSquared = this.calculateRSquared(values, slope, sumY / n);

    let direction: 'INCREASING' | 'DECREASING' | 'STABLE';
    if (slope > 0.01) direction = 'INCREASING';
    else if (slope < -0.01) direction = 'DECREASING';
    else direction = 'STABLE';

    const strength = Math.abs(slope) * 100;
    const description = this.getTrendDescription(direction, strength);

    return { direction, strength, description };
  }

  /**
   * Calculate R-squared for trend strength
   */
  private calculateRSquared(values: number[], slope: number, meanY: number): number {
    let ssTotal = 0, ssResidual = 0;
    
    values.forEach((y, i) => {
      ssTotal += Math.pow(y - meanY, 2);
      const predicted = slope * i + meanY;
      ssResidual += Math.pow(y - predicted, 2);
    });

    return 1 - (ssResidual / ssTotal);
  }

  /**
   * Get trend description
   */
  private getTrendDescription(direction: string, strength: number): string {
    const strengthLevel = strength > 10 ? 'strongly' : strength > 5 ? 'moderately' : 'slightly';
    
    switch (direction) {
      case 'INCREASING':
        return `${strengthLevel} increasing`;
      case 'DECREASING':
        return `${strengthLevel} decreasing`;
      default:
        return 'relatively stable';
    }
  }

  /**
   * Calculate percentage change
   */
  private calculateChangePercentage(current: number, previous: number): string {
    if (previous === 0) return 'N/A';
    
    const change = ((current - previous) / previous) * 100;
    return change.toFixed(1);
  }

  /**
   * Get carbon reduction opportunities
   */
  async getReductionOpportunities(): Promise<any> {
    const thirtyDaysAgo = new Date(Date.now() - 30 * 86400000);
    const now = new Date();

    // Get inefficient devices
    const inefficientDevices = await this.getInefficientDevices(thirtyDaysAgo, now);
    
    // Get peak hour usage
    const peakHours = await this.getPeakHourAnalysis(thirtyDaysAgo, now);
    
    // Get potential savings
    const potentialSavings = await this.calculatePotentialSavings(inefficientDevices, peakHours);

    // Get offset opportunities
    const offsetOpportunities = await this.getOffsetOpportunities();

    return {
      inefficientDevices,
      peakHours,
      potentialSavings,
      offsetOpportunities,
      recommendations: this.generateReductionRecommendations(
        inefficientDevices,
        peakHours,
        potentialSavings
      ),
      actionPlan: this.generateActionPlan(
        inefficientDevices,
        peakHours,
        potentialSavings
      ),
    };
  }

  /**
   * Get inefficient devices
   */
  private async getInefficientDevices(startDate: Date, endDate: Date): Promise<any[]> {
    const deviceEfficiency = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('device.id', 'deviceId')
      .addSelect('device.name', 'deviceName')
      .addSelect('device.type', 'deviceType')
      .addSelect('AVG(emission.co2e / emission.energyConsumption)', 'intensity')
      .addSelect('SUM(emission.co2e)', 'totalCO2e')
      .addSelect('SUM(emission.energyConsumption)', 'totalEnergy')
      .leftJoin('emission.device', 'device')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .andWhere('device.id IS NOT NULL')
      .andWhere('emission.energyConsumption > 0')
      .groupBy('device.id, device.name, device.type')
      .having('AVG(emission.co2e / emission.energyConsumption) > 0.5')
      .orderBy('intensity', 'DESC')
      .limit(10)
      .getRawMany();

    return deviceEfficiency.map(d => ({
      deviceId: d.deviceId,
      deviceName: d.deviceName,
      deviceType: d.deviceType,
      intensity: parseFloat(d.intensity).toFixed(3),
      totalCO2e: parseFloat(d.totalCO2e).toFixed(2),
      totalEnergy: parseFloat(d.totalEnergy).toFixed(2),
      potentialReduction: (parseFloat(d.totalCO2e) * 0.15).toFixed(2), // 15% reduction potential
    }));
  }

  /**
   * Get peak hour analysis
   */
  private async getPeakHourAnalysis(startDate: Date, endDate: Date): Promise<any> {
    const hourlyData = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('EXTRACT(HOUR FROM emission.timestamp)', 'hour')
      .addSelect('SUM(emission.co2e)', 'totalCO2e')
      .addSelect('COUNT(DISTINCT emission.deviceId)', 'deviceCount')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .groupBy('EXTRACT(HOUR FROM emission.timestamp)')
      .orderBy('totalCO2e', 'DESC')
      .limit(5)
      .getRawMany();

    return hourlyData.map(h => ({
      hour: parseInt(h.hour),
      totalCO2e: parseFloat(h.totalCO2e).toFixed(2),
      deviceCount: parseInt(h.deviceCount),
      isPeakHour: parseInt(h.hour) >= 9 && parseInt(h.hour) <= 17,
    }));
  }

  /**
   * Calculate potential savings
   */
  private async calculatePotentialSavings(
    inefficientDevices: any[],
    peakHours: any[],
  ): Promise<any> {
    // Device upgrade savings
    const deviceSavings = inefficientDevices.reduce((sum, device) => {
      return sum + parseFloat(device.potentialReduction);
    }, 0);

    // Peak shifting savings (assume 10% reduction by shifting 20% of peak usage)
    const peakCO2e = peakHours.reduce((sum, hour) => {
      return sum + parseFloat(hour.totalCO2e);
    }, 0);
    
    const peakShiftSavings = peakCO2e * 0.2 * 0.1; // 20% of peak usage shifted, 10% reduction

    // Maintenance savings (assume 5% reduction overall)
    const thirtyDaysAgo = new Date(Date.now() - 30 * 86400000);
    const totalCO2e = await this.getTotalEmissions(thirtyDaysAgo, new Date());
    const maintenanceSavings = totalCO2e * 0.05;

    return {
      deviceUpgrades: deviceSavings.toFixed(2),
      peakShifting: peakShiftSavings.toFixed(2),
      maintenance: maintenanceSavings.toFixed(2),
      total: (deviceSavings + peakShiftSavings + maintenanceSavings).toFixed(2),
      roi: {
        deviceUpgrades: (deviceSavings * 12).toFixed(2), // Annual savings
        peakShifting: (peakShiftSavings * 12).toFixed(2),
        maintenance: (maintenanceSavings * 12).toFixed(2),
      },
    };
  }

  /**
   * Get total emissions for period
   */
  private async getTotalEmissions(startDate: Date, endDate: Date): Promise<number> {
    const result = await this.carbonEmissionRepo
      .createQueryBuilder('emission')
      .select('SUM(emission.co2e)', 'totalCO2e')
      .where('emission.timestamp BETWEEN :start AND :end', {
        start: startDate,
        end: endDate,
      })
      .getRawOne();

    return parseFloat(result?.totalCO2e || '0');
  }

  /**
   * Get offset opportunities
   */
  private async getOffsetOpportunities(): Promise<any[]> {
    // This would typically come from an external API or database
    return [
      {
        id: '1',
        name: 'Thai Reforestation Project',
        type: 'AFFORESTATION',
        costPerTon: 25,
        certification: 'Gold Standard',
        location: 'Northern Thailand',
        description: 'Planting native tree species to restore degraded forest',
        impact: '30,000 trees planted annually',
        url: 'https://example.com/project1',
      },
      {
        id: '2',
        name: 'Solar Farm Development',
        type: 'RENEWABLE_ENERGY',
        costPerTon: 40,
        certification: 'VER',
        location: 'Northeastern Thailand',
        description: 'Developing solar farms to replace coal power',
        impact: '10 MW clean energy capacity',
        url: 'https://example.com/project2',
      },
      {
        id: '3',
        name: 'Biogas from Agricultural Waste',
        type: 'ENERGY_EFFICIENCY',
        costPerTon: 20,
        certification: 'CDM',
        location: 'Central Thailand',
        description: 'Converting agricultural waste to biogas for energy',
        impact: 'Reduces methane emissions from waste',
        url: 'https://example.com/project3',
      },
    ];
  }

  /**
   * Generate reduction recommendations
   */
  private generateReductionRecommendations(
    inefficientDevices: any[],
    peakHours: any[],
    potentialSavings: any,
  ): string[] {
    const recommendations = [];

    if (inefficientDevices.length > 0) {
      recommendations.push(
        `Upgrade ${inefficientDevices.length} inefficient devices to save ${potentialSavings.deviceUpgrades} kg CO2e/month`
      );
    }

    const peakHourCount = peakHours.filter(h => h.isPeakHour).length;
    if (peakHourCount > 0) {
      recommendations.push(
        `Shift ${peakHourCount} hours of peak usage to save ${potentialSavings.peakShifting} kg CO2e/month`
      );
    }

    if (parseFloat(potentialSavings.maintenance) > 10) {
      recommendations.push(
        `Implement regular maintenance to save ${potentialSavings.maintenance} kg CO2e/month`
      );
    }

    recommendations.push('Consider carbon offset projects for unavoidable emissions');
    recommendations.push('Implement energy monitoring systems for real-time optimization');

    return recommendations;
  }

  /**
   * Generate action plan
   */
  private generateActionPlan(
    inefficientDevices: any[],
    peakHours: any[],
    potentialSavings: any,
  ): any[] {
    const actions = [];

    // Immediate actions (1-2 weeks)
    if (inefficientDevices.length > 0) {
      actions.push({
        priority: 'HIGH',
        timeline: 'IMMEDIATE',
        action: 'Schedule maintenance for inefficient devices',
        responsibility: 'Facilities Manager',
        expectedImpact: `${potentialSavings.deviceUpgrades} kg CO2e/month`,
        cost: 'Low',
      });
    }

    // Short-term actions (1 month)
    if (peakHours.length > 0) {
      actions.push({
        priority: 'MEDIUM',
        timeline: 'SHORT_TERM',
        action: 'Implement peak load shifting strategy',
        responsibility: 'Operations Manager',
        expectedImpact: `${potentialSavings.peakShifting} kg CO2e/month`,
        cost: 'Medium',
      });
    }

    // Medium-term actions (3-6 months)
    actions.push({
      priority: 'MEDIUM',
      timeline: 'MEDIUM_TERM',
      action: 'Conduct energy audit and optimization study',
      responsibility: 'Sustainability Officer',
      expectedImpact: '10-20% overall reduction',
      cost: 'High',
    });

    // Long-term actions (6-12 months)
    actions.push({
      priority: 'LOW',
      timeline: 'LONG_TERM',
      action: 'Invest in renewable energy infrastructure',
      responsibility: 'CEO/CFO',
      expectedImpact: '30-50% reduction in grid dependency',
      cost: 'Very High',
    });

    return actions;
  }
}
```

---

## 6. **Carbon Controller**

### `src/modules/carbon/controllers/carbon.controller.ts`
```typescript
import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  UseInterceptors,
  ClassSerializerInterceptor,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../common/guards/jwt-auth.guard';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { Roles } from '../../../common/decorators/roles.decorator';

import { CarbonCalculatorService } from '../services/carbon-calculator.service';
import { CarbonMonitorService } from '../services/carbon-monitor.service';
import { CarbonDashboardService } from '../services/carbon-dashboard.service';

@ApiTags('carbon')
@Controller('carbon')
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
@ApiBearerAuth()
export class CarbonController {
  constructor(
    private carbonCalculator: CarbonCalculatorService,
    private carbonMonitor: CarbonMonitorService,
    private carbonDashboard: CarbonDashboardService,
  ) {}

  @Get('dashboard/overview')
  @ApiOperation({ summary: 'Get carbon dashboard overview' })
  @ApiQuery({ name: 'period', enum: ['TODAY', 'WEEK', 'MONTH', 'YEAR'], required: false })
  @Roles('admin', 'user', 'viewer')
  async getDashboardOverview(
    @Query('period') period: 'TODAY' | 'WEEK' | 'MONTH' | 'YEAR' = 'WEEK',
  ) {
    return await this.carbonDashboard.getDashboardOverview(period);
  }

  @Get('footprint/calculate')
  @ApiOperation({ summary: 'Calculate carbon footprint' })
  @ApiQuery({ name: 'startDate', type: String, required: true })
  @ApiQuery({ name: 'endDate', type: String, required: true })
  @ApiQuery({ name: 'deviceId', type: String, required: false })
  @Roles('admin', 'user')
  async calculateFootprint(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Query('deviceId') deviceId?: string,
  ) {
    return await this.carbonCalculator.getTotalEmissions(
      new Date(startDate),
      new Date(endDate),
      { deviceId },
    );
  }

  @Get('insights')
  @ApiOperation({ summary: 'Get carbon insights' })
  @ApiQuery({ name: 'period', enum: ['DAY', 'WEEK', 'MONTH'], required: false })
  @Roles('admin', 'user')
  async getInsights(
    @Query('period') period: 'DAY' | 'WEEK' | 'MONTH' = 'WEEK',
  ) {
    return await this.carbonMonitor.getCarbonInsights(period);
  }

  @Get('comparison')
  @ApiOperation({ summary: 'Get carbon footprint comparison' })
  @ApiQuery({ name: 'period', enum: ['WEEK', 'MONTH', 'QUARTER'], required: false })
  @Roles('admin', 'user')
  async getComparison(
    @Query('period') period: 'WEEK' | 'MONTH' | 'QUARTER' = 'MONTH',
  ) {
    return await this.carbonDashboard.getFootprintComparison(period);
  }

  @Get('opportunities')
  @ApiOperation({ summary: 'Get carbon reduction opportunities' })
  @Roles('admin', 'user')
  async getReductionOpportunities() {
    return await this.carbonDashboard.getReductionOpportunities();
  }

  @Get('equivalents/:co2e')
  @ApiOperation({ summary: 'Convert CO2e to understandable equivalents' })
  @Roles('admin', 'user', 'viewer')
  async getEquivalents(@Param('co2e') co2e: string) {
    const co2eKg = parseFloat(co2e);
    return this.carbonCalculator.convertToEquivalents(co2eKg);
  }

  @Get('realtime/monitor')
  @ApiOperation({ summary: 'Monitor real-time carbon emissions' })
  @Roles('admin')
  async monitorRealTime() {
    await this.carbonMonitor.monitorRealTimeEmissions();
    return { message: 'Real-time monitoring completed' };
  }

  @Post('calculate/device')
  @ApiOperation({ summary: 'Calculate carbon from device data' })
  @Roles('admin', 'user')
  async calculateFromDevice(
    @Body() body: {
      deviceId: string;
      power?: number;
      current?: number;
      voltage?: number;
      operatingHours?: number;
    },
  ) {
    // Implementation would fetch device and call calculator
    return { message: 'Calculation initiated' };
  }

  @Get('reports/generate')
  @ApiOperation({ summary: 'Generate carbon report' })
  @ApiQuery({ name: 'type', enum: ['DAILY', 'WEEKLY', 'MONTHLY'], required: false })
  @Roles('admin')
  async generateReport(
    @Query('type') type: 'DAILY' | 'WEEKLY' | 'MONTHLY' = 'WEEKLY',
  ) {
    // Implementation would generate and return report
    return { message: `Generated ${type.toLowerCase()} report` };
  }

  @Get('alerts')
  @ApiOperation({ summary: 'Get carbon emission alerts' })
  @Roles('admin', 'user')
  async getAlerts() {
    // Implementation would fetch and return alerts
    return { alerts: [] };
  }

  @Post('targets/set')
  @ApiOperation({ summary: 'Set carbon reduction target' })
  @Roles('admin')
  async setTarget(
    @Body() body: {
      name: string;
      targetValue: number;
      period: string;
      startDate: string;
      endDate: string;
      deviceId?: string;
    },
  ) {
    // Implementation would create target
    return { message: 'Target set successfully' };
  }

  @Get('targets/progress')
  @ApiOperation({ summary: 'Get carbon targets progress' })
  @Roles('admin', 'user')
  async getTargetsProgress() {
    // Implementation would return targets progress
    return { targets: [] };
  }
}
```

---

## 7. **Integration with Existing Notification System**

### `src/modules/carbon/integration/notification-integration.service.ts`
```typescript
import { Injectable, Logger } from '@nestjs/common';
import { NotificationService } from '../../notification/notification.service';
import { CarbonEmission } from '../entities/carbon-emission.entity';
import { CarbonTarget } from '../entities/carbon-target.entity';

@Injectable()
export class CarbonNotificationIntegration {
  private readonly logger = new Logger(CarbonNotificationIntegration.name);

  constructor(private notificationService: NotificationService) {}

  /**
   * Send carbon-related notifications
   */
  async sendCarbonNotification(
    type: 'ANOMALY' | 'TARGET' | 'THRESHOLD' | 'REPORT',
    data: any,
  ): Promise<void> {
    try {
      let notificationData;

      switch (type) {
        case 'ANOMALY':
          notificationData = this.createAnomalyNotification(data);
          break;
        case 'TARGET':
          notificationData = this.createTargetNotification(data);
          break;
        case 'THRESHOLD':
          notificationData = this.createThresholdNotification(data);
          break;
        case 'REPORT':
          notificationData = this.createReportNotification(data);
          break;
      }

      if (notificationData) {
        // Integrate with existing notification system
        // await this.notificationService.sendNotification(notificationData);
        this.logger.log(`Carbon ${type.toLowerCase()} notification prepared`);
      }
    } catch (error) {
      this.logger.error(`Failed to send carbon notification: ${error.message}`);
    }
  }

  /**
   * Create anomaly notification
   */
  private createAnomalyNotification(data: {
    emission: CarbonEmission;
    baseline: number;
    current: number;
    increasePercentage: number;
  }): any {
    return {
      title: '🚨 Carbon Emission Anomaly Detected',
      message: `
Device: ${data.emission.device?.name}
Current Emission: ${data.current.toFixed(3)} kg CO2e
Baseline: ${data.baseline.toFixed(3)} kg CO2e
Increase: ${data.increasePercentage.toFixed(1)}%

Time: ${data.emission.timestamp.toLocaleString()}

Recommended Actions:
1. Check device for malfunctions
2. Verify power consumption
3. Consider maintenance or replacement
      `,
      priority: 'HIGH',
      channels: ['EMAIL', 'WEB', 'TELEGRAM'],
      metadata: {
        type: 'CARBON_ANOMALY',
        deviceId: data.emission.device?.id,
        emissionId: data.emission.id,
      },
    };
  }

  /**
   * Create target notification
   */
  private createTargetNotification(data: {
    target: CarbonTarget;
    achievement: 'COMPLETED' | 'FAILED';
  }): any {
    const isCompleted = data.achievement === 'COMPLETED';
    
    return {
      title: isCompleted 
        ? '🎉 Carbon Target Achieved!' 
        : '⚠️ Carbon Target Not Met',
      message: `
Target: ${data.target.name}
Period: ${data.target.startDate.toLocaleDateString()} - ${data.target.endDate.toLocaleDateString()}
Target Value: ${data.target.targetValue} kg CO2e
Actual Value: ${data.target.currentValue.toFixed(2)} kg CO2e
${isCompleted 
  ? `Achievement: ${(100 - data.target.progressPercentage).toFixed(1)}% under target!`
  : `Exceeded by: ${(data.target.progressPercentage - 100).toFixed(1)}%`
}

${isCompleted 
  ? 'Congratulations on reducing your carbon footprint!'
  : 'Recommendations:\n1. Review energy consumption patterns\n2. Implement energy efficiency measures\n3. Consider carbon offset options'
}
      `,
      priority: isCompleted ? 'MEDIUM' : 'HIGH',
      channels: ['EMAIL', 'WEB'],
      metadata: {
        type: 'CARBON_TARGET',
        targetId: data.target.id,
        achievement: data.achievement,
      },
    };
  }

  /**
   * Create threshold notification
   */
  private createThresholdNotification(data: {
    target: CarbonTarget;
    threshold: number;
  }): any {
    return {
      title: '📊 Carbon Target Progress Update',
      message: `
Target: ${data.target.name}
Progress: ${data.target.progressPercentage.toFixed(1)}%
Threshold Reached: ${data.threshold}%

Remaining Budget: ${Math.max(data.target.targetValue - data.target.currentValue, 0).toFixed(2)} kg CO2e
Days Remaining: ${this.calculateDaysRemaining(data.target.endDate)}

Keep up the good work!
      `,
      priority: 'LOW',
      channels: ['WEB'],
      metadata: {
        type: 'CARBON_THRESHOLD',
        targetId: data.target.id,
        threshold: data.threshold,
      },
    };
  }

  /**
   * Create report notification
   */
  private createReportNotification(data: {
    period: string;
    totalCO2e: number;
    topDevices: Array<{ name: string; co2e: number }>;
    trends: any;
  }): any {
    return {
      title: `📊 ${data.period} Carbon Footprint Report`,
      message: `
Period: ${data.period}
Total CO2e: ${data.totalCO2e.toFixed(2)} kg

Top Emitting Devices:
${data.topDevices.map((d, i) => 
  `${i + 1}. ${d.name}: ${d.co2e.toFixed(2)} kg`
).join('\n')}

Trend: ${data.trends.trendDirection} (${data.trends.trendStrength})

Check the dashboard for detailed analysis and recommendations.
      `,
      priority: 'LOW',
      channels: ['EMAIL', 'WEB'],
      metadata: {
        type: 'CARBON_REPORT',
        period: data.period,
      },
    };
  }

  /**
   * Calculate days remaining
   */
  private calculateDaysRemaining(endDate: Date): number {
    const now = new Date();
    const timeDiff = endDate.getTime() - now.getTime();
    return Math.ceil(timeDiff / (1000 * 3600 * 24));
  }

  /**
   * Send real-time carbon update via WebSocket
   */
  async sendRealTimeUpdate(emission: CarbonEmission): Promise<void> {
    try {
      const update = {
        type: 'CARBON_UPDATE',
        data: {
          device: emission.device?.name,
          co2e: parseFloat(emission.co2e.toString()).toFixed(3),
          energy: parseFloat(emission.energyConsumption.toString()).toFixed(3),
          timestamp: emission.timestamp,
          intensity: emission.emissionFactor,
        },
      };

      // Integrate with WebSocket gateway
      // await this.webSocketGateway.broadcast('carbon', update);
      this.logger.debug(`Real-time carbon update sent for device ${emission.device?.name}`);
    } catch (error) {
      this.logger.error(`Failed to send real-time update: ${error.message}`);
    }
  }
}
```

---

## 8. **Configuration and Setup**

### `src/modules/carbon/carbon.module.ts`
```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ScheduleModule } from '@nestjs/schedule';

import { CarbonController } from './controllers/carbon.controller';
import { CarbonCalculatorService } from './services/carbon-calculator.service';
import { CarbonMonitorService } from './services/carbon-monitor.service';
import { CarbonDashboardService } from './services/carbon-dashboard.service';
import { CarbonNotificationIntegration } from './integration/notification-integration.service';

import { CarbonEmission } from './entities/carbon-emission.entity';
import { CarbonTarget } from './entities/carbon-target.entity';
import { CarbonOffset } from './entities/carbon-offset.entity';
import { GridIntensity } from './entities/grid-intensity.entity';

import { NotificationModule } from '../notification/notification.module';
import { DeviceModule } from '../device/device.module';
import { SensorModule } from '../sensor/sensor.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      CarbonEmission,
      CarbonTarget,
      CarbonOffset,
      GridIntensity,
    ]),
    ScheduleModule.forRoot(),
    NotificationModule,
    DeviceModule,
    SensorModule,
  ],
  controllers: [CarbonController],
  providers: [
    CarbonCalculatorService,
    CarbonMonitorService,
    CarbonDashboardService,
    CarbonNotificationIntegration,
  ],
  exports: [
    CarbonCalculatorService,
    CarbonMonitorService,
    CarbonDashboardService,
  ],
})
export class CarbonModule {}
```

---

## 9. **API Endpoints Summary**

### **Carbon Management API**

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/carbon/dashboard/overview` | Get dashboard overview | Yes |
| GET | `/carbon/footprint/calculate` | Calculate carbon footprint | Yes |
| GET | `/carbon/insights` | Get carbon insights | Yes |
| GET | `/carbon/comparison` | Compare carbon footprints | Yes |
| GET | `/carbon/opportunities` | Get reduction opportunities | Yes |
| GET | `/carbon/equivalents/{co2e}` | Convert to equivalents | Yes |
| GET | `/carbon/realtime/monitor` | Monitor real-time | Admin only |
| POST | `/carbon/calculate/device` | Calculate from device | Yes |
| GET | `/carbon/reports/generate` | Generate report | Admin only |
| GET | `/carbon/alerts` | Get alerts | Yes |
| POST | `/carbon/targets/set` | Set reduction target | Admin only |
| GET | `/carbon/targets/progress` | Get targets progress | Yes |

---

## 10. **Dashboard Features**

### **Main Dashboard Components:**

1. **Overview Metrics**
   - Total CO2e emissions
   - Net emissions (after offsets)
   - Carbon intensity
   - Energy consumption
   - Devices monitored

2. **Charts & Visualizations**
   - Daily emission trends
   - Device-wise breakdown
   - Hourly patterns
   - Source analysis
   - Target progress

3. **Alerts & Notifications**
   - Anomaly detection
   - Target thresholds
   - Weekly reports
   - Real-time updates

4. **Reduction Opportunities**
   - Inefficient devices
   - Peak hour analysis
   - Potential savings
   - Action plans

5. **Target Management**
   - Set reduction targets
   - Track progress
   - Performance comparison
   - Historical trends

6. **Offset Management**
   - Carbon credit purchase
   - Project selection
   - Impact tracking
   - Certification verification

---

## 11. **Data Flow**

```
Sensor Data → Power Calculation → Energy Consumption → CO2e Calculation
     ↓              ↓                  ↓                  ↓
Real-time → Anomaly Detection → Target Tracking → Dashboard Update
     ↓                  ↓                  ↓              ↓
Notifications → Reports → Insights → Recommendations
```

---

## 12. **Benefits for Your Business**

### **Environmental:**
- 📉 **Reduce carbon footprint** by 15-30%
- 🌳 **Contribute to sustainability** goals
- 🔄 **Monitor real-time emissions**
- 📊 **Track progress** against targets

### **Operational:**
- 💡 **Identify inefficient devices**
- 🕐 **Optimize energy usage** patterns
- 🔧 **Schedule preventive maintenance**
- 📈 **Improve equipment efficiency**

### **Financial:**
- 💰 **Reduce energy costs** by 10-20%
- 📉 **Lower carbon tax** liabilities
- 🏆 **Enhance brand reputation**
- 📊 **Better ESG reporting**

### **Compliance:**
- 📋 **Meet regulatory requirements**
- 📄 **Generate audit reports**
- 🔍 **Transparent tracking**
- ✅ **Certification support**

---

## 13. **Implementation Steps**

1. **Setup Database**
   ```sql
   -- Run migrations for carbon tables
   npm run migration:run
   ```

2. **Configure Emission Factors**
   ```typescript
   // Update DEFAULT_EMISSION_FACTORS in carbon-calculator.service.ts
   ```

3. **Integrate with Existing System**
   ```typescript
   // Add carbon monitoring to device data processing
   ```

4. **Setup Notifications**
   ```typescript
   // Configure carbon alert rules
   ```

5. **Deploy Dashboard**
   ```typescript
   // Create frontend dashboard components
   ```

6. **Train Users**
   ```markdown
   # Provide training on:
   - Setting carbon targets
   - Interpreting reports
   - Taking corrective actions
   ```

---

## 14. **ตัวอย่างข้อมูล Output**

### **Dashboard Overview:**
```json
{
  "period": "WEEK",
  "metrics": {
    "totalEmissions": "245.67",
    "totalOffsets": "50.00",
    "netEmissions": "195.67",
    "carbonIntensity": "0.52",
    "energyConsumed": "472.44",
    "devicesMonitored": "15",
    "activeTargets": "3"
  },
  "topEmitters": [
    {
      "deviceName": "Main AC Unit",
      "deviceType": "AC",
      "totalCO2e": "85.23",
      "totalEnergy": "163.90",
      "intensity": "0.52"
    }
  ],
  "recommendations": [
    "Upgrade Main AC Unit to save 12.78 kg CO2e/month",
    "Shift 3 hours of peak usage to save 8.45 kg CO2e/month"
  ]
}
```

### **Carbon Report:**
```
📊 Weekly Carbon Footprint Report
───────────────────────────────
Period: Last 7 days
Total CO2e: 245.67 kg
Average Daily: 35.10 kg

Top Emitting Devices:
1. Main AC Unit: 85.23 kg
2. Water Pump: 45.67 kg
3. Lighting System: 32.45 kg

Trend: Moderately decreasing

Equivalents:
🌳 11 trees needed to absorb
🚗 2,047 km driven
📱 40,945 smartphone charges
✈️ 0.98 hours of flight

Recommendations:
1. Schedule maintenance for Main AC Unit
2. Implement timer for Water Pump
3. Upgrade to LED lighting
```

ระบบคาร์บอนฟุตปริ้นส์นี้สามารถช่วยให้ธุรกิจของคุณ:
1. **ติดตามและลด** การปล่อยก๊าซเรือนกระจก
2. **ปฏิบัติตาม** กฎระเบียบด้านสิ่งแวดล้อม
3. **ลดค่าใช้จ่าย** พลังงาน
4. **สร้างภาพลักษณ์** องค์กรสีเขียว
5. **เตรียมความพร้อม** สำหรับเศรษฐกิจคาร์บอนต่ำ