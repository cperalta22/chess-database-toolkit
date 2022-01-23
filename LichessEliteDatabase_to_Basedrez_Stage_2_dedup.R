library(bigchess)
library(stringr)

  refgames <- read.pgn(
  "/media/cpa/ADATA SD600Q/platinum/basenstein_2020_2022.pgn",
  add.tags = c(
    "WhiteElo",
    "BlackElo"
  )
  ,
  extract.moves = F,
  n.moves = F,
  stat.moves = F,
  ignore.other.games = T
  )

pgn <- read.pgn(
  "/media/cpa/ADATA SD600Q/platinum/all_platinum.pgn",
  add.tags = c(
    "WhiteElo",
    "BlackElo",
    "LichessURL",
    "BlackTitle",
    "WhiteTitle",
    "TimeControl",
    "Opening",
    "Termination"
  )
  ,
  extract.moves = F,
  n.moves = F,
  stat.moves = F,
  ignore.other.games = T
)

# only to avoid reloading while doing tests
#pgna <-pgn
#refgamesa <- refgames
#pgn <- pgna
#refgames <- refgamesa
#

pgn <- pgn[order(pgn$Date),]
pgn$fecha <- as.Date(pgn$Date, format = "%Y.%m.%d")

refgames <- refgames[order(refgames$Date),]
refgames$fecha <- as.Date(refgames$Date, format = "%Y.%m.%d")
refgames <- refgames[!is.na(refgames$fecha),]

# Rango de fechas para hacer subsets, evitando eliminar de mas
fr <- min(refgames$fecha)
ff <- max(pgn$fecha)

while (fr[length(fr)]<ff) {
  fr <- c(fr,fr[length(fr)]+28)
}

noDup <- c()

for (i in 1:length(fr)-1){
  rf <- refgames[(refgames$fecha> fr[i] & refgames$fecha < fr[i+1]),]
  pg <- pgn[(pgn$fecha> fr[i] & pgn$fecha < fr[i+1]),]
  nd <- subset(pg, !(pg$Movetext %in% rf$Movetext))

  noDup <- rbind(noDup,nd)
}

bots <- noDup[noDup$WhiteTitle == "BOT" | noDup$BlackTitle == "BOT" ,]
bots$Site <- "L1chess EliteDB BOT"
human <- noDup[noDup$WhiteTitle != "BOT" & noDup$BlackTitle != "BOT" ,]
blitz <- human[grepl("blitz",human$Event, ignore.case = T),]
blitz$Site <- "L1chess EliteDB Blitz"
rapid <- human[grepl("rapid",human$Event, ignore.case = T) | grepl("classical",human$Event, ignore.case = T) ,] 
rapid$Site <- "L1chess EliteDB Rapid"

noDup <- rbind(bots,blitz,rapid)

write.pgn(
  noDup,
  "/media/cpa/ADATA SD600Q/platinum/platinum_final.pgn",
  add.tags = c(
    "WhiteElo",
    "BlackElo",
    "LichessURL",
    "BlackTitle",
    "WhiteTitle",
    "TimeControl",
    "Opening",
    "Termination"
  )
)

