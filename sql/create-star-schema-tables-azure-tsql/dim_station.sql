-- Create dim_station table
CREATE EXTERNAL TABLE dbo.dim_station WITH (
    LOCATION = 'dim-station',
    DATA_SOURCE = [divvyadlsfs_divvyadls_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
select station_id,
    "name",
    latitude,
    longitude
from [dbo].[staging_station];