#!/bin/bash

command -v make	> /dev/null 2>&1 && MAKE=make || true
command -v g++	> /dev/null 2>&1 && GPP=g++ || true

if [[ $MAKE = "" ]]; then
	echo "Failed to detect make. Please install make before proceeding"
	exit 1
fi

if [[ $GPP = "" ]]; then
	echo "Failed to detect g++. Please install gcc-c++ before proceeding"
	exit 1
fi

while true; do
	read -e -p "Enter processor architecture [32/64]: " -i "64" DARCH
	
	if [[ $DARCH = 32 || $DARCH = 64 ]]; then
		break
	fi
done

read -e -p "Enter installation path: " -i "/opt/d" DPATH
DPATH=`readlink -m $DPATH`
mkdir -p $DPATH/src

if [[ $? -eq 1 || ! -w $DPATH/src ]]; then
	echo "Try running as root, or change installation path"
	exit
fi

cd $DPATH/src

if [[ ! -d dmd ]]; then
	git clone https://github.com/D-Programming-Language/dmd.git
else
	 cd dmd && git pull && cd ..
fi

if [[ ! -d druntime ]]; then
	git clone https://github.com/D-Programming-Language/druntime.git
else
	cd druntime && git pull && cd ..
fi

if [[ ! -d phobos ]]; then
	git clone https://github.com/D-Programming-Language/phobos.git
else
	cd phobos && git pull && cd ..
fi

cd dmd
git checkout stable
echo "Building dmd..."
make -j5 -f posix.mak MODEL=$DARCH RELEASE=1 AUTO_BOOTSTRAP=1

cd ../druntime
git checkout stable
echo "Building druntime..."
make -j5 -f posix.mak MODEL=$DARCH DMD=../dmd/src/dmd RELEASE=1

cd ../phobos
git checkout stable
echo "Building phobos..."
make -j5 -f posix.mak MODEL=$DARCH DMD=../dmd/src/dmd RELEASE=1

echo "Removing old installation..."
rm -rf ../../{bin,lib$DARCH,include/d2}

echo "Installing dmd..."
cd ../dmd
mkdir -p $DPATH/bin
cp src/dmd ../../bin/
echo -e "[Environment]\nDFLAGS=-I$DPATH/include/d2/ -L-L$DPATH/lib$DARCH/" > ../../bin/dmd.conf

echo "Installing druntime..."
cd ../druntime
mkdir -p $DPATH/include/d2
cp -r import/* ../../include/d2/

echo "Installing phobos..."
cd ../phobos
cp -r {*.d,etc,std} ../../include/d2/
mkdir -p $DPATH/lib$DARCH
cp generated/linux/release/$DARCH/libphobos2.* ../../lib$DARCH/
rm ../../lib$DARCH/*.o

echo "Successfully installed to: $DPATH"
cd ../../

read -e -p "Create symlink to dmd? [y/n]: " -i "y" YESNO
if [[ $YESNO = "y" ]]; then
	sudo ln -fs $DPATH/bin/dmd /usr/local/bin/dmd
        sudo ln -fs $DPATH/lib$DARCH/libphobos2.* /usr/lib$DARCH/.
else
	echo "Symlink not added. You might want to add '$DPATH/bin' to your PATH"
fi

read -e -p "Add documentation to man pages? [y/n]: " -i "y" YESNO
if [[ $YESNO = "y" ]]; then
	sudo cp -ri $DPATH/src/dmd/docs/man/* /usr/share/man/
fi

read -e -p "Install dub (The D package manager)? [y/n]: " -i "y" YESNO
if [[ $YESNO = "y" ]]; then
	if [[ ! -d src/dub ]]; then
		git clone https://github.com/D-Programming-Language/dub.git src/dub && cd src/dub
	else
		cd src/dub && git stash && git pull && git stash clear
	fi
	
	DMD=$DPATH/bin/dmd
	source ./build.sh
	cp bin/dub ../../bin/
	cd ../../
	
	read -e -p "Create symlink to dub? [y/n]: " -i "y" YESNO
	if [[ $YESNO = "y" ]]; then
		sudo ln -fs $DPATH/bin/dub /usr/local/bin/dub
	fi
fi

read -e -p "Remove source files? [y/n]: " -i "y" YESNO
if [[ $YESNO = "y" ]]; then
	rm -rf src/
fi

echo "Successfully installed to: $DPATH"
