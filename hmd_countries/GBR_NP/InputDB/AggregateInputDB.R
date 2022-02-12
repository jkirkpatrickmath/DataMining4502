## script to run for GBR_NP which forms the aggregate InputDB entries, based on the sum of the constituate regions

## try the InputDB routine developed for LexisDB
##source("/hdir/0/triffe/COMMONS/LexisDB_R/LexisDB_R.hg/RLexisDB/R/readInputDB.R")

library(reshape2)
PROJ<- "/data/wilmoth0/HMD/HMDWORK"
XCOUNTRY <- "GBR_NP"

regions <- c("GBR_SCO","GBR_NIR","GBRTENW")
types   <- c("death","pop","birth")     # no tadj for this set of countries

type <- "birth"

## deaths
head.expect.death <-
  c("PopName","Area","Year","YearReg","YearInterval","Sex","Age","AgeInterval","Lexis",
    "RefCode","Access","Deaths","NoteCode1","NoteCode2","NoteCode3","LDB")

f.readDeath <- function(fname, head.expect=head.expect.death){
  
  t.d <- read.csv(fname, as.is=TRUE)
  if( ! all.equal(names(t.d), head.expect) ){
    print(names(t.d))
    stop("unexpected CSV header")
  }
  return(t.d)
}


death.table <- NULL
for(i.region in regions){
  i.fname <- file.path(PROJ, i.region, "InputDB",paste0(i.region,"death.txt") )
  i.out <- f.readDeath(i.fname)
  death.table <- rbind(death.table,i.out)
}
## put all rows in same regions and then aggregate over deaths
death.table$PopName <- XCOUNTRY

## use reshape2.  Sort by PopName, Year, Sex, Age and also include everything else
## after making Deaths the variant of action
t.melt <- melt(death.table,measure.vars="Deaths")
t.cast <- dcast(t.melt, PopName + Year + Sex+ Age + ... ~ variable  ,  fun.aggregate=sum)
t.cast <- t.cast[, head.expect.death]  # columns in expected order
fname.out <- file.path(PROJ, XCOUNTRY,"InputDB",paste0(XCOUNTRY,"death.txt") )
write.table(t.cast, file=fname.out, row.names=FALSE, quote=FALSE, sep=",")

# births
head.expect.birth <-
  c("PopName", "Area", "Sex", "Year", "YearReg", "RefCode", "Access",
    "Births", "NoteCode1", "NoteCode2", "NoteCode3", "LDB")

f.readBirth <- function(fname, head.expect=head.expect.birth ){
  
  t.b <- read.csv(fname, as.is=TRUE)
  if( ! all.equal(names(t.b), head.expect) ){
    print(names(t.b))
    stop("unexpected CSV header")
  }
  return(t.b)
}


birth.table <- NULL
for(i.region in regions){
  i.fname <- file.path(PROJ, i.region, "InputDB",paste0(i.region,"birth.txt") )
  i.out <- f.readBirth(i.fname)
  birth.table <- rbind(birth.table,i.out)
}
## put all rows in same regions and then aggregate over deaths
birth.table$PopName <- XCOUNTRY

## use reshape2.  Sort by PopName, Year, Sex, Age and also include everything else
## after making Deaths the variant of action
t.melt <- melt(birth.table,measure.vars="Births")
t.cast <- dcast(t.melt, PopName + Year + Sex  + ... ~ variable  ,  fun.aggregate=sum)
t.cast <- t.cast[, head.expect.birth]  # columns in expected order
fname.out <- file.path(PROJ, XCOUNTRY,"InputDB",paste0(XCOUNTRY,"birth.txt") )
write.table(t.cast, file=fname.out, row.names=FALSE, quote=FALSE, sep=",")

