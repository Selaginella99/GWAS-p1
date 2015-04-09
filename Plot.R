How to set the interval by R? http://stackoverflow.com/questions/15717545/set-the-intervals-of-x-axis-using-r

plot(0:23, d, type='b', axes=FALSE)
axis(side=1, at=c(0:23))
axis(side=2, at=seq(0, 600, by=100))
box()
