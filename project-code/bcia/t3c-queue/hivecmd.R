library(lubridate)
library(reshape2)

cmdArgs <- commandArgs(TRUE)
if(length(cmdArgs) < 3)
{
  stop("Not enough arguments. Please supply 3 arguments.")
}

dt1 <- cmdArgs[1]
dt2 <- cmdArgs[2]
sqlfile <- cmdArgs[3]


# dt1 <- '20150329'
# dt2 <- '20150329'
# sqlfile <- '/home/r/airport/sql/02-prep_sec.sql'

dates <- seq.int(ymd(dt1), ymd(dt2), by='1 day')
dates <- as.character(dates)

cmds <- sprintf('hive -hiveconf dt=%s -f %s', gsub('-', '', dates), sqlfile)
# (cmds)

cmds <- melt(cmds)
# class(cmds)
names(cmds) <- c('hivecmd')
# (cmds)

result <- with (cmds,
                Map(function(cmd) {system(as.character(cmd))}, hivecmd)
          )



