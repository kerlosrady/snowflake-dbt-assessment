with li as (
  select
    L_ORDERKEY,
    L_EXTENDEDPRICE,
    L_DISCOUNT
  from {{ source('tpch', 'lineitem') }}
),

ord as (
  select O_ORDERKEY, O_CUSTKEY
  from {{ source('tpch', 'orders') }}
),

cust as (
  select C_CUSTKEY, C_NAME
  from {{ source('tpch', 'customer') }}
),

revenue_by_customer as (
  select
    o.O_CUSTKEY as customer_key,
    -- TPC-H revenue formula
    round(sum(li.L_EXTENDEDPRICE * (1 - li.L_DISCOUNT)), 2) as revenue_amount
  from li
  join ord o on li.L_ORDERKEY = o.O_ORDERKEY
  group by o.O_CUSTKEY
)

select
  c.C_CUSTKEY as customer_key,
  c.C_NAME    as customer_name,
  r.revenue_amount
from revenue_by_customer r
join cust c on c.C_CUSTKEY = r.customer_key
order by revenue_amount desc
