source('rlib/add_part.R')
source('rlib/load_table.R')

res1 <- add_partition(dt1='20150329', dt2='20150410',server = 'datanode1',table_name='sck')
res2 <- load_table(dt1='20150329', dt2='20150410', table_name='sck', local_path = '/home/r/airport/data', hdfs_path = '/airport/t3c/queue')
