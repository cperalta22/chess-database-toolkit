# provide into terminal arguments how many TWIC releases you want to download
# this is very basic way to do it, and only fetch from newest to oldest with
# no other option
# see https://github.com/cperalta22/chess-database-toolkit/blob/main/README.md for instructions

lynx -listonly -nonumbers -dump  https://theweekinchess.com/twic | grep g.zip | head -n $1 | parallel --gnu "wget {}"
ls *.zip | parallel --gnu "unzip {}"
rm *zip
