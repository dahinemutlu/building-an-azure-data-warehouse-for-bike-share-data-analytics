-- Create dim_date table
CREATE EXTERNAL TABLE dbo.dim_date WITH (
    LOCATION = 'dim-date',
    DATA_SOURCE = [divvyadlsfs_divvyadls_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
select distinct convert(date, date) as date,
    year(date) as year,
    datepart(quarter, date) as quarter,
    month(date) as month,
    day(date) as day,
    datepart(week, date) as week,
    case
        when datepart(weekday, date) in (6, 7) then cast(1 as bit)
        else cast(0 as bit)
    end as is_weekend
from [dbo].[staging_payment]
union
select distinct convert(date, start_at) as date,
    year(start_at) as year,
    datepart(quarter, start_at) as quarter,
    month(start_at) as month,
    day(start_at) as day,
    datepart(week, date) as week,
    case
        when datepart(weekday, start_at) in (6, 7) then cast(1 as bit)
        else cast(0 as bit)
    end as is_weekend
from [dbo].[staging_trip];