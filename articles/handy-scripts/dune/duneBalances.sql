with

addresses_with_balances as (
    select address, token_address, balance_raw
    from (
        select *, row_number() over (partition by token_address order by block_number desc) as _rn
        from tokens_ethereum.balances
        where (
            balance > 0
            and blockchain = 'ethereum'
            and address in ({{addresses}})
        )
    )
    where _rn = 1
),

traces_counts as (
    select "to" as address, count(*) as trace_count, max(block_time) as latest_trace_date
    from ethereum.traces
    where "to" in (select address from addresses_with_balances group by address)
    group by "to"
)

select address, trace_count, latest_trace_date
from traces_counts
order by latest_trace_date desc