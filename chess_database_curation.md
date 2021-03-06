# Simple creation and maintance of a free chess database

__This document is going to be updated soon as it makes reference to tools that have now better versions that simplify the process__

## Super simple way
   In the following sections you can find a description into how I created and curated my own chess database, but the easiest way posible is:
  
   - Download [Scid Vs PC](http://scidvspc.sourceforge.net/)
   - Get the latest [Caissabase](http://caissabase.co.uk/)
   - Use the script [twic_fetch.sh](https://github.com/cperalta22/chess-database-toolkit/blob/main/twic_fetch.sh) or manually download the [The Week in Chess](https://theweekinchess.com/twic) updates that are not included on Caissabase, using date as reference
   - If you want a really big database you could also consider to include games from [Lichess Elite Database](https://database.nikonoel.fr/) , as 2021 Lichess Elite Database is too big to be handled in a single Scid vs PC database, so including games from this source into another database requires further filtering. 
    
   and that is it! 

## My way to create __Basenstein__ (my db)  was the combination and curation of:

- Chessbase Big Database 2014 ( I included it as I already had a legal copy of it, but you can use only Caissabase as the main source) 
- Caissabase_2020_11_14 (only games newer than 2013.11.20)
- [New in Chess archive](https://www.newinchess.nl/Na/archives/) (retrieved 19.3.2021) (yearbooks 62-136, magazine 1999-1 2020-6 [2020-1-2020-5 missing]) 
- The Week in Chess updates 1358-1375 
- Rapid and Classical games from Lichess Elite Database up to 2021.02 
  
   ### Some cautionary words ...
	
    For Chessbase DB you must export them into PGN, take in consideration your RAM and file size, for the DB i used , i splited into 6 (i think) PGN
    files using date as a way to split it
    
    Caissabase has already done most of the work for you, However marvelous work of its creator, I found still some games  duplicated the way described
    in the following section helped me to got rid of most of them
    
    New in Chess archive games ; in my experience does not worth your time include them in the database, most of those games are present in The Week In Chess 
    updates and Caissabase, the major drawback is that NIC archive games include also portions of games (meaning: those games does not start from standard
    position), also are include some chess variants games (such as Fischer Random).
    
    The Week in Chess updates is the best source for updates for OTB and good quality online games, But also contains (very rarely) some chess variants games,
    some events that are mainly Bullet or played by low ranked players, you can check the webpage of each update to decide which events you want to keep
    and then filter the rest using Scid vs PC, I wrote a script that help me find potential problematic chess events see [README.md](https://github.com/cperalta22/chess-database-toolkit/blob/main/README.md) in this repo 
    
    Lichess Elite Database; a very good way to fatten up your DB. Is a monthly release of high rated online games on Lichess with no bullet games included
    It contains mostly blitz games (wich I got rid to avoid overrepresentation of short time controls) and there is always the posibility that games present in
    other sources are duplicated in here but since Lichess Elite Database uses nicknames instead of actual names (for obvious reasons) there is no easy way 
    to got rid of such games (I wrote a script that help with that, see [README.md](https://github.com/cperalta22/chess-database-toolkit/blob/main/README.md). Finally this database contains games from legal BOTS and I found games from
    cheaters (players banned from Lichess) so If this is important to you consider it before use it for your base  
  

## Database construction and curation:

Big Database, Caissabasse (2013.11.20 and newer games), New in Chess archive  and The Week in Chess updates were merged into a single scid 
	database and then the following changes made on Scid Vs PC 4.21 for Linux:
	
	
-Games without date were removed
		-Orthografic check on all fields
		-Strict duplicate removal: same moves, same players (first four letters), and same colours
		-Games with less than 5 moves were removed (=< 10 ply)
		-All games from 1960-01-01 to date require at least one of the players be ranked 2000 or more (games w/2 players <1999 ELO are removed)
		-Fischer Random 960 games were removed
		-Bullet events have been removed (Header Search: time period(2000.00.00 - most recent games), event name = bullet)
			(this do not eliminate all bullet games, ie; events with a bullet stage will remain), for updates description on TWIC is checked for
			manual removal of bullet-only/bullet-mostly events
			
Lichess originated games from this preliminary database were exported as PGN file 
	
Lichess Elite Database games were first filtered BUT NOT INCLUDED IN THE PRELIMINARY DATABASE yet by:
	
-Event name (Containing words "Classical" or "Rapid")
		-Games with less than 5 moves where removed (=< 10 ply)
		-Games with less than 10 moves and draw removed  (=<20 ply and  =/= or * as result)
		
A PGN file of the filtered games was exported
	
  As The Week in Chess updates contains actual player names and ELO rating while Lichess Elite Database has nicknames and lichess rating is
	required to remove duplicates solely by game moves which is not possible on Scid vs PC for that reason and to be able to identify which games
	come from  Lichess Elite Database, I wrote a small script in R lichessEDB_TWIC_deduplicater.R (check this repositoty content) using [bigchess](https://cran.r-project.org/web/packages/bigchess/index.html) package 
	
	
  PGN Site field for the resuling games was substituted for "L1chess Elite DB" (For easy ID on Scid Vs PC, this prevents that search for
	"lichess" return this games, so if want to remove games from Lichess Elite Database just filter by "L1chess")
	
Once a PGN with no duplicates and updated "Site" tag is created, it is incorporated to Basenstein


## Basenstein updates come from "This Week in Chess" and "Lichess Elite Database"

TWIC Updates are filtered just as main database before including games into Basenstein

Basically ...

1. Download TWIC and Lichess Elite Database updates
2. Create temporary scid databases to filter **separately** TWIC and Lichess updates
3. I use [twic_info_parser.R](https://github.com/cperalta22/chess-database-toolkit/blob/main/twic_info_parser.R) to help me filter TWIC updates
4. Once I removed unwanted TWIC games I add the games into main database
5. Then I filter Lichess update temporary database to keep only Rapid and Classical games and export them as pgn file
6. I export a second pgn file with all the games from the same period of Lichess updates from the updated Basenstein
7. Then I use [lichessEDB_TWIC_deduplicater.R](https://github.com/cperalta22/chess-database-toolkit/blob/main/lichessEDB_TWIC_deduplicater.R), to filter games of Lichess that were already in updated Basenstein, and change pgn "Site" field to ease ID, a new pgn file is created by the script.
8. I add that last pgn file to Basenstein.

I do this every few months and it take me around an hour (using the scripts) 
