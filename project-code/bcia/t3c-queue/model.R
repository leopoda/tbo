library(RHive)

rhive.init()
rhive.connect(host = 'datanode1', port = 10000, hiveServer2 = TRUE, db = 'queue')

sql <- "
select tm_win, 
       duration, 
       data_date 
from pred_sec 
where (data_date between '20150330' and '20150405') and data_src = 'E'
distribute by data_date
sort by data_date asc, tm_win asc"

result <- rhive.query(sql)
names(result) <- c('bt', 'duration', 'date')

y <- result
x <- with(y, data.frame(bt - 1, duration, date, stringsAsFactors = FALSE))
names(x) <- c('bt', 'duration', 'date')

z <- merge(x, y, by.x = c('bt', 'date'), by.y = c('bt', 'date'))
z <- z[with(z, order(date, bt)),]
z <- with(z, data.frame(bt + 1, duration.x, duration.y, date, stringsAsFactors = FALSE))
names(z) <- c('id', 't10', 't20', 'date')

zx <- z
zy <- with(zx, data.frame(id - 1, t10, date, stringsAsFactors = FALSE))
names(zy) <- c('id', 't', 'date')

zz <- merge(zx, zy, by.x = c('id', 'date'), by.y = c('id', 'date'))
zz <- zz[with(zz, order(date, id)),]
zz <- with(zz, data.frame(id + 1, t, t10, t20, date, stringsAsFactors = FALSE))
names(zz) <- c('id', 't', 't10', 't20', 'date')

head(zz)
head(y)

secdata <- subset(zz, date == '20150330')
# levels(secdata$date)
fit <- lm(t ~ t10 + t20, data = secdata)
summary(fit)
confint(fit)

par(mfrow = c(2,2))
plot(fit)















