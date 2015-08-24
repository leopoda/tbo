library(reshape2)

txtfile <- '~/mining/data/src/joycity-trade-card-05~06.txt'
res <- read.table(file = txtfile, sep = '\t', header = FALSE, skip = 1, col.names = FALSE, quote = '', stringsAsFactors = FALSE)
# res <- head(res)

# head(res)

# class(res)
names(res) <- 'txt'
# substr(res$txt, 1, 6)
# substr(res$txt, 8, 36)
# substr(res$txt, 37, 38)
# substr(res$txt, 40, 49)
# str(res)

res <- gsub('\\s\\s\\s*', '\t', res$txt)
res2 <- strsplit(res, split = '\t')
# str(res2)
# names(res2)
# class(res2)

# res3 <- as.data.frame(res2)

# names(res2)
res4 <- unlist(res2)

# res4
len <- length(res4)

c1 <- seq.int(1, len, by = 4)
c2 <- seq.int(2, len, by = 4)
c3 <- seq.int(3, len, by = 4)
c4 <- seq.int(4, len, by = 4)

col1 <- melt(res4[c1])
col2 <- melt(res4[c2])
col3 <- melt(res4[c3])
col4 <- melt(res4[c4])

rows <- cbind(col1, col2, col3, col4)
names(rows) <- c('t1', 't2', 't3', 't4')
# rows

# melt(substr(rows$t1, 1, 6))
# melt(substr(rows$t1, 8, 255))
# melt(substr(as.character(rows$t2), 1, 2))
# melt(substr(as.character(rows$t2), 4, 13))
# melt(substr(as.character(rows$t2), 15, 18))
# melt(substr(as.character(rows$t2), 20, 255))
# melt(rows$t3)
# melt(rows$t4)

result <- data.frame(melt(substr(rows$t1, 1, 6)),
                     melt(substr(rows$t1, 8, 255)),
                     melt(substr(as.character(rows$t2), 1, 2)),
                     melt(gsub('-', '' , substr(as.character(rows$t2), 4, 13))), ## yyyymmdd
                     melt(substr(as.character(rows$t2), 15, 18)), ## hhmm
                     melt(substr(as.character(rows$t2), 20, 255)),
                     melt(rows$t3),
                     melt(rows$t4),
                     stringsAsFactors = FALSE)

names(result) <- c('store_id', 'brand_name', 'desk', 'trade_date', 'trade_time', 'ticket', 'account', 'amount')
catalog <- levels(result$trade_date)

# catalog <- melt(catalog)
# names(catalog) <- 'date'
# names(catalog)

# str <- sprintf('trade-%s.txt', catalog[1])
# res5 <- subset(result, 
#        trade_date == catalog[1], 
#        c(
#          store_id, 
#          brand_name,
#          desk,
#          trade_time,
#          ticket,
#          account,
#          amount))
# 
# 
# write.table(file = 'abc.txt', result, quote = FALSE, col.names = FALSE, row.names = FALSE, sep = '\t')


format_trade <- function (result, date, filePath)
{
    # fileName <- sprintf('~/mining/trade-%s.txt', date)
    fileName <- sprintf('%s/trade-%s.txt', filePath, date)
    res <-  subset(result, 
                   as.character(trade_date) == date, 
                   c(store_id, 
                     brand_name,
                     desk,
                     # trade_date,
                     trade_time,
                     ticket,
                     account,
                     amount)
                  )
    write.table(file = fileName, res, quote = FALSE, col.names = FALSE, row.names = FALSE, sep = '\t')
    return (fileName)
}


# format_trade(result, catalog[1], '~/mining/data/card')

# names(result)
# 
# with (
#     result,
#     Map (
#       format_trade,
#       names(result),
#       catalog$date,
#       '~/mining/data/card'
#     )
#   
# )

add_hdfs_path <- function (building, date, path_prefix, local_file)
{
    library(rhdfs)
    hdfs.init()
    
    # sprintf('/mining/trade/860100010020300001/20150501/card')
    dest <- sprintf('%s/%s/%s/card', path_prefix, building, date)
    
    # message(dest)
    if (!hdfs.exists(dest))
    {
        hdfs.mkdir(dest)
    }
    hdfs.put(local_file, dest)
}

add_part <- function (server, port, db, building, date, path_prefix)
{
    library(RHive)
    rhive.init()
    rhive.connect(host = server, port = port, db = db, hiveServer2 = TRUE)
    
    location <- sprintf('%s/%s/%s/card', path_prefix, building, date)
    dml <- "alter table trade add if not exists partition (build_id='%s',trade_date='%s',trade_type='card') location '%s'"

    dml <- sprintf(dml, building, date, location)
    message('debug: dml: ', dml)

    rhive.execute(dml)
    rhive.close()
}

### main entry
len <- length(catalog)
for (i in 1:len)
{
    server <- 'datanode1'
    port <- 10000
    db <- 'mining'
    path_prefix <- '/mining/trade'
    build <- '860100010020300001'
    date <- catalog[i]
    
    # message(catalog[i])
    local_path <- '/home/r/mining/data/target/trade/joycity/card'
    fileName <- format_trade(result, date, local_path)
    
    # message('debug1:',fileName)
    add_hdfs_path(build, date, path_prefix, fileName)
    add_part(server, port, db, build, date, path_prefix)
}
