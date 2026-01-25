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

 Date: 16/01/2026 13:47:58
*/


-- ----------------------------
-- Table structure for sd_iot_alarm_device_event
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_iot_alarm_device_event";
CREATE TABLE "public"."sd_iot_alarm_device_event" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "alarm_action_id" int4,
  "device_id" int4
)
;

-- ----------------------------
-- Primary Key structure for table sd_iot_alarm_device_event
-- ----------------------------
ALTER TABLE "public"."sd_iot_alarm_device_event" ADD CONSTRAINT "PK_25f5163f34e3ba4824c5b5a2a20" PRIMARY KEY ("id");
