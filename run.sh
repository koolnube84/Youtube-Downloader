
function startup {
	clear
	echo "Welcome to $(tput setaf 1)Youtube$(tput sgr0) downloader by Nick Lemke"
	echo ""
	#Check for brew
	[ ! -f "`which brew`" ] && echo "$(tput setaf 2)[SYSTEM]$(tput sgr0)$(tput setaf 1)[Error]$(tput sgr0) HomeBrew Not installed" && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"  brew doctor && brew install youtube-dl && clear &&echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) $(tput setaf 1)Youtube$(tput sgr0) downloader successfully Installed"
	readfile
}

function readfile {
	echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Reading Download File 1/3"
	#sleep .5
	echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Reading Download File 2/3"
	#sleep .5
	echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Reading Download File 3/3"
	LINES=$(sed -n '$=' list.txt)
	#sleep .5
	echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Found $LINES URLS to download"
	echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Ready to start download? (Y/n)"
	read choice1
	if [ $choice1 == 'Y' ]; then
		download
	else
		quit
	fi
}

function download {
	clear
	START=1
	for i in $(eval echo "{$START..$LINES}")
	do
		echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Downloading $i of $LINES"
		echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Getting Video URL"
		URL=$(sed -n $i'p' < list.txt)
		echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Getting Video Name"
		curl -s $URL >> file$i.html
		echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Processing Video Name"
		grep "<title>" file$i.html >> title$i.txt
		ex -sc '%s/\(\YouTube\).*/\1/ | x' title$i.txt
		sed 's/^.\{7\}//' title$i.txt >> name$i.txt
		NAME=$(sed '$ s/..........$//' name$i.txt)
		echo "$(tput setaf 2)[SYSTEM]$(tput sgr0) Downloading $NAME"
		youtube-dl -q $URL
		rm -r file$i.html
		rm -r name$i.txt
		rm -r title$i.txt
		echo ""

	done
	thankyou

}


function thankyou {
	echo "Thank you for using $(tput setaf 1)Youtube$(tput sgr0) downloader by Nick Lemke"
	return
}

function quit {
	echo "Goodbye"
	return
}

startup