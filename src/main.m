// portions (l) copyleft 2011 Adam Strzelecki nanoant.com
// sidebar modification commands added by github/mosen

// Some interesting IDs:
//   com.apple.LSSharedFileList.SpecialItemIdentifier
//   com.apple.LSSharedFileList.TemplateSystemSelector

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "Command.h"

extern CFTypeRef LSSharedFileListItemCopyAliasData(LSSharedFileListItemRef inItem);
extern int _IconRefIsTemplate(IconRef iconRef);

extern CFStringRef kLSSharedFileListSpecialItemIdentifier;
extern CFStringRef kLSSharedFileListItemTargetName;
extern CFStringRef kLSSharedFileListItemManaged;

// I am so smart, this symbol isn't exposed by LaunchServices framework, but I get it anyhow with help of "nm" ;)
#define kLSSharedFileListItemTemplateSystemSelector (CFStringRef)((char *)kLSSharedFileListItemTargetName + (3 * 0x40))
#define kLSSharedFileListItemClass (CFStringRef)((char *)kLSSharedFileListItemBeforeFirst + (3 * 0x40))

// Find shared file list item by its display name
// Not responsible for allocating or releasing the list reference.
//id find_itemname(LSSharedFileListRef sflRef, NSString *name)
//{
//    UInt32 seed;
//    NSArray *list = CFBridgingRelease(LSSharedFileListCopySnapshot(sflRef, &seed));
//    
//    for(NSObject *obj in list) {
//        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)obj;
//        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
//        if (CFStringCompare(nameRef, (__bridge CFStringRef)name, 0) == 0) {
//            if (nameRef) CFRelease(nameRef);
//            return (__bridge id)(sflItemRef);
//        }
//    if (nameRef) CFRelease(nameRef);
//    }
//    return nil;
//}


int main (int argc, char const *argv[])
{
    id cmd = [Command commandWithArgv:*argv argc:argc];
    
    int status = [cmd run];
    
    return status;
}
