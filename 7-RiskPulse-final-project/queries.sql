-- Find all open risks with their category, department, and owner
SELECT
    "risks"."id",
    "risks"."title",
    "risk_categories"."name" AS "category",
    "departments"."name" AS "department",
    "employees"."first_name" || ' ' || "employees"."last_name" AS "owner",
    "risks"."status"
FROM "risks"
JOIN "risk_categories"
    ON "risks"."category_id" = "risk_categories"."id"
JOIN "employees"
    ON "risks"."owner_id" = "employees"."id"
JOIN "departments"
    ON "employees"."department_id" = "departments"."id"
WHERE "risks"."status" != 'Closed'
ORDER BY "risks"."created_at" DESC;


-- Find the latest assessment for each risk, including calculated risk score
SELECT
    "risks"."id",
    "risks"."title",
    "risk_assessments"."likelihood",
    "risk_assessments"."impact",
    ("risk_assessments"."likelihood" * "risk_assessments"."impact") AS "risk_score",
    "risk_assessments"."assessment_date"
FROM "risks"
JOIN "risk_assessments"
    ON "risks"."id" = "risk_assessments"."risk_id"
WHERE "risk_assessments"."assessment_date" = (
    SELECT MAX("latest"."assessment_date")
    FROM "risk_assessments" AS "latest"
    WHERE "latest"."risk_id" = "risks"."id"
)
ORDER BY "risk_score" DESC;


-- Find top 10 highest-scoring risks based on their latest assessment
SELECT
    "risks"."title",
    "risk_categories"."name" AS "category",
    "departments"."name" AS "department",
    "risk_assessments"."likelihood",
    "risk_assessments"."impact",
    ("risk_assessments"."likelihood" * "risk_assessments"."impact") AS "risk_score"
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
)
ORDER BY "risk_score" DESC
LIMIT 10;


-- Find mitigation actions that are overdue and not completed
SELECT
    "mitigation_actions"."id",
    "risks"."title" AS "risk",
    "mitigation_actions"."action",
    "employees"."first_name" || ' ' || "employees"."last_name" AS "owner",
    "mitigation_actions"."due_date",
    "mitigation_actions"."status"
FROM "mitigation_actions"
JOIN "risks"
    ON "mitigation_actions"."risk_id" = "risks"."id"
JOIN "employees"
    ON "mitigation_actions"."owner_id" = "employees"."id"
WHERE "mitigation_actions"."due_date" < CURRENT_DATE
    AND "mitigation_actions"."status" IN ('Planned', 'In Progress')
ORDER BY "mitigation_actions"."due_date";


-- Count open risks by department
SELECT
    "departments"."name" AS "department",
    COUNT(*) AS "open_risks"
FROM "risks"
JOIN "employees"
    ON "risks"."owner_id" = "employees"."id"
JOIN "departments"
    ON "employees"."department_id" = "departments"."id"
WHERE "risks"."status" != 'Closed'
GROUP BY "departments"."id", "departments"."name"
ORDER BY "open_risks" DESC;


-- Find all critical or high audit findings that are still open
SELECT
    "audit_findings"."id",
    "controls"."name" AS "control",
    "risks"."title" AS "risk",
    "audit_findings"."severity",
    "audit_findings"."status",
    "audit_findings"."audit_date"
FROM "audit_findings"
JOIN "controls"
    ON "audit_findings"."control_id" = "controls"."id"
JOIN "risks"
    ON "controls"."risk_id" = "risks"."id"
WHERE "audit_findings"."severity" IN ('High', 'Critical')
    AND "audit_findings"."status" = 'Open'
ORDER BY
    CASE "audit_findings"."severity"
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
    END,
    "audit_findings"."audit_date";


-- Find highest-scoring risks using the current risk register view
SELECT *
FROM "current_risk_register"
ORDER BY "risk_score" DESC
LIMIT 10;


-- Find overdue mitigation actions using the open action summary view
SELECT *
FROM "open_action_summary"
WHERE "timeline_status" = 'Overdue'
ORDER BY "due_date";


-- Add a new department
INSERT INTO "departments" ("name", "description")
VALUES ('Risk Management', 'Responsible for enterprise risk governance and oversight.');


-- Add a new employee
INSERT INTO "employees" (
    "first_name",
    "last_name",
    "email",
    "role",
    "department_id"
)
VALUES (
    'Anna',
    'Smith',
    'anna.smith@example.com',
    'Risk Manager',
    1
);


-- Add a new risk category
INSERT INTO "risk_categories" ("name", "description")
VALUES (
    'Cybersecurity',
    'Risks related to cyber attacks, data breaches, and information security.'
);


-- Add a new operational risk
INSERT INTO "risks" (
    "title",
    "description",
    "category_id",
    "owner_id",
    "status"
)
VALUES (
    'Ransomware attack on reporting systems',
    'Potential disruption of internal reporting systems caused by ransomware.',
    1,
    1,
    'Open'
);


-- Add a new risk assessment
INSERT INTO "risk_assessments" (
    "risk_id",
    "likelihood",
    "impact",
    "assessed_by"
)
VALUES (
    1,
    4,
    5,
    1
);


-- Add a mitigation action for a risk
INSERT INTO "mitigation_actions" (
    "risk_id",
    "owner_id",
    "action",
    "status",
    "due_date"
)
VALUES (
    1,
    1,
    'Implement multi-factor authentication for reporting systems.',
    'In Progress',
    '2026-06-30'
);


-- Add a control linked to a risk
INSERT INTO "controls" (
    "risk_id",
    "owner_id",
    "name",
    "description",
    "frequency",
    "status"
)
VALUES (
    1,
    1,
    'User access review',
    'Quarterly review of user access rights for reporting systems.',
    'Quarterly',
    'Active'
);


-- Add an audit finding for a control
INSERT INTO "audit_findings" (
    "control_id",
    "auditor_id",
    "finding",
    "severity",
    "status"
)
VALUES (
    1,
    1,
    'Some inactive users still had access to reporting systems.',
    'High',
    'Open'
);


-- Complete a mitigation action; if all active actions are completed, the related risk is closed automatically
UPDATE "mitigation_actions"
SET
    "status" = 'Completed',
    "completed_at" = CURRENT_TIMESTAMP
WHERE "id" = 1;


-- Close a risk after mitigation and review
UPDATE "risks"
SET "status" = 'Closed'
WHERE "id" = 1;


-- View the audit trail of risk status changes recorded by the trigger
SELECT *
FROM "risk_history"
ORDER BY "changed_at" DESC;


-- Delete an audit finding entered by mistake
DELETE FROM "audit_findings"
WHERE "id" = 1;
