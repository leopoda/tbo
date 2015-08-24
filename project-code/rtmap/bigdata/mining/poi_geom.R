exp_poi_geom <- function (host, db, user, passwd, expfile)
{
    library(RMySQL)
    conn <- dbConnect(RMySQL::MySQL(), host = host, dbname = db, user = user, password = passwd)
    # conn <- dbConnect(RMySQL::MySQL(), host = '218.106.254.30', dbname = 'xunlu', user = 'root', password = 'wx101229')
    # summary(conn)
    # dbGetInfo(conn)
    # dbListTables(conn)
  
    res <- dbGetQuery(conn, "SET NAMES utf8")
  
    sql <- "
select distinct name_chinese as poi_name, 
       poi_no,
       floor,
       x_coord x,
       y_coord y,
       replace(replace(replace(convert(astext(the_geom) using ascii), 'MULTIPOLYGON(((', ''), ')))', ''), ' ', ':') as geom
from poi_basic_2
where id_build = '860100010020300001' and 
      (name_chinese is not null and name_chinese <> '') and 
      (floor is not null and floor <> '')
order by id_poi"
  
    # (sql)
    res <- dbGetQuery(conn, sql)
    # warnings()
    # head(res)
  
    # write.table(res, file='./poi_data.csv', sep='\t', row.names = FALSE, quote = FALSE)
    write.table(res, file = expfile, sep='\t', row.names = FALSE, quote = FALSE, append = FALSE, col.names = FALSE)
    dbDisconnect(conn)
}

load_poi_geom <- function (src, buildId, location)
{
    library(RHive)
    rhive.init()
    rhive.connect(host = 'datanode1', hiveServer2 = TRUE, db = 'mining')

    dml <- sprintf("alter table poi_geom add if not exists partition (build_id='%s') location '%s/%s'", buildId, location, buildId)
    (dml)
    res <- rhive.execute(dml)
    rhive.close()

    # res <- read.table(file = src, sep = '\t', header = TRUE)
    # head(res)
    # message('len=',class(res))

    # poi_id <- c(1:length(res$poi_no))
    # res2 <- cbind(poi_id, res)
    
    library(rhdfs)
    hdfs.init()

    dest <- as.character(paste(location, '/', buildId, sep = ''))
    message(src)
    message(dest)
    hdfs.put(src, dest)
    # hdfs.close()
}

expfile <- '/home/r/mining/poi_data.csv'
buildId <- '860100010020300001'
location <- '/mining/poi_geom'

exp_poi_geom('218.106.254.30', 'xunlu', 'root', 'wx101229', expfile)
load_poi_geom(src = expfile, buildId, location)
