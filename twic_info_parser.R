# TWIC UPDATE MANAGER

# Requires:
#   parallel
#   lynx
#   wget
#   grep
#   internet connection

library(stringr)

LAST_N_UPDATES = 22  # How many updates do you want to process from newest to oldest
OUTDIR = '/home/cpa/Descargas/twicUpdate'
OUTFILE = paste0(OUTDIR, '/twic_report.txt')
OUTSHORTLIST = paste0(OUTDIR, '/twic_shortlist.csv')
TCONTROL_DICT_FILE = '/home/cpa/chess_resources/code4bases/timeControls.csv'
TCONTROL_DICT = read.csv(
  TCONTROL_DICT_FILE,
  stringsAsFactors = F,
  header = T
)
FLAGS = c('bullet', 'fischer', 'fisher', 'random', '960', 'variant') # potentially troublesome terms

# Fetch TWIC update information
cmmd <-
  paste(
    'lynx -listonly -nonumbers -dump  https://theweekinchess.com/twic | grep "/html/" | uniq | head -n',
    LAST_N_UPDATES
  )
twic_descriptions <-
  system(cmmd,
         wait = T,
         intern = T)

print(twic_descriptions) # CHECK THIS OUTPUT  BEFORE TO PROCEED


rprt <- c() # initalize empty report vector
newTimeControls <- c() # to keep and report unknown time controls
flagged_events <- c() # shortlist of problematic events
knownTC <- TCONTROL_DICT$time
bulletTC <- TCONTROL_DICT$time[TCONTROL_DICT$bullet == 'TRUE']


# MAIN FUNCTION
for (i in 1:length(twic_descriptions)) {
  # Fetch update info
  lynk <- twic_descriptions[i]
  con <-
    system(paste('lynx  -dump -nolist -nonumbers', lynk),
           intern = T,
           wait = T)
  
  strt <- grep('1) Introduction', con, ignore.case = T)
  fnsh <- grep(') Fort', con, ignore.case = T)
  event_list <- con[strt[1]:fnsh[1]]
  event_list <- str_replace(event_list, '   ', '')
  upd_info <-
    con[strt[2]:fnsh[2]]  # Keeps only event info, discards event index and forthcoming events
  currentTC <- unique(grep('Time Control:', upd_info, value = T))
  newTimeControls <-
    append(newTimeControls, currentTC[!(currentTC %in% knownTC)])#Keeps track of Time Controls not present in dictionary
  
  rprt <-
    append(rprt, lynk) # initialize report for given twic update
  
  flagged_events <-
    append(flagged_events, paste0(lynk,',Issue'))

  
  if (length(strt) != 2) {s
    rprt <-
      append(
        rprt,
        "    WARNING: Word '1) Introduction' appears an unexpected number of times, might cause problems with parsing"
      )
  }
  if (length(fnsh) != 2) {
    rprt <-
      append(
        rprt,
        "    WARNING: Word ') Forth' appears an unexpected number of times, might cause problems with parsing"
      )
  }
  
  event_idxs <- c()
  for (j in 1:(length(event_list))) {
    a = grep(substr(event_list[j], 1, 9), upd_info, ignore.case = T)
    if (length(a) != 1) {
      rprt <-
        append(
          rprt,
          paste(
            "    ERROR: Unexpected occurences for",
            event_list[j],
            '; found',
            length(a),
            ', must be 1; using first one'
          )
        )
    }
    event_idxs <- append(event_idxs, a[1])
  }
  event_idxs_end <- event_idxs - 1
  
  rprt <- append(rprt, '')
  
  for (j in 2:(length(event_list) - 1)) {
    event_info <- upd_info[event_idxs[j]:event_idxs_end[j + 1]]
    
    rprt <-
      append(
        rprt,
        '_______________________________________________________________________________________________________________'
      )
    rprt <- append(rprt, event_list[j])
    
    tcontrol <-
      grep('time control',
           event_info,
           ignore.case = T,
           value = T)
    
    if (length(tcontrol) == 0) {
      rprt <- append(rprt, '')
      rprt <-
        append(rprt, "*** NO TIME CONTROL FOUND *** ")
      rprt <- append(rprt, '')
      rprt <- append(rprt, "    Check event description please: ")
      rprt <- append(rprt, event_info[2:length(event_info)])
      rprt <- append(rprt, '')
      flagged_events <- append(flagged_events, paste0(event_list[j],',No time control'))
    }
    
    if (any(tcontrol %in% bulletTC)) {
      rprt <- append(rprt, '')
      rprt <- append(rprt, '*** BULLET TIME CONTROL DETECTED ***')
      rprt <- append(rprt, tcontrol[tcontrol %in% bulletTC])
      rprt <- append(rprt, '')
      flagged_events <- append(flagged_events, paste0(event_list[j],',Bullet time control'))
    }
    
    if (!all(tcontrol %in% knownTC)) {
      flagged_events <- append(flagged_events, paste0(event_list[j],',Unknown time control'))
      rprt <- append(rprt, '')
      rprt <- append(rprt, '*** UNKNOWN TIME CONTROL DETECTED ***')
      rprt <- append(rprt, tcontrol[!(tcontrol %in% knownTC)])
      rprt <- append(rprt, '')
      rprt <- append(rprt, "    Check event description please: ")
      rprt <- append(rprt, event_info[2:length(event_info)])
      
      newTimeControls <-
        append(newTimeControls, tcontrol[!(tcontrol %in% knownTC)])
      rprt <-
        append(
          rprt,
          'Check end of this document for a list of unknow time controls found to consider update dictionary'
        )
      rprt <- append(rprt, '')
    }
    
    for (n in 1:length(FLAGS)) {
      flag <- grep(FLAGS[n],
                   event_info,
                   ignore.case = T,
                   value = T)
      
      if (length(flag) != 0) {
        rprt <- append(rprt, '')
        rprt <-
          append(
            rprt,
            paste(
              "    CAUTION: word",
              FLAGS[n],
              "has appeared into this event description : "
            )
          )
        rprt <- append(rprt, '')
        rprt <- append(rprt, flag)
        flagged_events <- append(flagged_events, paste0(event_list[j],',Flag word present: ',toupper(FLAGS[n])))
      }
    }
  }
  
  rprt <- append(rprt, '')
  rprt <-
    append(
      rprt,
      '##################################################################################################################'
    )
  rprt <- append(rprt, '')
  flagged_events <- append(flagged_events, ',')
}

if (length(newTimeControls != 0)){
  rprt <- append(rprt, '***LIST OF UNKNOWN TIME CONTROLS DETECTED ***')
  rprt <- append(rprt, paste('Dictionary is in:',TCONTROL_DICT_FILE))
  rprt <- append(rprt, '')
  rprt <- append(rprt, unique(newTimeControls))
}

# Report export
ifelse(!dir.exists(OUTDIR), dir.create(OUTDIR), FALSE)
write(rprt, OUTFILE)
write(flagged_events, OUTSHORTLIST)
# To do ... create a shortlist only with events with flags
