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

 Date: 16/01/2026 13:45:43
*/


-- ----------------------------
-- Table structure for sd_notification_channel
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_notification_channel";
CREATE TABLE "public"."sd_notification_channel" (
  "id" int4 NOT NULL DEFAULT nextval('sd_notification_channel_id_seq'::regclass),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "icon" varchar(100) COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "handler_class" varchar(200) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of sd_notification_channel
-- ----------------------------
INSERT INTO "public"."sd_notification_channel" VALUES (1, 'Line', 'Line Notification', 'brand-line', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (2, 'Discord', 'Discord Webhook', 'brand-discord', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (3, 'Telegram', 'Telegram Bot', 'brand-telegram', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (4, 'SMS', 'SMS Gateway', 'device-mobile', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (5, 'Web Dashboard', 'Web Interface', 'device-desktop', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (6, 'Device Control', 'Control IoT Devices', 'device-iot', 't', '2026-01-13 03:24:36.194519', NULL);
INSERT INTO "public"."sd_notification_channel" VALUES (7, 'AI Chat Bot', 'AI Python FastAPI', 'robot', 't', '2026-01-13 03:24:36.194519', NULL);

-- ----------------------------
-- Primary Key structure for table sd_notification_channel
-- ----------------------------
ALTER TABLE "public"."sd_notification_channel" ADD CONSTRAINT "sd_notification_channel_pkey" PRIMARY KEY ("id");
