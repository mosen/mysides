// portions (l) copyleft 2011 Adam Strzelecki nanoant.com
// sidebar modification commands added by github/mosen

// Some interesting IDs:
//   com.apple.LSSharedFileList.SpecialItemIdentifier
//   com.apple.LSSharedFileList.TemplateSystemSelector

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "Command.h"
#import "BaseCommand.h"

extern CFTypeRef LSSharedFileListItemCopyAliasData(LSSharedFileListItemRef inItem);
extern int _IconRefIsTemplate(IconRef iconRef);

extern CFStringRef kLSSharedFileListSpecialItemIdentifier;
extern CFStringRef kLSSharedFileListItemTargetName;
extern CFStringRef kLSSharedFileListItemManaged;

// I am so smart, this symbol isn't exposed by LaunchServices framework, but I get it anyhow with help of "nm" ;)
#define kLSSharedFileListItemTemplateSystemSelector (CFStringRef)((char *)kLSSharedFileListItemTargetName + (3 * 0x40))
#define kLSSharedFileListItemClass (CFStringRef)((char *)kLSSharedFileListItemBeforeFirst + (3 * 0x40))



int main (int argc, char const *argv[])
{
    id<BaseCommand> cmd = [Command commandWithArgv:*argv argc:argc];
    
    int status = [cmd run];
    return status;
}
