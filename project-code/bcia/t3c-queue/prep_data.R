prepData <- function(hiveServer, port, date)
{
    library(RHive)
    library(SDMTools)

    rhive.init()
    rhive.connect(hiveServer, port, hiveServer2=TRUE)

    sql <- sprintf("select tm_win, duration from queue.pred_sec where data_date = '%s' and data_src = 'E'", date)
    sckData <- rhive.query(sql)

    sql <- sprintf("
select bt as bt,
       duration,
       cnt,
       dt
from (
    select t1.dt,
           t1.bt,
           duration,
           1 as cnt
    from queue.pred_pos_stay t1
    join queue.pred_pos_stats t2
      on t1.dt = t2.dt and t1.bt = t2.tm_win
    where t1.duration > 5 and t1.duration < 20 * 60 and t1.dt = '%s' and t2.cnt = 1

    union all

    select dt,
           bt,
           round(avg(duration)) as duration,
           count(*) cnt
    from (
        select t3.*
        from queue.pred_pos_stay t3
        join queue.pred_pos_stats t4
          on t3.dt = t4.dt and t3.bt = t4.tm_win
        where t3.dt = '%s' and
              t4.cnt > 1 and
              t3.duration > (t4.mean - 2 * t4.sd) and (t3.duration < t4.mean + 2 * t4.sd) and
              t3.duration > 3 * 20 and t3.duration < 20 * 60
    ) x
    group by dt, bt
) xx
order by bt", date,date)

    posdata <- rhive.query(sql)
    # pnts <- cbind(x=posdata[3],y=posdata[4])
    #
    # sql <- "select x, y from queue.security_area"
    # sec_area <- rhive.query(sql)
    # polypnts <- cbind(x=sec_area[1], y=sec_area[2])

    rhive.close()

    # jpeg(file = "sec_area.jpeg")
    # plot(polypnts, pch='.', col='blue')
    # polygon(polypnts, lty=1,border='blue')
    #
    # result <- pnt.in.poly(pnts,polypnts)
    # pntsInPoly <- result[which(result$pip==1),1:2]
    # pntsOutPoly <- result[which(result$pip==0),1:2]
    #
    # points(pntsOutPoly,col='red',pch=4)
    # points(pntsInPoly,col='magenta',pch=6)
    # title("T3C Location Distribution")
    #
    # dev.off()

    return (list(sckData, posdata))
}

