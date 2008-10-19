CREATE TABLE "activities" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ticket_id" integer DEFAULT NULL NULL, "user_id" integer DEFAULT NULL NULL, "text" varchar(255) DEFAULT NULL NULL, "date" date DEFAULT NULL NULL, "minutes" integer DEFAULT NULL NULL, "started_at" datetime DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL, "stopped_at" datetime DEFAULT NULL NULL);
CREATE TABLE "categories" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL);
CREATE TABLE "components" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL);
CREATE TABLE "memberships" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer DEFAULT NULL NULL, "user_id" integer DEFAULT NULL NULL);
CREATE TABLE "milestones" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "remote_id" integer DEFAULT NULL NULL, "project_id" integer DEFAULT NULL NULL, "release_id" integer DEFAULT NULL NULL, "type" varchar(255) DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL, "body" text DEFAULT NULL NULL, "start_at" date DEFAULT NULL NULL, "end_at" date DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL);
CREATE TABLE "projects" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "lighthouse_account" varchar(255) DEFAULT NULL NULL, "lighthouse_token" varchar(255) DEFAULT NULL NULL, "remote_id" integer DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL, "body" text DEFAULT NULL NULL, "synced_at" datetime DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL);
CREATE TABLE "scheduled_days" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "project_id" integer DEFAULT NULL NULL, "user_id" integer DEFAULT NULL NULL, "day" date DEFAULT NULL NULL, "hours" integer DEFAULT NULL NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "ticket_versions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "ticket_id" integer DEFAULT NULL NULL, "version" integer DEFAULT NULL NULL, "estimated" float DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL, "sprint_id" integer);
CREATE TABLE "tickets" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "remote_id" integer DEFAULT NULL NULL, "parent_id" integer DEFAULT NULL NULL, "project_id" integer DEFAULT NULL NULL, "release_id" integer DEFAULT NULL NULL, "sprint_id" integer DEFAULT NULL NULL, "category_id" integer DEFAULT NULL NULL, "component_id" integer DEFAULT NULL NULL, "user_id" integer DEFAULT NULL NULL, "title" varchar(255) DEFAULT NULL NULL, "body" text DEFAULT NULL NULL, "estimated" float DEFAULT NULL NULL, "actual" float DEFAULT NULL NULL, "state" varchar(255) DEFAULT NULL NULL, "closed" integer DEFAULT NULL NULL, "local" integer DEFAULT NULL NULL, "priority" integer DEFAULT NULL NULL, "created_at" datetime DEFAULT NULL NULL, "updated_at" datetime DEFAULT NULL NULL, "version" integer);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "remote_id" integer DEFAULT NULL NULL, "name" varchar(255) DEFAULT NULL NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20081003095733');

INSERT INTO schema_migrations (version) VALUES ('20081003103912');

INSERT INTO schema_migrations (version) VALUES ('20081003120619');

INSERT INTO schema_migrations (version) VALUES ('20081003120620');

INSERT INTO schema_migrations (version) VALUES ('20081003120621');

INSERT INTO schema_migrations (version) VALUES ('20081003120622');

INSERT INTO schema_migrations (version) VALUES ('20081003120623');

INSERT INTO schema_migrations (version) VALUES ('20081005075922');

INSERT INTO schema_migrations (version) VALUES ('20081005082826');

INSERT INTO schema_migrations (version) VALUES ('20081005083905');

INSERT INTO schema_migrations (version) VALUES ('20081007133049');

INSERT INTO schema_migrations (version) VALUES ('20081008191637');

INSERT INTO schema_migrations (version) VALUES ('20081008195542');

INSERT INTO schema_migrations (version) VALUES ('20081013124942');