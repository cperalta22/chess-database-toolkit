# time controls fetch to create adictionary 

library(stringr)

LAST_N_UPDATES = 400  # How many updates do you want to process from newest to oldest
TCONTROL_LOG_DIR ='/home/cpa/chess_resources/code4bases'
TCONTROL_DICT = paste0(TCONTROL_LOG_DIR,'/timeControls.csv')


# Fetch TWIC update information
cmmd <- paste('lynx -listonly -nonumbers -dump  https://theweekinchess.com/twic | grep "/html/" | uniq | head -n', LAST_N_UPDATES)
twic_descriptions <-
  system(
    cmmd,
    wait = T,
    intern = T
  )

rprt <- c() # initalize empty report vector

for (i in 1:length(twic_descriptions)) {
  lynk <- twic_descriptions[i]
  con <-
    system(paste('lynx  -dump -nolist -nonumbers', lynk),
           intern = T,
           wait = T)
  
    tcontrol <-
      grep('time control',
           con,
           ignore.case = T,
           value = T)
    rprt <- append(rprt,tcontrol)
}

r <- rprt

r <- unique(r)
r <- grep('Control:',r, value = T)

r <- sort(r)

r <- as.data.frame(r)
r$status <- FALSE
colnames(r) <- c('time','bullet')

write.csv(r,TCONTROL_DICT, quote = F, row.names = F)
