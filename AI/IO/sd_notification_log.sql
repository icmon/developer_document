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

 Date: 16/01/2026 13:46:36
*/


-- ----------------------------
-- Table structure for sd_notification_log
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_notification_log";
CREATE TABLE "public"."sd_notification_log" (
  "device_id" int4,
  "notification_type_id" int4,
  "notification_channel_id" int4,
  "message" text COLLATE "pg_catalog"."default" NOT NULL,
  "response_data" jsonb,
  "sent_at" timestamp(6),
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "template_id" int4,
  "delivered_at" timestamp(6),
  "read_at" timestamp(6),
  "retry_count" int4 NOT NULL DEFAULT 0,
  "error_message" text COLLATE "pg_catalog"."default",
  "message_id" varchar(100) COLLATE "pg_catalog"."default",
  "recipient" varchar(255) COLLATE "pg_catalog"."default",
  "notification_id" varchar COLLATE "pg_catalog"."default" NOT NULL,
  "payload" jsonb,
  "response" jsonb,
  "channel" varchar COLLATE "pg_catalog"."default",
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "status" varchar COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Indexes structure for table sd_notification_log
-- ----------------------------
CREATE INDEX "IDX_3d150ec64375173c4f27efb6f9" ON "public"."sd_notification_log" USING btree (
  "device_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_88bac5a8ae856939e870c4a13f" ON "public"."sd_notification_log" USING btree (
  "created_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_90cc105722e1b46d6a10b5444f" ON "public"."sd_notification_log" USING btree (
  "notification_channel_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_cd5cc0f1d5d812465add3e569d" ON "public"."sd_notification_log" USING btree (
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_ee087e6cacad4d3d098bab8027" ON "public"."sd_notification_log" USING btree (
  "notification_type_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table sd_notification_log
-- ----------------------------
ALTER TABLE "public"."sd_notification_log" ADD CONSTRAINT "PK_633c2f71be7fcc58beca1fad40d" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table sd_notification_log
-- ----------------------------
ALTER TABLE "public"."sd_notification_log" ADD CONSTRAINT "FK_3d150ec64375173c4f27efb6f92" FOREIGN KEY ("device_id") REFERENCES "public"."sd_iot_device" ("device_id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."sd_notification_log" ADD CONSTRAINT "FK_90cc105722e1b46d6a10b5444f6" FOREIGN KEY ("notification_channel_id") REFERENCES "public"."sd_notification_channel" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."sd_notification_log" ADD CONSTRAINT "FK_ee087e6cacad4d3d098bab8027d" FOREIGN KEY ("notification_type_id") REFERENCES "public"."sd_notification_type" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
