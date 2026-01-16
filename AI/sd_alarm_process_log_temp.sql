/*
 Navicat Premium Dump SQL

 Source Server         : 172.25.99.60
 Source Server Type    : PostgreSQL
 Source Server Version : 150015 (150015)
 Source Host           : 172.25.99.60:5432
 Source Catalog        : nest_cmon
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150015 (150015)
 File Encoding         : 65001

 Date: 16/01/2026 13:42:02
*/


-- ----------------------------
-- Table structure for sd_alarm_process_log_temp
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_alarm_process_log_temp";
CREATE TABLE "public"."sd_alarm_process_log_temp" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "alarm_action_id" int4,
  "device_id" int4,
  "type_id" int4,
  "event" varchar(255) COLLATE "pg_catalog"."default",
  "alarm_type" varchar(255) COLLATE "pg_catalog"."default",
  "status_warning" varchar(150) COLLATE "pg_catalog"."default",
  "recovery_warning" varchar(150) COLLATE "pg_catalog"."default",
  "status_alert" varchar(150) COLLATE "pg_catalog"."default",
  "recovery_alert" varchar(150) COLLATE "pg_catalog"."default",
  "email_alarm" int4,
  "line_alarm" int4,
  "telegram_alarm" int4,
  "sms_alarm" int4,
  "nonc_alarm" int4,
  "status" varchar(150) COLLATE "pg_catalog"."default",
  "date" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "time" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "data" varchar(255) COLLATE "pg_catalog"."default",
  "data_alarm" varchar(255) COLLATE "pg_catalog"."default",
  "alarm_status" varchar(255) COLLATE "pg_catalog"."default",
  "subject" varchar(255) COLLATE "pg_catalog"."default",
  "content" varchar(255) COLLATE "pg_catalog"."default",
  "createddate" timestamp(6) NOT NULL DEFAULT now(),
  "updateddate" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Primary Key structure for table sd_alarm_process_log_temp
-- ----------------------------
ALTER TABLE "public"."sd_alarm_process_log_temp" ADD CONSTRAINT "PK_432d1e132ee5b3c7279ffd75c84" PRIMARY KEY ("id");
