library(ggplot2)
library(plyr)
library(reshape2)
library(gridExtra)

source("prep_data.R")
data <- prepData("datanode1", 10000, '20150712')
sec <- data[[1]]
pos <- data[[2]]

x <- pos$bt + 1
a <- data.frame(x = x, y = ceiling(pos$duration / 60), z = rep('WIFI', length(pos$bt)))

x <- sec$tm_win + 1
b <- data.frame(x = x, y = ceiling(sec$duration / 60), z = rep('SEC', length(sec$tm_win)))

# pred
names(sec) <- c("bt", "duration")
sec2 <- data.frame(bt = sec$bt + 1, duration = sec$duration)
pred1 <- merge(sec, sec2, by="bt")

p <- round((23.1427 + pred1$duration.x * 1.3695 - 0.4424*pred1$duration.y) / 60)
c <- data.frame(x = pred1$bt + 1 + 1, y = p, z = rep('PRED-SEC', length(p)))



m <- rbind(a, b, c)

x <- pos$bt + 1
n <- data.frame(x = x, y = pos$cnt)

axis.x.breaks <- seq(0, 144, by=6)
axis.x.labs <- axis.x.breaks %/% 6

png("wifi-sec.png",width = 1600, height = 600)
p1 <- qplot(x, y, data = a, main="20150712 WIFI", ylab="Duration (min)", xlab = "Hour", geom = c("point", "smooth"), method = "loess",span=0.2) + 
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs)
# dev.off()

# png("b.png")
p2 <- qplot(x, y, data = b, main="20150712 SEC", ylab="Duration (min)", xlab = "Hour", geom = c("point", "smooth"), method = "loess",span=0.2) + 
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs)

grid.arrange(p1, p2, ncol=2)
dev.off()

png("wifi-vs-sec.png",width = 1600, height = 600)
p3 <- qplot(x, y, data = m, main="20150712 - WIFI vs SEC vs PRED-SEC", ylab="Duration (min)", xlab = "Hour", colour = z, geom = "line") +
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs) + 
    labs(colour = '')

p4 <- qplot(x, y, data = m, main="20150712 - WIFI vs SEC vs PRED-SEC", ylab="Duration (min)", xlab = "Hour", colour = z, geom = c("point", "smooth"), method = "loess", span=0.2) +
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs) +
    labs(colour = '')

grid.arrange(p3, p4, ncol=2)
dev.off()

png("wifi-people.png", width = 1600, height=600)
p5 <- qplot(x, y, data = n, main="20150712 - WIFI People", ylab="Count (person)", xlab = "Hour", geom = "line") +
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs)

p6 <- qplot(x, y, data = n, main="20150712 - WIFI People", ylab="Count (person)", xlab = "Hour", geom = c("point", "smooth"), method = "loess", span=0.2) +
    scale_x_continuous(breaks = axis.x.breaks, labels = axis.x.labs)
grid.arrange(p5, p6, ncol=2)
dev.off()


