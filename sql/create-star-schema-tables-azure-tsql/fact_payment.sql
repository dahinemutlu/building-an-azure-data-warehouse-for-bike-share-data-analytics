-- Create fact_payment table
CREATE EXTERNAL TABLE dbo.fact_payment WITH (
    LOCATION = 'fact-payment',
    DATA_SOURCE = [divvyadlsfs_divvyadls_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
) AS
select payment_id,
    convert(date, date) as payment_date,
    amount,
    rider_id
from [dbo].[staging_payment];