-- Represent business departments responsible for employees and risks
CREATE TABLE "departments" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    PRIMARY KEY("id")
);

-- Represent employees who may own risks, actions, controls, or audits
CREATE TABLE "employees" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "role" TEXT NOT NULL,
    "department_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("department_id") REFERENCES "departments"("id")
);

-- Represent high-level risk categories
CREATE TABLE "risk_categories" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    PRIMARY KEY("id")
);

-- Represent identified operational risks
CREATE TABLE "risks" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "category_id" INTEGER NOT NULL,
    "owner_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL CHECK("status" IN ('Open',
        'Mitigating',
        'Under Review',
        'Closed')),
    "created_at" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("category_id") REFERENCES "risk_categories"("id"),
    FOREIGN KEY("owner_id") REFERENCES "employees"("id")
);

    -- Likelihood: 1 = Rare, 2 = Unlikely, 3 = Possible, 4 = Likely, 5 = Almost certain
    -- Impact: 1 = Insignificant, 2 = Minor, 3 = Moderate, 4 = Major, 5 = Severe
-- Represent risk assessments over time
CREATE TABLE "risk_assessments" (
    "id" INTEGER,
    "risk_id" INTEGER NOT NULL,
    "likelihood" INTEGER NOT NULL CHECK("likelihood" BETWEEN 1 AND 5),
    "impact" INTEGER NOT NULL CHECK("impact" BETWEEN 1 AND 5),
    "assessment_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "assessed_by" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("risk_id") REFERENCES "risks"("id"),
    FOREIGN KEY("assessed_by") REFERENCES "employees"("id")
);

-- Represent mitigation actions assigned to reduce risks
CREATE TABLE "mitigation_actions" (
    "id" INTEGER,
    "risk_id" INTEGER NOT NULL,
    "owner_id" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "status" TEXT NOT NULL CHECK("status" IN ('Planned', 'In Progress', 'Completed', 'Cancelled')),
    "due_date" NUMERIC NOT NULL,
    "completed_at" NUMERIC,
    PRIMARY KEY("id"),
    FOREIGN KEY("risk_id") REFERENCES "risks"("id"),
    FOREIGN KEY("owner_id") REFERENCES "employees"("id")
);

-- Represent internal controls linked to risks
CREATE TABLE "controls" (
    "id" INTEGER,
    "risk_id" INTEGER NOT NULL,
    "owner_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "frequency" TEXT NOT NULL CHECK("frequency" IN ('Daily', 'Weekly', 'Monthly', 'Quarterly', 'Annually')),
    "status" TEXT NOT NULL CHECK("status" IN ('Active', 'Inactive', 'Under Review')),
    PRIMARY KEY("id"),
    FOREIGN KEY("risk_id") REFERENCES "risks"("id"),
    FOREIGN KEY("owner_id") REFERENCES "employees"("id")
);

-- Represent audit findings for internal controls
CREATE TABLE "audit_findings" (
    "id" INTEGER,
    "control_id" INTEGER NOT NULL,
    "auditor_id" INTEGER NOT NULL,
    "finding" TEXT NOT NULL,
    "severity" TEXT NOT NULL CHECK("severity" IN ('Low', 'Medium', 'High', 'Critical')),
    "status" TEXT NOT NULL CHECK("status" IN ('Open', 'Remediated', 'Accepted')),
    "audit_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id"),
    FOREIGN KEY("control_id") REFERENCES "controls"("id"),
    FOREIGN KEY("auditor_id") REFERENCES "employees"("id")
);

-- Risk history table
CREATE TABLE "risk_history" (
    "id" INTEGER PRIMARY KEY,
    "risk_id" INTEGER NOT NULL,
    "old_status" TEXT,
    "new_status" TEXT,
    "changed_at" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY("risk_id") REFERENCES "risks"("id")
);

