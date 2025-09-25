with orders as (
  select
    O_ORDERKEY,
    O_CUSTKEY,
    O_ORDERSTATUS,
    O_TOTALPRICE,
    O_ORDERDATE,
    O_ORDERPRIORITY,
    O_CLERK,
    O_SHIPPRIORITY,
    O_COMMENT
  from {{ source('tpch', 'orders') }}
),
customers as (
  select
    C_CUSTKEY,
    C_NAME,
    C_NATIONKEY
  from {{ source('tpch', 'customer') }}
)

select
  o.O_ORDERKEY      as order_key,
  o.O_CUSTKEY       as customer_key,
  c.C_NAME          as customer_name,
  o.O_ORDERSTATUS   as order_status,
  o.O_TOTALPRICE    as total_price,
  o.O_ORDERDATE     as order_date,
  extract(year from o.O_ORDERDATE) as order_year,
  o.O_ORDERPRIORITY,
  o.O_CLERK,
  o.O_SHIPPRIORITY,
  o.O_COMMENT
from orders o
left join customers c
  on o.O_CUSTKEY = c.C_CUSTKEY
