add_partition <- function(dt1, dt2, server, db='queue', table_name)
{
    library(lubridate)
    library(RHive)
    rhive.init()

    # date range
    dates <- seq.int(ymd(dt1), ymd(dt2), by='1 day')
    dates <- as.character(dates)
    
    # yyyy-mm-dd to yyyymmdd
    dates <- gsub('-', '', dates)

    str <- "alter table %s add if not exists partition (data_date='%s',data_src='E') location '%s/%s/E'"
    hdfs_path <- sprintf("/airport/t3c/queue/%s", table_name)

    cmd <- sprintf(str, table_name, dates, hdfs_path, dates)
    cmds <- as.data.frame(cmd, stringsAsFactors = FALSE)



    rhive.connect(server, port = 10000, hiveServer2 = TRUE, db = db)
    result <- with(
                  cmds,
                  Map(
                      rhive.execute,
                      cmd
                  )
              )

    rhive.close()

    names(result) <- c()
    result <- t(result)

    result <- as.data.frame(result, stringsAsFactors = FALSE)
    names(result) <- "return"

    result <- cbind(dates, result$return)
    result <- as.data.frame(result, stringsAsFactors = FALSE)

    (result)
}