-- Create a view showing each risk with its latest assessment and calculated score
CREATE VIEW "current_risk_register" AS
SELECT
    "risks"."id",
    "risks"."title",
    "risk_categories"."name" AS "category",
    "departments"."name" AS "department",
    "employees"."first_name" || ' ' || "employees"."last_name" AS "owner",
    "risks"."status",
    "risk_assessments"."likelihood",
    "risk_assessments"."impact",
    ("risk_assessments"."likelihood" * "risk_assessments"."impact") AS "risk_score",
    "risk_assessments"."assessment_date"
FROM "risks"
JOIN "risk_categories"
    ON "risks"."category_id" = "risk_categories"."id"
JOIN "employees"
    ON "risks"."owner_id" = "employees"."id"
JOIN "departments"
    ON "employees"."department_id" = "departments"."id"
JOIN "risk_assessments"
    ON "risks"."id" = "risk_assessments"."risk_id"
WHERE "risk_assessments"."assessment_date" = (
    SELECT MAX("latest"."assessment_date")
    FROM "risk_assessments" AS "latest"
    WHERE "latest"."risk_id" = "risks"."id"
);

-- Create a view showing open mitigation actions with risk and owner details
CREATE VIEW "open_action_summary" AS
SELECT
    "mitigation_actions"."id",
    "risks"."title" AS "risk",
    "mitigation_actions"."action",
    "employees"."first_name" || ' ' || "employees"."last_name" AS "owner",
    "mitigation_actions"."status",
    "mitigation_actions"."due_date",
    CASE
        WHEN "mitigation_actions"."due_date" < CURRENT_DATE THEN 'Overdue'
        ELSE 'On Track'
    END AS "timeline_status"
FROM "mitigation_actions"
JOIN "risks"
    ON "mitigation_actions"."risk_id" = "risks"."id"
JOIN "employees"
    ON "mitigation_actions"."owner_id" = "employees"."id"
WHERE "mitigation_actions"."status" IN ('Planned', 'In Progress');


-- Automatically close a risk when all mitigation actions are completed
CREATE TRIGGER "close_risk_when_actions_completed"
AFTER UPDATE OF "status" ON "mitigation_actions"
WHEN NEW."status" = 'Completed'
BEGIN
    UPDATE "risks"
    SET status = 'Closed'
    WHERE "id" = NEW."risk_id"
    AND NOT EXISTS (
        SELECT 1
        FROM "mitigation_actions"
        WHERE "risk_id" = NEW."risk_id"
        AND status IN ('Planned', 'In Progress')
    );
END;

-- Automatically record every risk status change
CREATE TRIGGER "risk_status_history"
AFTER UPDATE OF "status" ON "risks"
WHEN OLD."status" != NEW."status"
BEGIN
    INSERT INTO "risk_history" (
        "risk_id",
        "old_status",
        "new_status"
    )
    VALUES (
        OLD."id",
        OLD."status",
        NEW."status"
    );
END;

-- Escalate a risk when a critical audit finding is reported
CREATE TRIGGER "critical_finding_escalation"
AFTER INSERT ON "audit_findings"
WHEN NEW."severity" = 'Critical'
BEGIN
    UPDATE "risks"
    SET status = 'Under Review'
    WHERE "id" = (
        SELECT "risk_id"
        FROM "controls"
        WHERE "id" = NEW."control_id"
    );
END;

-- Create indexes to speed common searches
CREATE INDEX "risk_status_search" ON "risks"("status");
CREATE INDEX "risk_category_search" ON "risks"("category_id");
CREATE INDEX "risk_owner_search" ON "risks"("owner_id");
CREATE INDEX "assessment_risk_search" ON "risk_assessments"("risk_id");
CREATE INDEX "mitigation_due_date_search" ON "mitigation_actions"("due_date");
CREATE INDEX "mitigation_status_search" ON "mitigation_actions"("status");
CREATE INDEX "control_risk_search" ON "controls"("risk_id");
CREATE INDEX "audit_severity_search" ON "audit_findings"("severity");
CREATE INDEX "audit_status_search" ON "audit_findings"("status");
