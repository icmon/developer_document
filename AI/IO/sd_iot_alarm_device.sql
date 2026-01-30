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

 Date: 16/01/2026 13:48:09
*/


-- ----------------------------
-- Table structure for sd_iot_alarm_device
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_iot_alarm_device";
CREATE TABLE "public"."sd_iot_alarm_device" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "alarm_action_id" int4,
  "device_id" int4
)
;

-- ----------------------------
-- Primary Key structure for table sd_iot_alarm_device
-- ----------------------------
ALTER TABLE "public"."sd_iot_alarm_device" ADD CONSTRAINT "PK_f25b128c3c65fcb6c16627e3c15" PRIMARY KEY ("id");
