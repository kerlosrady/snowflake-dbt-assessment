# Snowflake + dbt Assessment (TPCH Demo)

This repository contains my solution to the **Data Engineer Assessment** using dbt and Snowflake.
The project demonstrates how to set up a dbt project on Snowflake, model data using a medallion-style architecture, and apply tests and documentation for data quality and lineage.

---

## ⚙️ Setup Instructions

### Snowflake

1. Created a free trial Snowflake account (Enterprise edition, `ACCOUNTADMIN` role).
2. Created a virtual warehouse `DEV_WH` with auto-suspend:

   ```sql
   CREATE WAREHOUSE DEV_WH 
     WAREHOUSE_SIZE = XSMALL 
     AUTO_SUSPEND = 60 
     AUTO_RESUME = TRUE;
   ```
3. Verified that the shared database `SNOWFLAKE_SAMPLE_DATA` was available.
4. Cloned relevant TPCH tables into a writable demo database:

   ```sql
   CREATE DATABASE SNOWFLAKE_SAMPLE_DATA_DEMO;
   CREATE SCHEMA SNOWFLAKE_SAMPLE_DATA_DEMO.TPCH_SF1;

   CREATE OR REPLACE TABLE SNOWFLAKE_SAMPLE_DATA_DEMO.TPCH_SF1.CUSTOMER CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
   CREATE OR REPLACE TABLE SNOWFLAKE_SAMPLE_DATA_DEMO.TPCH_SF1.ORDERS   CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS;
   CREATE OR REPLACE TABLE SNOWFLAKE_SAMPLE_DATA_DEMO.TPCH_SF1.LINEITEM CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;
   CREATE OR REPLACE TABLE SNOWFLAKE_SAMPLE_DATA_DEMO.TPCH_SF1.NATION   CLONE SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION;
   ```

### dbt

* Initialized a new dbt Cloud project: **`snowflake_tpch_demo`**.
* Configured connection to Snowflake (`DEV_WH`, demo database, schema).
* Linked the project to a GitHub repository.

---

## 🗂 Project Structure

```
models/
├── staging/
│   ├── stg_orders.sql
│   └── schema.yml
└── marts/
    ├── customer_revenue.sql
    ├── nation_revenue.sql
    └── schema.yml
```

* **Sources**: `customer`, `orders`, `lineitem`, `nation` from TPCH.
* **Staging (Silver layer)**:

  * `stg_orders` → cleansed version of orders joined with customer; adds `order_year` and keeps `total_price`.
* **Marts (Gold layer)**:

  * `customer_revenue` → revenue aggregated per customer.
  * `nation_revenue` → revenue aggregated per nation.

---

## ✅ Tests

Data quality tests defined in `schema.yml`:

* `stg_orders.o_orderkey` → `unique`, `not_null`.
* `stg_orders.customer_key` → `relationships` test with `customer.c_custkey`.
* `customer_revenue.customer_key` → `not_null`.
* `nation_revenue.nation_name` → `not_null`.

Run:

```bash
dbt test
```

---

## 📖 Documentation

* Added descriptions for sources, models, and columns in `schema.yml`.
* Generated docs with:

  ```bash
  dbt docs generate
  ```
* In dbt Cloud, docs and lineage are available via the **View Docs** button.

---

## 🔁 Version Control

* Project tracked in Git with meaningful commits:

  * Initial setup + core models (`stg_orders`, `customer_revenue`).
  * Added `nation_revenue` and extended sources.
* Repository: [snowflake-dbt-assessment](https://github.com/<your-username>/snowflake-dbt-assessment)

---

## 🏆 Bonus Enhancements

* Added an extra model (`nation_revenue`).
* Applied multiple dbt tests (`unique`, `not_null`, `relationships`).
* Extended documentation for models and sources.

---

## ▶️ How to Run

1. Clone the repository:

   ```bash
   git clone https://github.com/<your-username>/snowflake-dbt-assessment.git
   cd snowflake-dbt-assessment
   ```
2. Configure Snowflake credentials in dbt (profile or dbt Cloud).
3. Run models:

   ```bash
   dbt run
   ```
4. Run tests:

   ```bash
   dbt test
   ```
5. Build everything (models + tests):

   ```bash
   dbt build
   ```
6. Generate documentation:

   ```bash
   dbt docs generate
   ```

---

## 📌 Assumptions

* TPCH clone (`SNOWFLAKE_SAMPLE_DATA_DEMO`) is sufficient for this exercise.
* Revenue is calculated as `l_extendedprice * (1 - l_discount)`.
* Gold models are materialized as **tables** for performance; staging models as **views** for flexibility.

---

## 👤 Author

**Kerlos Rady**

Data & Automation Engineer

--------------------------
