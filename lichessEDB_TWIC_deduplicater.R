#R script 

library(bigchess)

elite <- read.pgn("~/Downloads/elite_slowChess_28_02_21.pgn", add.tags = c("WhiteElo", "BlackElo"), extract.moves = F,n.moves = F,stat.moves = F)
basenstein <- read.pgn("~/Downloads/basenstein_lichess_28_02_21.pgn",extract.moves = F,n.moves = F,stat.moves = F)


moveText <- unique(basenstein$Movetext)

notDups <- subset(elite, !(elite$Movetext %in% moveText))

notDups$Site <- "L1chess Elite DB"

write.pgn(notDups, "~/Downloads/l1chessDBupdate4basenstein.pgn",add.tags = c("WhiteElo", "BlackElo"))