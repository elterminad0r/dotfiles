for i in {1..59}; do curl https://www.schneierfacts.com/facts/search\?page\=$i\&q\=bruce\&s\=Search\&utf8\=%E2%9C%93 | grep "<li><a href=\"/facts/[0-9]" > downl_$i.txt; sleep 1; done
cat download/* | sed -E "s/.*li><a href=\"[^\"]*\">(.*)($|<\/a.*)/\1/g"
