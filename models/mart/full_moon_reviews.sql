{{ config(materialized="table") }}

with
    fact_reviews as (select * from {{ ref("fct_reviews") }}),
    full_moon_dates as (select * from {{ ref("full_moon_dates") }})
select
    r.*,
    case
        when f.full_moon_date is null then 'not_full_moon' else 'full_moon'
    end as is_full_moon
from fact_reviews r
left join
    full_moon_dates f on (to_date(r.review_date) = dateadd(day, 1, f.full_moon_date))
