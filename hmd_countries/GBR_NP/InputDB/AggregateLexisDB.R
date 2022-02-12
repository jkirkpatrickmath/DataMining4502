## GBR_NP is the aggregate of the subnational populations.  For the InputDB,
## skeletal files are used as placeholders and all the real analysis and
## diagnostics are done for NIR, SCO, ENW separately.  The LexisDB files are the
## aggregation of the subnational populations, over the intersection of dates

## NB. There is a similar script AggregateInputDB.R for aggregation of InputDB files, should that ever be warranted.

## routine to write LexisDB is writeLDB.R in the HMDLexis package
library(devtools)
load_all("/data/commons/boe/HMDLexis.git/HMDLexis/HMDLexis")

PROJ<- "/data/wilmoth0/HMD/HMDWORK"
XCOUNTRY <- "GBR_NP"

regions <- c("GBR_SCO","GBR_NIR","GBRTENW")
#types   <- c("death","pop","birth")     # no tadj for this set of countries

#type <- "birth"
sexes <- c("f","m")

#### read Lexis DB
f.readLDB <- function(LDBPATH, sex, country.code){
  #columns: year, age, triangle, cohort, Population, deaths
  db.path <- file.path(LDBPATH, paste0(sex, country.code, ".txt"))
  .line1 <- readLines(con=db.path, n=1)
  cat(paste0("\n", .line1, "\n"))
  if( grepl("Year", .line1)){ # file has header
    ldb.orig <- read.csv(db.path)
    stopifnot( all( colnames(ldb.orig) %in% c("Year", "Age", "Triangle", "Cohort", "Population", "Deaths") ))  
  }  else {
    ldb.orig <- read.table(db.path, sep = ",", head=FALSE)
    colnames(ldb.orig) <- c("Year", "Age", "Triangle", "Cohort", "Population", "Deaths")
  }

  ldb <- ldb.orig
  return(ldb)
}

aggldb.list <- as.list( sexes )
names(aggldb.list) <- sexes

for(sex in sexes){
  aggldb <- NULL
  yrscovered <-NULL
  for(region in regions){
    LDBPATH <- file.path(PROJ,region,"LexisDB")
    this.ldb <- f.readLDB(LDBPATH, sex, region)
    this.ldb <- cbind(Region=region, this.ldb)
    
    if(is.null(yrscovered )){                   # assume the same coverage for both sexes
      yrscovered <- unique(this.ldb$Year)
    } else {
      yrscovered <- intersect(yrscovered, this.ldb$Year)
    }
    aggldb <- rbind(aggldb, this.ldb)
  }
  stopifnot( max(aggldb$Year) == max(yrscovered))
  aggldb <- aggldb[ aggldb$Year %in% yrscovered, ]  # common years of regions
  aggldb$Deaths <- ifelse( aggldb$Deaths == -1, NA, aggldb$Deaths)
  aggldb$Population <- ifelse( aggldb$Population == -1, NA, aggldb$Population)
  
  ## aggldb <- data.table(aggldb)   # data.table is much nicer than aggregate here
  # aggldb <- aggregate(aggldb[, -1], by=list(Year = aggldb$Year, Age = aggldb$Age, 
  #                                       Triangle = aggldb$Triangle, Cohort =  aggldb$Cohort), sum )
  # 
  # tmp <- aggregate(aggldb[, -1], by=list(aggldb$Year,  aggldb$Age, 
  #                                            aggldb$Triangle,   aggldb$Cohort), sum )
  
  # reshape2 makes this all much clearer and tidy
  # Population, Deaths are variables, drop Region
  ldb.melt <- melt( aggldb[, ! colnames(aggldb) %in% "Region" ], id=c("Year", "Age", "Triangle", "Cohort") ) 
  aggldb <- dcast(ldb.melt, Year + Age + Triangle + Cohort ~ variable, sum, na.rm=FALSE )
  
  aggldb$Deaths <- ifelse( is.na(aggldb$Deaths), -1, aggldb$Deaths)
  aggldb$Population <- ifelse( is.na(aggldb$Population), -1, aggldb$Population)
  
  isel.aggldb <- with(aggldb, order(Year, Age, Triangle))
  aggldb <- aggldb[isel.aggldb,]
  
  aggldb.list[[sex]] <-  aggldb
  
 
}

HMDLexis::writeLDB(ldb.by.sex = aggldb.list, LDBpath = file.path(PROJ,XCOUNTRY,"LexisDB"), 
                   COUNTRY = XCOUNTRY)

