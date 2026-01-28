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

 Date: 16/01/2026 13:46:47
*/


-- ----------------------------
-- Table structure for sd_notification_type
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_notification_type";
CREATE TABLE "public"."sd_notification_type" (
  "id" int4 NOT NULL DEFAULT nextval('sd_notification_type_id_seq'::regclass),
  "name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "cooldown_minutes" int4 NOT NULL DEFAULT 10,
  "is_active" bool NOT NULL DEFAULT true,
  "icon" varchar(100) COLLATE "pg_catalog"."default",
  "color" varchar(20) COLLATE "pg_catalog"."default",
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "updated_at" timestamp(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Primary Key structure for table sd_notification_type
-- ----------------------------
ALTER TABLE "public"."sd_notification_type" ADD CONSTRAINT "sd_notification_type_pkey" PRIMARY KEY ("id");
