library(ggplot2)

"%&%" <- function(a,b) paste(a, b, sep="")

extract_tstv <- function(x) {
  return( x$COUNT[7] / x$COUNT[8] )
}

args <- commandArgs(trailing=TRUE)

atlas.base <- args[1]
gatk.base <- args[2]
freebayes.base <- args[3]
mpileup.base <- args[4]
cges.base <- args[5]
pdf.file <- args[6]

atlas.tstv <- read.table(atlas.base %&% ".TsTv.summary", header=T)
gatk.tstv <- read.table(gatk.base %&% ".TsTv.summary", header=T)
freebayes.tstv <- read.table(freebayes.base %&% ".TsTv.summary", header=T)
mpileup.tstv <- read.table(mpileup.base %&% ".TsTv.summary", header=T)
consensus.tstv <- read.table(cges.base %&% ".TsTv.summary", header=T)

callers <- list('Atlas', 'GATK', 'Freebayes', 'Mpileup', 'CGES')
tstv.dat <- list(atlas.tstv, gatk.tstv, freebayes.tstv, mpileup.tstv, consensus.tstv)


tstv <- data.frame( tstv = unlist( lapply(tstv.dat, extract_tstv) ),
                    Callers = unlist(callers))
tstv$order_callers <- reorder(tstv$Callers, tstv$tstv)

print(tstv)

plt <- ggplot( tstv, aes(x=order_callers, y=tstv, fill=Callers) ) +
        geom_bar(stat="identity", show_guide = FALSE) +
        labs(x="Callers", y="Ts/Tv") +
        theme_bw()
 
pdf(pdf.file)
show(plt)
dev.off()


