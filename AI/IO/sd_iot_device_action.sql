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

 Date: 16/01/2026 13:44:06
*/


-- ----------------------------
-- Table structure for sd_iot_device_action
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_iot_device_action";
CREATE TABLE "public"."sd_iot_device_action" (
  "device_action_user_id" int4 NOT NULL DEFAULT nextval('sd_iot_device_action_device_action_user_id_seq'::regclass),
  "alarm_action_id" int4,
  "device_id" int4
)
;

-- ----------------------------
-- Primary Key structure for table sd_iot_device_action
-- ----------------------------
ALTER TABLE "public"."sd_iot_device_action" ADD CONSTRAINT "PK_a146554159a27494fd0c4cb0414" PRIMARY KEY ("device_action_user_id");
