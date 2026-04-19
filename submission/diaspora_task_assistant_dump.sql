BEGIN TRANSACTION;
CREATE TABLE "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);
CREATE TABLE "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL, "name" varchar(255) NOT NULL);
INSERT INTO "auth_permission" VALUES(1,1,'add_logentry','Can add log entry');
INSERT INTO "auth_permission" VALUES(2,1,'change_logentry','Can change log entry');
INSERT INTO "auth_permission" VALUES(3,1,'delete_logentry','Can delete log entry');
INSERT INTO "auth_permission" VALUES(4,1,'view_logentry','Can view log entry');
INSERT INTO "auth_permission" VALUES(5,3,'add_permission','Can add permission');
INSERT INTO "auth_permission" VALUES(6,3,'change_permission','Can change permission');
INSERT INTO "auth_permission" VALUES(7,3,'delete_permission','Can delete permission');
INSERT INTO "auth_permission" VALUES(8,3,'view_permission','Can view permission');
INSERT INTO "auth_permission" VALUES(9,2,'add_group','Can add group');
INSERT INTO "auth_permission" VALUES(10,2,'change_group','Can change group');
INSERT INTO "auth_permission" VALUES(11,2,'delete_group','Can delete group');
INSERT INTO "auth_permission" VALUES(12,2,'view_group','Can view group');
INSERT INTO "auth_permission" VALUES(13,4,'add_user','Can add user');
INSERT INTO "auth_permission" VALUES(14,4,'change_user','Can change user');
INSERT INTO "auth_permission" VALUES(15,4,'delete_user','Can delete user');
INSERT INTO "auth_permission" VALUES(16,4,'view_user','Can view user');
INSERT INTO "auth_permission" VALUES(17,5,'add_contenttype','Can add content type');
INSERT INTO "auth_permission" VALUES(18,5,'change_contenttype','Can change content type');
INSERT INTO "auth_permission" VALUES(19,5,'delete_contenttype','Can delete content type');
INSERT INTO "auth_permission" VALUES(20,5,'view_contenttype','Can view content type');
INSERT INTO "auth_permission" VALUES(21,6,'add_session','Can add session');
INSERT INTO "auth_permission" VALUES(22,6,'change_session','Can change session');
INSERT INTO "auth_permission" VALUES(23,6,'delete_session','Can delete session');
INSERT INTO "auth_permission" VALUES(24,6,'view_session','Can view session');
INSERT INTO "auth_permission" VALUES(25,7,'add_task','Can add task');
INSERT INTO "auth_permission" VALUES(26,7,'change_task','Can change task');
INSERT INTO "auth_permission" VALUES(27,7,'delete_task','Can delete task');
INSERT INTO "auth_permission" VALUES(28,7,'view_task','Can view task');
INSERT INTO "auth_permission" VALUES(29,8,'add_statushistory','Can add status history');
INSERT INTO "auth_permission" VALUES(30,8,'change_statushistory','Can change status history');
INSERT INTO "auth_permission" VALUES(31,8,'delete_statushistory','Can delete status history');
INSERT INTO "auth_permission" VALUES(32,8,'view_statushistory','Can view status history');
CREATE TABLE "auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "last_name" varchar(150) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL, "first_name" varchar(150) NOT NULL);
CREATE TABLE "auth_user_groups" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "auth_user_user_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "core_statushistory" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "old_status" varchar(20) NOT NULL, "new_status" varchar(20) NOT NULL, "changed_at" datetime NOT NULL, "task_id" bigint NOT NULL REFERENCES "core_task" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "core_statushistory" VALUES(3,'','Pending','2026-04-19 06:21:51.983344',8);
INSERT INTO "core_statushistory" VALUES(4,'','Pending','2026-04-19 06:23:55.049301',9);
INSERT INTO "core_statushistory" VALUES(5,'','Pending','2026-04-19 06:24:02.411598',10);
INSERT INTO "core_statushistory" VALUES(6,'','Pending','2026-04-19 06:24:09.760746',11);
INSERT INTO "core_statushistory" VALUES(7,'','Pending','2026-04-19 06:24:17.078924',12);
INSERT INTO "core_statushistory" VALUES(8,'','Pending','2026-04-19 06:24:24.414914',13);
INSERT INTO "core_statushistory" VALUES(9,'Pending','In Progress','2026-04-19 06:24:24.449754',9);
INSERT INTO "core_statushistory" VALUES(10,'In Progress','Completed','2026-04-19 06:24:24.473865',9);
INSERT INTO "core_statushistory" VALUES(11,'Pending','In Progress','2026-04-19 06:24:24.496805',10);
INSERT INTO "core_statushistory" VALUES(12,'Pending','Completed','2026-04-19 06:24:24.519018',11);
CREATE TABLE "core_task" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "task_code" varchar(20) NOT NULL UNIQUE, "intent" varchar(50) NOT NULL, "entities" text NOT NULL CHECK ((JSON_VALID("entities") OR "entities" IS NULL)), "risk_score" real NOT NULL, "status" varchar(20) NOT NULL, "steps" text NOT NULL CHECK ((JSON_VALID("steps") OR "steps" IS NULL)), "whatsapp_message" text NOT NULL, "email_message" text NOT NULL, "sms_message" text NOT NULL, "assigned_team" varchar(50) NOT NULL, "created_at" datetime NOT NULL);
INSERT INTO "core_task" VALUES(1,'66605FBD','send_money','{"amount": 15000, "urgency": "high", "recipient": "mother", "location": "Kisumu"}',50.0,'Completed','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 50
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 15000, ''urgency'': ''high'', ''recipient'': ''mother'', ''location'': ''Kisumu''}
Risk Score: 50

