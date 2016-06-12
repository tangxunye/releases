#!/bin/bash -x
ORIGCWD=$PWD; 

RELEASES=()
for i in lts alpha; 
do 
	cd $ORIGCWD/src/$i/;
	echo $PWD;
	git clean --force;
	git pull;
	cd src/;
	php build.php;
	VERSION=`php -r "include 'version.php'; echo VERSION;"`
	JSONVERSION="\"$i\":\"$VERSION\""
	RELEASES+=($JSONVERSION)
	cd $ORIGCWD;
	if [ ! -d "$ORIGCWD/releases/$i/$VERSION/" ]; then
		mkdir $ORIGCWD/releases/$i/$VERSION/;
		cp $ORIGCWD/src/$i/fmt.phar $ORIGCWD/releases/$i/$VERSION/;
		cp $ORIGCWD/src/$i/fmt.phar.sha1 $ORIGCWD/releases/$i/$VERSION/;
	fi
	rm -f $ORIGCWD/src/$i/fmt.phar $ORIGCWD/src/$i/fmt.phar.sha1 $ORIGCWD/src/$i/fmt.php
done;

cd $ORIGCWD;
(IFS=","; echo "{${RELEASES[*]}}") > releases.json
