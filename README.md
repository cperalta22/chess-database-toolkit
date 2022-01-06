# chess-database-toolkit
Several tools to help you create your own chess database from freely available resources

This repo is where I deposit my code that help me to maintain my own chess database in Scid Vs PC format, code is cited down below when appropiate

__Check in this repo the file chess_database_curation.md for a brief reference as to how I built and maintain my chess database__
https://github.com/cperalta22/chess-database-toolkit/blob/main/chess_database_curation.md

## Tools

### __twic_fetch.sh__ : 

Very simple download tool to fetch multiple The Week in Chess weekly updates, should work over a Linux of MacOS system and requires installation of:

- lynx  
- parallel 
- unzip 

Usage: __$ twic_fetch.sh N__ (Where N is the number of TWIC updates to be downloaded)

Currently supporting only downloading of TWIC updates from newer to older


### __twic_info_parser.R__ : 

Script to fetch weekly updates information, as previous script it can process several updates with same limitation (only newest to oldest), It searches for Unknown Time Controls, Bullet Games, Some potentially troublesome key words, It requires a list of known time controls in csv format (This can be created with next script on this list). It returns Two files: A report with a list of TWIC updates and their events, in case there is a potential issue under the event name would be a description and event information to help you to decide whereas you want to conserve those games in your database 

Requires:

- lynx  
- parallel 
- unzip 
- R
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work over MacOS and Linux)

### __time_control_reference_creator.R__: 

Rscript to generate a dictionary of time controls, it list all time controls in a non redundant manner from the last N TWIC updates, a dictionary created with the last 400 updates (last included 1416) can be found in this repo

Requires:

- lynx  
- parallel 
- unzip 
- R
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work over MacOS and Linux)

### __lichessEDB_TWIC_deduplicater.R__:

R script that takes two PGN files one from a given period of TWIC updates and other from same period coming from Lichess Elite Database and searches and remove duplicate games (based on same sequence of moves). See more details on __chess_database_curation.md__

Requires:

- R
- bigchess library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work on any R capable OS)




