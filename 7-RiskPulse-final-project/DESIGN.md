# RiskPulse – Operational Risk Management Database

By Peter Sopkuliak

Video overview: <[URL HERE](https://www.youtube.com/watch?v=kvqD3iPnS2M)>

## Scope

### Purpose

RiskPulse is a relational database designed to support operational risk management processes within an organization. The database enables organizations to identify risks, assess their severity, assign mitigation actions, manage internal controls, and track audit findings throughout the risk lifecycle.

The project was inspired by enterprise risk management practices commonly used in large international organizations and financial institutions, where risk ownership, governance, compliance, and auditability are critical business requirements.

### Included in Scope

The database models the core entities involved in operational risk management:

* Organizational departments
* Employees responsible for risk management activities
* Risk categories
* Individual risks
* Risk assessments
* Mitigation actions
* Internal controls
* Audit findings

The database is designed to support both operational activities and management reporting.

### Outside the Scope

The following areas are intentionally excluded from the database design:

* Insurance contracts and policies
* Claims management
* Actuarial calculations
* Financial accounting and general ledger processes
* Regulatory capital calculations
* User authentication and authorization
* Document management systems

These domains could be integrated in future versions but are beyond the scope of this project.

---

## Functional Requirements

### Supported Functionality

A user of the database should be able to:

* Create and maintain departments and employees
* Register new operational risks
* Classify risks into predefined categories
* Assign ownership of risks
* Record multiple risk assessments over time
* Track mitigation actions and their completion status
* Define internal controls used to mitigate risks
* Record audit findings related to controls
* Produce management reports using views and analytical queries
* Identify overdue actions and high-risk areas

The database supports both operational record keeping and management reporting.

### Out of Scope Functionality

The database is not intended to:

* Automatically calculate financial losses
* Predict future risks using machine learning
* Manage regulatory submissions
* Execute workflow approvals
* Send notifications or reminders
* Replace dedicated Governance, Risk and Compliance (GRC) software platforms

---

## Representation

### Entities

The database consists of eight primary business entities and one supporting audit entity.

#### Departments

Departments represent organizational units responsible for business operations and risk ownership.

**Attributes:**

* id
* name
* description

A unique constraint on department names prevents duplicate departments from being created.

#### Employees

Employees represent individuals responsible for risks, controls, mitigation actions, and audits.

**Attributes:**

* id
* first_name
* last_name
* email
* role
* department_id

Email addresses are constrained to be unique because they uniquely identify an employee.

#### Risk Categories

Risk categories provide a standardized classification system for risks.

Examples include:

* Cybersecurity
* Operational
* Regulatory
* Financial
* Supplier
* ESG
* Health and Safety
* Business Continuity

**Attributes:**

* id
* name
* description

A separate lookup table was chosen instead of hard-coded values to allow future expansion without schema modifications.

#### Risks

Risks represent identified threats or events that may negatively affect business operations.

**Attributes:**

* id
* title
* description
* category_id
* owner_id
* status
* created_at

Status values are constrained using CHECK constraints to enforce valid lifecycle states.

#### Risk Assessments

Risk assessments record evaluations of risks over time.

**Attributes:**

* id
* risk_id
* likelihood
* impact
* assessment_date
* assessed_by

Likelihood and impact use a standardized 1–5 scoring scale enforced by CHECK constraints.

Historical assessments are preserved instead of overwritten, allowing trend analysis and auditability.

#### Mitigation Actions

Mitigation actions represent tasks intended to reduce risk exposure.

**Attributes:**

* id
* risk_id
* owner_id
* action
* status
* due_date
* completed_at

Status values are constrained to ensure consistent reporting.

#### Controls

Controls represent business processes or activities designed to mitigate risks.

**Attributes:**

* id
* risk_id
* owner_id
* name
* description
* frequency
* status

Control frequencies are constrained to predefined values to standardize reporting and compliance monitoring.

#### Audit Findings

Audit findings record observations identified during reviews of controls.

**Attributes:**

* id
* control_id
* auditor_id
* finding
* severity
* status
* audit_date

Severity and status fields use CHECK constraints to enforce data consistency.

### Design Decisions

Several design decisions were made to improve normalization and maintainability.

Risk ownership is assigned directly to employees. Department ownership is derived through the employee relationship rather than being stored separately within the risk table. This reduces redundancy and prevents inconsistent data.

Risk assessments are stored historically rather than updated in place. This enables the organization to track changes in risk exposure over time and supports future trend analysis.

Triggers were also implemented to automate selected business rules. These triggers help maintain data consistency, reduce manual work, and improve auditability.

A dedicated risk_history table was introduced to support auditability and preserve a record of all risk status changes.

One trigger automatically closes a risk when all active mitigation actions have been completed. Another trigger records all risk status changes in a dedicated history table, creating an audit trail of important risk lifecycle events. A third trigger escalates risks to "Under Review" when a critical audit finding is reported.

Lookup tables were used for risk categories to allow business taxonomies to evolve without requiring schema changes.

### Relationships

The database follows a normalized relational design.

Key relationships include:

* One department can contain many employees.
* One employee can own many risks.
* One risk category can classify many risks.
* One risk can have many assessments.
* One risk can have many mitigation actions.
* One risk can have many controls.
* One control can generate many audit findings.

The complete entity relationship diagram is shown below.

![RiskPulse ER Diagram](diagram.gif)

The design follows a normalized relational model.

Departments contain employees.

Employees may own risks, controls, mitigation actions, and perform risk assessments or audits.

Risks are categorized through a dedicated lookup table and may have multiple assessments, controls, and mitigation actions throughout their lifecycle.

Audit findings are linked to controls, providing traceability between identified issues and the controls designed to mitigate risk.

---

## Optimizations

Several optimizations were implemented to improve query performance.

### Views

Two reporting views were created.

#### current_risk_register

Provides a consolidated risk register showing:

* Risk information
* Risk owner
* Department
* Latest assessment
* Calculated risk score

This view simplifies management reporting and dashboard creation.

#### open_action_summary

Provides visibility into open mitigation activities and highlights overdue actions.

### Triggers

Three triggers were implemented to automate business rules, improve data integrity, and enhance auditability.

#### close_risk_when_actions_completed

Automatically closes a risk when all active mitigation actions have been completed.

#### risk_status_history

Automatically records all risk status changes in a dedicated history table, providing a complete audit trail and improving traceability.

#### critical_finding_escalation

Automatically changes a risk status to "Under Review" when a critical audit finding is recorded, ensuring that severe findings receive immediate attention.

### Indexes

Indexes were created on frequently queried columns:

* Risk status
* Risk category
* Risk owner
* Assessment risk identifier
* Mitigation due dates
* Mitigation status
* Control risk identifier
* Audit severity
* Audit status

These indexes improve performance for operational reporting and analytical queries.

---

## Limitations

While the database supports core operational risk management activities, several limitations remain.

The database does not currently model:

* Risk appetite frameworks
* Key Risk Indicators (KRIs)
* Incident management
* Regulatory obligations
* Financial loss events
* Workflow approvals
* Evidence and document repositories

The design assumes that each risk has a single owner. Organizations that require shared ownership or matrix reporting structures may require additional relationship tables.

The implemented triggers support several business rules, but more advanced workflow automation, approval chains, and notification mechanisms are outside the scope of the current design.

Additionally, the database focuses on operational risk management and is not intended to represent broader enterprise architecture, insurance products, claims handling, or actuarial processes.

---

## Future Improvements

Potential future enhancements include:

* Risk appetite frameworks and thresholds
* Risk heat maps
* Incident management workflows
* Regulatory framework mapping
* Automated notifications
* Dashboard integration with Power BI
* Historical trend analysis
* Risk scoring automation
* External audit management
* Integration with enterprise GRC platforms

These enhancements would move the database closer to a production-grade enterprise risk management solution.
