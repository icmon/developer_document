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

 Date: 16/01/2026 13:44:34
*/


-- ----------------------------
-- Table structure for sd_alarm_process_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_alarm_process_log";
CREATE TABLE "public"."sd_alarm_process_log" (
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
-- Records of sd_alarm_process_log
-- ----------------------------
INSERT INTO "public"."sd_alarm_process_log" VALUES ('c024aacc-5bf8-4f58-9e40-ca84a779d4ca', 71, 8, 1, '1', '1', '27.5', '25.5', '35.5', '32.51', 0, 0, 0, 0, 1, '1', '2026-01-15', '17:19', '27.5', NULL, '1', ' Warning : temperature : 28.8 ', ' อาคาร 1 ชั้น 1 ระบบแอร์ Warning Device Sensor: temperature: 28.8', '2026-01-15 17:19:09.477', '2026-01-15 17:19:09.477');
INSERT INTO "public"."sd_alarm_process_log" VALUES ('27512d3d-1ca0-4138-b40d-c324e7281cd9', 71, 9, 1, '1', '1', '27.5', '25.5', '35.5', '32.51', 0, 0, 0, 0, 1, '1', '2026-01-15', '17:19', '27.5', NULL, '1', ' Warning : temperature : 28.8 ', ' อาคาร 1 ชั้น 1 ระบบแอร์ Warning Device Sensor: temperature: 28.8', '2026-01-15 17:19:13.59', '2026-01-15 17:19:13.59');
INSERT INTO "public"."sd_alarm_process_log" VALUES ('ed4cdadf-3dc7-4bf4-a21c-f8940df927fc', 1, 5, 1, '1', '1', '28.5', '25.5', '35.5', '27.2', 0, 0, 0, 0, 1, '1', '2026-01-15', '17:28', '28.5', NULL, '1', ' Warning : temperature : 30.1 ', ' อาคาร 1 ชั้น 2 Warning Device Sensor: temperature: 30.1', '2026-01-15 17:28:07.087', '2026-01-15 17:28:07.087');
INSERT INTO "public"."sd_alarm_process_log" VALUES ('2a43b356-1c15-4b49-a200-8d679a04d6e1', 1, 6, 1, '1', '1', '28.5', '25.5', '35.5', '27.2', 0, 0, 0, 0, 1, '1', '2026-01-15', '17:29', '28.5', NULL, '1', ' Warning : temperature : 30.1 ', ' อาคาร 1 ชั้น 2 Warning Device Sensor: temperature: 30.1', '2026-01-15 17:29:07.493', '2026-01-15 17:29:07.493');

-- ----------------------------
-- Uniques structure for table sd_alarm_process_log
-- ----------------------------
ALTER TABLE "public"."sd_alarm_process_log" ADD CONSTRAINT "UQ_7e1f2a42bb03e3042139717d283" UNIQUE ("alarm_action_id", "device_id", "type_id", "date", "time", "alarm_status");

-- ----------------------------
-- Primary Key structure for table sd_alarm_process_log
-- ----------------------------
ALTER TABLE "public"."sd_alarm_process_log" ADD CONSTRAINT "PK_bf05866d307414aca1cb0fa22bb" PRIMARY KEY ("id");