Our team is processing your request.
Thank you.','Send Money received. Risk:50. Ref coming.','Finance','2026-04-18 22:22:16.036155');
INSERT INTO "core_task" VALUES(2,'7CE3C8B4','send_money','{"amount": 15000, "recipient": "mother", "location": "Kisumu"}',30.0,'Pending','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 30
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 15000, ''recipient'': ''mother'', ''location'': ''Kisumu''}
Risk Score: 30

Our team is processing your request.
Thank you.','Send Money received. Risk:30. Ref coming.','Finance','2026-04-18 23:50:47.615033');
INSERT INTO "core_task" VALUES(3,'32EE7B97','send_money','{"amount": 2000, "location": "nairobi", "recipient": "john", "urgency": null}',0.0,'Pending','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 0
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 2000, ''location'': ''nairobi'', ''recipient'': ''john'', ''urgency'': None}
Risk Score: 0

Our team is processing your request.
Thank you.','Send Money received. Risk:0. Ref coming.','Finance','2026-04-19 05:46:11.239857');
INSERT INTO "core_task" VALUES(4,'1D171D6E','send_money','{"amount": 2000, "location": "nairobi", "recipient": "john", "urgency": null}',0.0,'Pending','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 0
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 2000, ''location'': ''nairobi'', ''recipient'': ''john'', ''urgency'': None}
Risk Score: 0

Our team is processing your request.
Thank you.','Send Money received. Risk:0. Ref coming.','Finance','2026-04-19 05:48:03.232733');
INSERT INTO "core_task" VALUES(5,'A934AA12','send_money','{"amount": 7000, "location": "nairobi", "recipient": "lisa", "urgency": null}',15.0,'Pending','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 15
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 7000, ''location'': ''nairobi'', ''recipient'': ''lisa'', ''urgency'': None}
Risk Score: 15

