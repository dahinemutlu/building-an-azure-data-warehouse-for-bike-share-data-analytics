-- Create fact_trip table
CREATE EXTERNAL TABLE dbo.fact_trip WITH (
    LOCATION = 'fact-trip',
    DATA_SOURCE = [divvyadlsfs_divvyadls_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
select a.trip_id,
    convert(date, a.start_at) as trip_date,
    a.rider_id,
    a.rideable_type,
    a.start_at,
    a.ended_at,
    datediff(minute, start_at, ended_at) as time_spent_minutes,
    a.start_station_id,
    a.end_station_id,
    datediff(year, b.birthday, a.start_at) as rider_age_at_trip
from [dbo].[staging_trip] a,
    [dbo].[staging_rider] b
where a.rider_id = b.rider_id;