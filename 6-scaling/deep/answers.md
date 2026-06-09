# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

Random partitioning helps distribute observations evenly across boats, preventing one boat from becoming overloaded during peak observation periods.
However, querying specific time ranges becomes more difficult because observations are scattered randomly, requiring queries to run on all boats and results to be combined. There might be harder backups, debugging, scaling queries and aggregation requires collecting data from multiple nodes.

## Partitioning by Hour

Partitioning by hour makes time-based queries more efficient because researchers can search only the boats responsible for the relevant time range instead of querying every boat. However, this approach may distribute data unevenly if observations are concentrated during certain hours, causing one boat to store and process much more data than others. Queries spanning multiple time ranges may also require accessing more than one boat.

## Partitioning by Hash Value

Hash partitioning distributes observations evenly across boats and prevents one boat from becoming overloaded during periods of high observation activity. However, time-based queries become less efficient because observations from the same time range may be stored on different boats, requiring queries to run on all boats. Exact lookups remain efficient because the hash value of a known timestamp can be computed to determine which boat stores the observation.
