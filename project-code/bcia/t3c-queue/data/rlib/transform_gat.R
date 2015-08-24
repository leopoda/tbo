change.gat.col.order <- function(src, dst)
{
    gat <- read.table(src, sep='\t', stringsAsFactors = FALSE, strip.white = TRUE, na.strings = '')
    headers <- c('gat_id', 'psg_id', 'flt_id', 'gat_first_scan_tm', 'gat_last_scan_tm', 'gat_scan_no', 'gat_name', 'gat_ship', 'gat_error_code', 'data_date', 'data_src')

    names(gat) <- headers
    neworder <- c('gat_id', 'psg_id', 'flt_id', 'gat_first_scan_tm', 'gat_last_scan_tm', 'gat_scan_no', 'gat_name', 'gat_ship', 'gat_error_code', 'data_src', 'data_date')

    # head(gat[neworder])
    write.table(gat[neworder], file = dst, sep='\t', row.names = FALSE, col.names = FALSE, quote = FALSE, na = '')
}

transform_gat <- function(dt1, dt2, local_path, dest_path)
{
    library(lubridate)

    # date range
    dates <- seq.int(ymd(dt1), ymd(dt2), by='1 day')
    dates <- as.character(dates)

    # yyyy-mm-dd to yyyymmdd
    dates <- gsub('-', '', dates)

    # load files to hdfs
    txt <- sprintf("%s/gat-%s.txt", local_path, dates)
    src <- as.data.frame(txt, stringsAsFactors = FALSE)

    txt <- sprintf("%s/gat-%s.txt", dest_path, dates)
    dst <- as.data.frame(txt, stringsAsFactors = FALSE)

    rows <- cbind(src, dst)

    names(rows) <- c("src", "dst")
    # (rows)
    with(
        rows,
        Map(
            change.gat.col.order,
            src,
            dst
        )
    )
}

# transform_gat('20150329', '20150410', '/home/r/airport/data/gat', '/home/r/airport/data/gat-new')
