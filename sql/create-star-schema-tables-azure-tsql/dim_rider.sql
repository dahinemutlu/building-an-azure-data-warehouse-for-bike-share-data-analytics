-- Create dim_rider table
CREATE EXTERNAL TABLE dbo.dim_rider WITH (
    LOCATION = 'dim-rider',
    DATA_SOURCE = [divvyadlsfs_divvyadls_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
select rider_id,
    "first" as first_name,
    "last" as last_name,
    address,
    birthday,
    account_start_date,
    account_end_date,
    datediff(year, birthday, account_start_date) as rider_age_at_signup,
    is_member
from [dbo].[staging_rider];