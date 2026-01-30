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

 Date: 16/01/2026 13:46:27
*/


-- ----------------------------
-- Table structure for sd_notification_condition
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_notification_condition";
CREATE TABLE "public"."sd_notification_condition" (
  "id" int4 NOT NULL DEFAULT nextval('sd_notification_condition_id_seq'::regclass),
  "device_id" int4 NOT NULL,
  "notification_type_id" int4 NOT NULL,
  "condition_operator" varchar(10) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'between'::character varying,
  "priority" int4 NOT NULL DEFAULT 1,
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamp(6) NOT NULL DEFAULT now(),
  "minValue" numeric(10,2),
  "maxValue" numeric(10,2)
)
;

-- ----------------------------
-- Indexes structure for table sd_notification_condition
-- ----------------------------
CREATE INDEX "IDX_25494d634f9621ad079daec13c" ON "public"."sd_notification_condition" USING btree (
  "notification_type_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_49b905d65431649bc212f20a6d" ON "public"."sd_notification_condition" USING btree (
  "device_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "IDX_d26fd1ce5db5c3dd92a1dc1b1a" ON "public"."sd_notification_condition" USING btree (
  "is_active" "pg_catalog"."bool_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table sd_notification_condition
-- ----------------------------
ALTER TABLE "public"."sd_notification_condition" ADD CONSTRAINT "sd_notification_condition_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table sd_notification_condition
-- ----------------------------
ALTER TABLE "public"."sd_notification_condition" ADD CONSTRAINT "FK_25494d634f9621ad079daec13c2" FOREIGN KEY ("notification_type_id") REFERENCES "public"."sd_notification_type" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."sd_notification_condition" ADD CONSTRAINT "FK_49b905d65431649bc212f20a6dc" FOREIGN KEY ("device_id") REFERENCES "public"."sd_iot_device" ("device_id") ON DELETE CASCADE ON UPDATE NO ACTION;
