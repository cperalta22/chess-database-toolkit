# provide into terminal arguments how many TWIC releases you want to download
# this is very basic way to do it, and only fetch from newest to oldest with
# no other option

lynx -listonly -nonumbers -dump  https://theweekinchess.com/twic | grep g.zip | head -n $1 | parallel --gnu "wget {}"
ls *.zip | parallel --gnu "unzip {}"
rm *zip
