with

customers_source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

orders_source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed_customers as (

    select

        ----------  ids
        id as customer_id,

        ---------- properties
        name

    from customers_source

),

missing_customers as (

    -- Preserve referential integrity when the generated order data includes
    -- customer ids missing from the customer extract.
    select distinct
        customer as customer_id,
        'Missing Customer' as name
    from orders_source
    where customer is not null
      and customer not in (
          select customer_id
          from renamed_customers
      )

)

select * from renamed_customers
union all
select * from missing_customers
