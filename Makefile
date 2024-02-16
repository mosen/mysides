# Makefile for myside related tasks
# User configurable variables below

INSTALL_PATH="/usr/local/bin"
PKGTITLE="mysides"
PKGVERSION=1.0.2
PKGID=com.github.mosen.mysides	

#################################################

##Help - Show this help menu
help: 
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

##  build - Create the `mysides` executable using xcode
build: clean 
	xcodebuild -configuration Release

##  clean - Clean up temporary working directories
clean:
	rm -rf build
	rm -rf pkgroot
	rm -rf out

##  pkg - Create a package using pkgbuild
pkg: build
	mkdir -p pkgroot/${INSTALL_PATH}
	mkdir -p out
	cp -R ./build/Release/mysides pkgroot/${INSTALL_PATH}/
	pkgbuild --root pkgroot --identifier ${PKGID} --version ${PKGVERSION} ${SIGN} --ownership recommended out/${PKGTITLE}-${PKGVERSION}.pkg

##  dmg - Wrap the package inside a dmg
dmg: pkg
	rm -f ./mysides*.dmg
	rm -rf /tmp/mysides-build
	mkdir -p /tmp/mysides-build/
	cp ./Readme.md /tmp/mysides-build
	cp -R ./out/${PKGTITLE}-${PKGVERSION}.pkg /tmp/mysides-build
	hdiutil create -srcfolder /tmp/mysides-build -volname "mysides" -format UDZO -o mysides-${PKGVERSION}.dmg
	rm -rf /tmp/mysides-build
