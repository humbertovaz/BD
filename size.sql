SELECT table_schema 'DB Name',
SUM(data_length + index_length) / 1024
'DB Size in KB'
FROM information_schema.tables
WHERE table_schema = 'Jonas Discos';