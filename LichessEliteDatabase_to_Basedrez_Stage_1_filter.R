#R script , first stage to include Lichess Elite Database Top Games into Basedrez
# Criterion: To keep all games played between to titled players (including Bots for now), and all Rapid and Classical
# paced games
# As this is a one time process removal of short games is not included in script as it has been previously been performed
# Have that in mind if reuse this code in the future

library(bigchess)
library(stringr)

pgndir <- '/media/cpa/ADATA SD600Q/platinum/'
pgnlist <- list.files(pgndir)[grepl('el', list.files(pgndir))]
pgnlist <- pgnlist[!grepl("lichess", pgnlist)]
pgnlist <- pgnlist[!grepl("platinum", pgnlist)]
pgnout <- str_replace(pgnlist, ".pgn", "_platinum.pgn")
pgnlist <- paste0(pgndir, pgnlist)
pgnout <- paste0(pgndir, pgnout)

for (i in 1:length(pgnlist)) {
  pgn <- read.pgn(
    pgnlist[i],
    add.tags = c(
      "WhiteElo",
      "BlackElo",
      "LichessURL",
      "BlackTitle",
      "WhiteTitle",
      "TimeControl",
      "Opening",
      "UTCDate",
      "Termination"
    )
    ,
    extract.moves = F,
    #  n.moves = T,
    stat.moves = F,
    ignore.other.games = T
  )
  
  pgn$Date <- pgn$UTCDate
  pgn$UTCDate <- NULL
  
  gold <- subset(pgn, !(is.na(pgn$BlackTitle)) & !(is.na(pgn$WhiteTitle)))
  gold <- subset(gold, grepl('blitz', gold$Event, ignore.case = T))
  
  silver <- subset(pgn, !grepl('blitz', pgn$Event, ignore.case = T))
  
  platinum <- rbind(gold, silver)
  platinum$tc <- as.numeric(gsub("\\+.*","", platinum$TimeControl))
  platinum <- platinum[platinum$tc > 179,]
  
  write.pgn(
    platinum,
    pgnout[i],
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
}