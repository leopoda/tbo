load_table <- function(dt1, dt2, table_name, local_path, hdfs_path)
{    
    library(reshape2)
    library(lubridate)
    library(rhdfs)
    hdfs.init()

    # date range
    dates <- seq.int(ymd(dt1), ymd(dt2), by='1 day')
    dates <- as.character(dates)

    # yyyy-mm-dd to yyyymmdd
    dates <- gsub('-', '', dates)

    # load files to hdfs
    src <- sprintf("%s/%s/%s-%s.txt", local_path, table_name, table_name, dates)
    src <- as.data.frame(src, stringsAsFactors = FALSE)

    dst <- sprintf("%s/%s/%s/%s", hdfs_path, table_name, dates, 'E')
    dst <- as.data.frame(dst, stringsAsFactors = FALSE)
    
    rows <- cbind(src, dst)
    result <- with(
                  rows,
                  Map(
                      hdfs.put,
                      src,
                      dst
                  )
              )

    result <- melt(result)
    names(result) <- c("result", "file")
    result <- result[sort(names(result))]

    (result)
}

