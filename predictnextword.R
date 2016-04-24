library(stringi)
library(stringr)
library(RSQLite)

load('BigramData.RData')
load('TrigramData.RData')
load('QuadgramData.RData')

biPre <- gsub(" $", "", gsub('\\w+$', "", termFrequency2[,1]))
biPost <- stri_extract_last_words(termFrequency2[,1])
termFrequency2$pre <- biPre
termFrequency2$post <- biPost
head(termFrequency2)

triPre <- gsub(" $", "", gsub('\\w+$', "", termFrequency3[,1]))
triPost <- stri_extract_last_words(termFrequency3[,1])
termFrequency3$pre <- triPre
termFrequency3$post <- triPost
head(termFrequency3)

quadPre <- gsub(" $", "", gsub('\\w+$', "", termFrequency4[,1]))
quadPost <- stri_extract_last_words(termFrequency4[,1])
termFrequency4$pre <- quadPre
termFrequency4$post <- quadPost
head(termFrequency4)

db <- dbConnect(SQLite(), dbname="predict.db")
dbSendQuery(conn=db,
            "CREATE TABLE NGram
            (pre TEXT,
            word TEXT,
            freq INTEGER,
            n INTEGER)")  # ROWID automatically created with SQLite dialect

bulk_insert <- function(sql, key_counts)
{
  dbBegin(db)
  dbGetPreparedQuery(db, sql, bind.data = key_counts)
  dbCommit(db)
}

sql_4 <- "INSERT INTO NGram VALUES ($pre, $post, $freq, 4)"
bulk_insert(sql_4, termFrequency4)
sql_3 <- "INSERT INTO NGram VALUES ($pre, $post, $freq, 3)"
bulk_insert(sql_3, termFrequency3)
sql_2 <- "INSERT INTO NGram VALUES ($pre, $post, $freq, 2)"
bulk_insert(sql_2, termFrequency2)

#sql <- "select * from NGram"
#verifyRes <- dbSendQuery(conn=db, sql)
#verifyDf <- dbFetch(verifyRes, n=-1)
#head(result)

dbDisconnect(db)
