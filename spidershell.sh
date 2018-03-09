#!/bin/bash
# instagram: @thelinuchoice
trap 'printf "\e[1;77m \n Ctrl+C was pressed, exiting...\n\n \e[0m"; rm -rf spider.url*; exit 0' 2
counter=0
turn=0
default_crawl="0"
default_threads="10"
#printf "\e[1;32m"
function banner() {

printf "\e[1;31m╔═╗┌─┐┬┌┬┐┌─┐┬─┐  ╔═╗┬ ┬┌─┐┬  ┬ \n\e[0m"  
printf "\e[1;31m╚═╗├─┘│ ││├┤ ├┬┘  ╚═╗├─┤├┤ │  │ \n\e[0m"  
printf "\e[1;92m╚═╝┴  ┴─┴┘└─┘┴└─  ╚═╝┴ ┴└─┘┴─┘┴─┘\n \e[0m"
printf "\n"

}
banner
read -p $'\e[1;77mSite to start spider: \e[0m' site
read -p $'\e[1;77mCrawl Depth (Default '$default_crawl'): ' crawl
crawl="${crawl:-${default_crawl}}"
read -p $'\e[1;77mThreads (Default '$default_threads'): ' threads
threads="${threads:-${default_threads}}"
#printf "\e[0m"
#printf "\n \e[0;101m"
printf "\e[101m[*] Spider Shell is \e[5mrunning\e[25m, please wait... \e[0m \n"
#printf "\e[0m \n"
wget -q $site -O - | tr "\t\r\n'" '   "' | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' > spider.url.$turn
let counter++

function spider() {
let turn++
cat spider.url.$((turn-1)) | xargs -P $threads -I % wget -q % -O - | tr "\t\r\n'" '   "' | grep -i -o '<a[^>]\+href[ ]*=[ \t]*"\(ht\|f\)tps\?:[^"]\+"' | sed -e 's/^.*"\([^"]\+\)".*$/\1/g' >> spider.url.$turn
}
while [[ "$crawl" -gt "$counter" ]]; do
  spider
  let counter++
done
cat spider.url* | uniq > urlfound.txt
rm -rf spider.url*
printf "\e[1;77m\nLinks found: $(wc -l urlfound.txt) \e[0m \n" 

