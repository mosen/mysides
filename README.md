# mysides #

A simple CLI tool for Finder sidebar modification.

**NOTE**: I clobbered this together with very little experience in C/CoreFoundation, as a result the code may be horrible.

## Usage ##

List sidebar favorites items:

    mysides list

Append a new item to the end of a list:

    mysides add example file:///Users/Shared/example

Insert a new item at the start of the list:

    mysides insert example file:///Users/Shared/example

Remove the item (by name):

    mysides remove example

## Credits ##

portions (l) copyleft 2011 Adam Strzelecki nanoant.com
without whom I would not know much about the LSSharedFileList API.