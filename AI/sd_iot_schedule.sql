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

 Date: 16/01/2026 13:42:56
*/


-- ----------------------------
-- Table structure for sd_iot_schedule
-- ----------------------------
DROP TABLE IF EXISTS "public"."sd_iot_schedule";
CREATE TABLE "public"."sd_iot_schedule" (
  "schedule_id" int4 NOT NULL DEFAULT nextval('sd_iot_schedule_schedule_id_seq'::regclass),
  "schedule_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "device_id" int4,
  "start" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "event" int4,
  "sunday" int4,
  "monday" int4,
  "tuesday" int4,
  "wednesday" int4,
  "thursday" int4,
  "friday" int4,
  "saturday" int4,
  "createddate" timestamp(6) NOT NULL DEFAULT now(),
  "updateddate" timestamp(6) NOT NULL DEFAULT now(),
  "status" int4
)
;

-- ----------------------------
-- Records of sd_iot_schedule
-- ----------------------------
INSERT INTO "public"."sd_iot_schedule" VALUES (25, 'TASK 18', 1, '02:00', 0, 0, 1, 1, 1, 1, 1, 1, '2025-07-30 13:19:36.436198', '2026-01-01 14:24:18.477715', 0);
INSERT INTO "public"."sd_iot_schedule" VALUES (24, 'TASK 17', 1, '23:59', 1, 0, 1, 1, 1, 1, 1, 1, '2025-07-30 13:19:08.573638', '2026-01-01 14:24:20.32617', 0);
INSERT INTO "public"."sd_iot_schedule" VALUES (4, 'TASK 4', 1, '08:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:16:05.286756', '2026-01-03 02:43:33.299292', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (3, 'TASK 3', 1, '07:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 14:56:16.512273', '2026-01-03 02:43:35.50492', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (20, 'TASK 13', 1, '18:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:16:19.692145', '2026-01-03 02:43:41.802377', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (2, 'TASK 2 :06:00 OFF', 1, '06:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 14:54:28.066507', '2026-01-10 20:13:37.443', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (21, 'TASK 14', 1, '19:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:16:58.5464', '2026-01-10 20:42:36.357', 0);
INSERT INTO "public"."sd_iot_schedule" VALUES (5, 'TASK 5', 1, '09:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:18:14.037309', '2025-10-16 06:58:42.154118', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (6, 'TASK 6', 1, '10:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:21:48.714074', '2025-10-16 06:58:44.168404', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (8, 'TASK 8', 1, '12:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:25:15.71962', '2025-10-16 06:58:48.34584', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (18, 'TASK 11', 1, '15:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:15:20.6672', '2025-10-16 06:58:56.667858', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (19, 'TASK 12', 1, '16:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:15:48.723569', '2025-10-16 06:58:58.716747', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (7, 'TASK 7', 1, '11:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:23:00.502995', '2026-01-11 17:23:13.823', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (22, 'TASK 15', 1, '20:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:17:54.712381', '2026-01-09 15:57:41.429816', 0);
INSERT INTO "public"."sd_iot_schedule" VALUES (1, 'TASK 1  05:00  ON', 1, '05:00', 1, 1, 1, 1, 1, 1, 1, 0, '2025-06-16 02:31:55.869785', '2026-01-11 17:31:02.679', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (10, 'TASK 10', 1, '12:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:35:33.565295', '2026-01-12 11:25:07.912', 1);
INSERT INTO "public"."sd_iot_schedule" VALUES (23, 'TASK 16', 1, '21:00', 0, 1, 1, 1, 1, 1, 1, 1, '2025-07-30 13:18:26.661226', '2026-01-10 06:24:02.963056', 0);
INSERT INTO "public"."sd_iot_schedule" VALUES (9, 'TASK 9', 1, '13:00', 1, 1, 1, 1, 1, 1, 1, 1, '2025-07-04 15:34:38.981455', '2026-01-10 07:08:16.529825', 1);

-- ----------------------------
-- Primary Key structure for table sd_iot_schedule
-- ----------------------------
ALTER TABLE "public"."sd_iot_schedule" ADD CONSTRAINT "PK_380784b437a7a4f03489497dbef" PRIMARY KEY ("schedule_id");