Our team is processing your request.
Thank you.','Send Money received. Risk:15. Ref coming.','Finance','2026-04-19 05:49:01.847075');
INSERT INTO "core_task" VALUES(6,'74C49402','send_money','{"amount": 200000, "location": "nairobi", "recipient": "father"}',30.0,'In Progress','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Risk Score: 30
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Intent: send_money
Entities: {''amount'': 200000, ''location'': ''nairobi'', ''recipient'': ''father''}
Risk Score: 30

Our team is processing your request.
Thank you.','Send Money received. Risk:30. Ref coming.','Finance','2026-04-19 06:05:47.831676');
INSERT INTO "core_task" VALUES(8,'D7CB7ADA','send_money','{"amount": 2000, "recipient": "John", "location": "Nairobi"}',0.0,'Pending','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Task Code: D7CB7ADA
Risk Score: 0
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: D7CB7ADA
Intent: send_money
Entities: {''amount'': 2000, ''recipient'': ''John'', ''location'': ''Nairobi''}
Risk Score: 0

Our team is processing your request.
Thank you.','Send Money received. Risk:0. Ref:D7CB7ADA.','Finance','2026-04-19 06:21:51.959300');
INSERT INTO "core_task" VALUES(9,'E46C6C20','send_money','{"amount": 15000, "urgency": "high", "recipient": "mother", "location": "Kisumu"}',50.0,'Completed','["Verify sender identity", "Confirm recipient details", "Process transfer", "Send confirmation"]','Hi 👋
Send Money received.
Task Code: E46C6C20
Risk Score: 50
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: E46C6C20
Intent: send_money
Entities: {''amount'': 15000, ''urgency'': ''high'', ''recipient'': ''mother'', ''location'': ''Kisumu''}
Risk Score: 50

Our team is processing your request.
Thank you.','Send Money received. Risk:50. Ref:E46C6C20.','Finance','2026-04-19 06:23:55.027386');
INSERT INTO "core_task" VALUES(10,'4F39E1DE','verify_document','{"location": "Karen", "document_type": "land_title"}',40.0,'In Progress','["Receive document", "Assign legal officer", "Verify authenticity", "Send report"]','Hi 👋
Verify Document received.
Task Code: 4F39E1DE
Risk Score: 40
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: 4F39E1DE
Intent: verify_document
Entities: {''location'': ''Karen'', ''document_type'': ''land_title''}
Risk Score: 40

Our team is processing your request.
Thank you.','Verify Document received. Risk:40. Ref:4F39E1DE.','Legal','2026-04-19 06:24:02.392582');
INSERT INTO "core_task" VALUES(11,'3A035D66','hire_service','{"location": "Westlands", "service_type": "cleaning"}',5.0,'Completed','["Match service provider", "Confirm availability", "Schedule service", "Confirm completion"]','Hi 👋
Hire Service received.
Task Code: 3A035D66
Risk Score: 5
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: 3A035D66
Intent: hire_service
Entities: {''location'': ''Westlands'', ''service_type'': ''cleaning''}
Risk Score: 5

Our team is processing your request.
Thank you.','Hire Service received. Risk:5. Ref:3A035D66.','Operations','2026-04-19 06:24:09.745798');
INSERT INTO "core_task" VALUES(12,'07951641','get_airport_transfer','{"location": "Nairobi", "service_type": "airport_transfer", "pickup_location": "Jkia", "dropoff_location": "Nairobi"}',10.0,'Pending','["Confirm pickup and dropoff details", "Assign driver", "Schedule airport transfer", "Send trip confirmation"]','Hi 👋
Get Airport Transfer received.
Task Code: 07951641
Risk Score: 10
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: 07951641
Intent: get_airport_transfer
Entities: {''location'': ''Nairobi'', ''service_type'': ''airport_transfer'', ''pickup_location'': ''Jkia'', ''dropoff_location'': ''Nairobi''}
Risk Score: 10

Our team is processing your request.
Thank you.','Get Airport Transfer received. Risk:10. Ref:07951641.','Operations','2026-04-19 06:24:17.057530');
INSERT INTO "core_task" VALUES(13,'41652157','check_status','{}',0.0,'Pending','["Retrieve task", "Check current status", "Return update"]','Hi 👋
Check Status received.
Task Code: 41652157
Risk Score: 0
We’ll update you shortly.','Subject: Task Confirmation

Your request has been successfully logged.

Task Code: 41652157
Intent: check_status
Entities: {}
Risk Score: 0

Our team is processing your request.
Thank you.','Check Status received. Risk:0. Ref:41652157.','Support','2026-04-19 06:24:24.394601');
CREATE TABLE "django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "action_time" datetime NOT NULL);
CREATE TABLE "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);
INSERT INTO "django_content_type" VALUES(1,'admin','logentry');
INSERT INTO "django_content_type" VALUES(2,'auth','group');
INSERT INTO "django_content_type" VALUES(3,'auth','permission');
INSERT INTO "django_content_type" VALUES(4,'auth','user');
INSERT INTO "django_content_type" VALUES(5,'contenttypes','contenttype');
INSERT INTO "django_content_type" VALUES(6,'sessions','session');
INSERT INTO "django_content_type" VALUES(7,'core','task');
INSERT INTO "django_content_type" VALUES(8,'core','statushistory');
CREATE TABLE "django_migrations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "app" varchar(255) NOT NULL, "name" varchar(255) NOT NULL, "applied" datetime NOT NULL);
INSERT INTO "django_migrations" VALUES(1,'contenttypes','0001_initial','2026-04-18 21:23:44.897670');
INSERT INTO "django_migrations" VALUES(2,'auth','0001_initial','2026-04-18 21:23:44.950012');
INSERT INTO "django_migrations" VALUES(3,'admin','0001_initial','2026-04-18 21:23:44.977649');
INSERT INTO "django_migrations" VALUES(4,'admin','0002_logentry_remove_auto_add','2026-04-18 21:23:45.008997');
INSERT INTO "django_migrations" VALUES(5,'admin','0003_logentry_add_action_flag_choices','2026-04-18 21:23:45.029054');
INSERT INTO "django_migrations" VALUES(6,'contenttypes','0002_remove_content_type_name','2026-04-18 21:23:45.078422');
INSERT INTO "django_migrations" VALUES(7,'auth','0002_alter_permission_name_max_length','2026-04-18 21:23:45.102783');
INSERT INTO "django_migrations" VALUES(8,'auth','0003_alter_user_email_max_length','2026-04-18 21:23:45.126587');
INSERT INTO "django_migrations" VALUES(9,'auth','0004_alter_user_username_opts','2026-04-18 21:23:45.147807');
INSERT INTO "django_migrations" VALUES(10,'auth','0005_alter_user_last_login_null','2026-04-18 21:23:45.177421');
INSERT INTO "django_migrations" VALUES(11,'auth','0006_require_contenttypes_0002','2026-04-18 21:23:45.184638');
INSERT INTO "django_migrations" VALUES(12,'auth','0007_alter_validators_add_error_messages','2026-04-18 21:23:45.211637');
INSERT INTO "django_migrations" VALUES(13,'auth','0008_alter_user_username_max_length','2026-04-18 21:23:45.240285');
INSERT INTO "django_migrations" VALUES(14,'auth','0009_alter_user_last_name_max_length','2026-04-18 21:23:45.269641');
INSERT INTO "django_migrations" VALUES(15,'auth','0010_alter_group_name_max_length','2026-04-18 21:23:45.300000');
INSERT INTO "django_migrations" VALUES(16,'auth','0011_update_proxy_permissions','2026-04-18 21:23:45.320831');
INSERT INTO "django_migrations" VALUES(17,'auth','0012_alter_user_first_name_max_length','2026-04-18 21:23:45.350797');
INSERT INTO "django_migrations" VALUES(18,'core','0001_initial','2026-04-18 21:23:45.367680');
INSERT INTO "django_migrations" VALUES(19,'sessions','0001_initial','2026-04-18 21:23:45.390682');
INSERT INTO "django_migrations" VALUES(20,'core','0002_statushistory','2026-04-19 06:20:30.180968');
CREATE TABLE "django_session" ("session_key" varchar(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" datetime NOT NULL);
CREATE UNIQUE INDEX "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");
CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");
CREATE UNIQUE INDEX "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" ("user_id", "group_id");
CREATE INDEX "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" ("user_id");
CREATE INDEX "auth_user_groups_group_id_97559544" ON "auth_user_groups" ("group_id");
CREATE UNIQUE INDEX "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" ("user_id", "permission_id");
CREATE INDEX "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" ("permission_id");
CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");
CREATE INDEX "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");
CREATE INDEX "core_statushistory_task_id_0142a820" ON "core_statushistory" ("task_id");
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('django_migrations',20);
INSERT INTO "sqlite_sequence" VALUES('django_admin_log',0);
INSERT INTO "sqlite_sequence" VALUES('django_content_type',8);
INSERT INTO "sqlite_sequence" VALUES('auth_permission',32);
INSERT INTO "sqlite_sequence" VALUES('auth_group',0);
INSERT INTO "sqlite_sequence" VALUES('auth_user',0);
INSERT INTO "sqlite_sequence" VALUES('core_task',13);
INSERT INTO "sqlite_sequence" VALUES('core_statushistory',12);
COMMIT;
