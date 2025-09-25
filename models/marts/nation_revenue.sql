with line_items as (
    select
        l_orderkey,
        l_extendedprice,
        l_discount
    from {{ source('tpch', 'lineitem') }}
),

orders as (
    select
        o_orderkey,
        o_custkey,
        o_orderdate
    from {{ source('tpch', 'orders') }}
),

customers as (
    select
        c_custkey,
        c_name,
        c_nationkey
    from {{ source('tpch', 'customer') }}
),

nations as (
    select
        n_nationkey,
        n_name as nation_name
    from {{ source('tpch', 'nation') }}
),

revenue_per_order as (
    select
        o.o_custkey as customer_key,
        sum(li.l_extendedprice * (1 - li.l_discount)) as order_revenue
    from orders o
    join line_items li on li.l_orderkey = o.o_orderkey
    group by o.o_custkey
)

select
    n.nation_name,
    count(distinct c.c_custkey) as num_customers,
    sum(r.order_revenue) as total_revenue
from revenue_per_order r
join customers c on c.c_custkey = r.customer_key
join nations n on n.n_nationkey = c.c_nationkey
group by n.nation_name
order by total_revenue desc