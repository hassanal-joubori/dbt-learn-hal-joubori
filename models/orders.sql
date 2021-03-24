with orders as (
  select
    *
  from {{ ref('stg_orders') }}
),
successful_payments as (
  select
    order_id,
    sum(amount) as total_amount
  from 
    {{ ref('stg_payment') }}
  where
    status != 'fail'
  group by
    order_id
)
select
  user_id as customer_id,
  sp.order_id as order_id,
  total_amount as amount,
  o.order_date
from orders as o 
LEFT JOIN
  successful_payments sp
ON sp.order_id = o.id