# chess-database-toolkit

Several tools to help you create your own chess database from freely available resources

This repo is where I deposit my code that help me to maintain my own chess database in Scid Vs PC format

Check in this repo the file [chess_database_curation.md](https://github.com/cperalta22/chess-database-toolkit/blob/main/chess_database_curation.md) for a brief reference as to how I built and maintain my chess database (__For now is and outdated methodology that uses mostly the scripts described on the "Old tools" section of this document, it will be updated to use the "Current tools" soon__)  

---


## Current tools

Updated scritps to keep up to date a chess database.

### time_control_reference_creator.R: 

R script to generate a dictionary of time controls, it list all time controls in a non redundant manner from the last N TWIC updates, a dictionary created with  400 updates (last included 1416) can be found in this repo, __this dictionary is required for other scripts__

Requires:

- lynx  
- parallel 
- unzip 
- R
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work over MacOS and Linux)



---
## Old tools

this stuff are mostly unconected scripts, and ad hoc scripts for the first time I created a database

### twic_fetch.sh: 

Very simple download tool to fetch multiple The Week in Chess weekly updates, should work over a Linux of MacOS system and requires installation of:

- lynx  
- parallel 
- unzip 

```console
$ twic_fetch.sh N 
```

Currently supporting only downloading of TWIC updates from newer to older


### twic_info_parser.R : 

Script to fetch weekly updates information, as previous script it can process several updates with same limitation (only newest to oldest), It searches for Unknown Time Controls, Bullet Games, Some potentially troublesome key words, It requires a list of known time controls in csv format (This can be created with next script on this list). It returns Two files: A report with a list of TWIC updates and their events, in case there is a potential issue under the event name would be a description and event information to help you to decide whereas you want to conserve those games in your database 

Requires:

- lynx  
- parallel 
- unzip 
- R
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work over MacOS and Linux)

### lichessEDB_TWIC_deduplicater.R:

R script that takes two PGN files one from a given period of TWIC updates and other from same period coming from Lichess Elite Database and searches and remove duplicate games (based on same sequence of moves). See more details on __chess_database_curation.md__

Requires:

- R
- bigchess library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work on any R capable OS)


### LichessEliteDatabase_to_Basedrez_Stage_1_filter.R

Single use script that I used for filtering the whole Lichess Elite Database to get only Blitz games between two titled players, and all rapid and classical games, it also includes into pgn additional fields that were not considered by __lichessEDB_TWIC_deduplicater.R__

- R
- bigchess library
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work on any R capable OS)


### LichessEliteDatabase_to_Basedrez_Stage_2_dedup.R

Another single use script to deduplicate games from Caissabase or my own database against games obtained with previous script, unlike the script that does the equivalent on the section of "Current tools" this splits input games into smaller sections based on dates to increase speed of execution and reduce risk of falsely removed games, this script was tested with inputs over 1.5 million games 

- R
- bigchess library
- stringr library

Usage: Change global variables as your convinence and run it into any R instance with the appropiates libraries installed (Should work on any R capable OS)
