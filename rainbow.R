library("xlsx")
data = read.xlsx("experiment_data.xlsx", sheetIndex = 2)
mat = as.matrix(data)
head = mat[0,]
print(head)
print(mat[1:4,])
c1=rainbow(7)
par(cex.axis = 0.7)
boxplot(mat[1:4,], ylab = "Coefficient Value", col=c1, las=2, names=c("Bare System", "Docker", "Singularity", "LPMX 5 layers", "LPMX 2 layers", "uDocker", "Podman"))

