with

traces_counts as (
    select "to" as address, count(*) as trace_count, max(block_time) as latest_trace_date
    from ethereum.traces
    where "to" in ({{addresses}})
    group by "to"
)

select address, trace_count, latest_trace_date
from traces_counts
order by latest_trace_date desc