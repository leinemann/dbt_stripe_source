{{ config(enabled=var('using_subscriptions', True)) }}

select *
from {{ var('subscription') }}