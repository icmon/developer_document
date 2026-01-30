/*
 Navicat Premium Dump SQL

 Source Server         : 172.25.99.10
 Source Server Type    : PostgreSQL
 Source Server Version : 150015 (150015)
 Source Host           : 172.25.99.10:5432
 Source Catalog        : nest_cmon
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150015 (150015)
 File Encoding         : 65001

 Date: 16/01/2026 13:50:47
*/


-- ----------------------------
-- Table structure for sd_iot_device_alarm_action
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_iot_device_alarm_action";
CREATE TABLE "public"."sd_iot_device_alarm_action" (
  "alarm_action_id" int4 NOT NULL DEFAULT nextval('sd_iot_device_alarm_action_alarm_action_id_seq'::regclass),
  "action_name" varchar(255) COLLATE "pg_catalog"."default",
  "status_warning" varchar(150) COLLATE "pg_catalog"."default",
  "recovery_warning" varchar(150) COLLATE "pg_catalog"."default",
  "status_alert" varchar(150) COLLATE "pg_catalog"."default",
  "recovery_alert" varchar(150) COLLATE "pg_catalog"."default",
  "email_alarm" int4,
  "line_alarm" int4,
  "telegram_alarm" int4,
  "sms_alarm" int4,
  "nonc_alarm" int4,
  "time_life" int4,
  "event" int4,
  "status" int4
)
;

-- ----------------------------
-- Records of sd_iot_device_alarm_action
-- ----------------------------
INSERT INTO "public"."sd_iot_device_alarm_action" VALUES (1, ' Alarm Sensor  Fan ON', '28.5', '25.5', '35.5', '27.2', 1, 1, 0, 0, 0, 10, 1, 1);
INSERT INTO "public"."sd_iot_device_alarm_action" VALUES (71, ' Alarm AIR', '27.5', '25.5', '35.5', '32.51', 1, 0, 0, 0, 0, 30, 1, 1);
INSERT INTO "public"."sd_iot_device_alarm_action" VALUES (70, ' Alarm Sensor  OFF', '30', '25', '32', '25', 1, 0, 0, 0, 0, 60, 0, 0);

-- ----------------------------
-- Primary Key structure for table sd_iot_device_alarm_action
-- ----------------------------
ALTER TABLE "public"."sd_iot_device_alarm_action" ADD CONSTRAINT "PK_263a057ba286325ecfadbf7d659" PRIMARY KEY ("alarm_action_id");
