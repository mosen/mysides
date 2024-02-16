// portions (l) copyleft 2011 Adam Strzelecki nanoant.com
// sidebar modification commands added by github/mosen

// Some interesting IDs:
//   com.apple.LSSharedFileList.SpecialItemIdentifier
//   com.apple.LSSharedFileList.TemplateSystemSelector

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

extern CFTypeRef LSSharedFileListItemCopyAliasData(LSSharedFileListItemRef inItem);
extern int _IconRefIsTemplate(IconRef iconRef);

// Function declarations
void ListSidebarItems();
NSArray* ValidateSideBarList(LSSharedFileListRef sharedFileList);
    
    LSSharedFileListInsertItemURL(sflRef, kLSSharedFileListItemLast, (__bridge CFStringRef)name, NULL, (__bridge CFURLRef)uri, NULL, NULL);
    CFRelease(sflRef);
    printf("Added sidebar item with name: %s\n", [name UTF8String]);
    return 0;
}

// Remove named item from the sidebar
int sidebar_remove(NSString *name, NSURL *uri)
{
    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
    if (!sflRef) {
        printf("Unable to create sidebar list, LSSharedFileListCreate() fails.");
        return 2;
    }
    
    UInt32 seed;
    // Grab list snapshot for enumeration
    NSArray *list = CFBridgingRelease(LSSharedFileListCopySnapshot(sflRef, &seed));
    
    if ([[name lowercaseString] isEqualToString: @"all"]) {
        LSSharedFileListRemoveAllItems(sflRef);
        CFRelease(sflRef);
        
        return 0;
    } else {

// Show all items in the sidebar
void ListSidebarItems() {
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListFavoriteItems, NULL);
  NSArray *items = ValidateSideBarList(sharedFileList);
  
  for (id item in items) {
    LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)item;
    CFStringRef displayName = LSSharedFileListItemCopyDisplayName(itemRef);
    CFURLRef itemURL = LSSharedFileListItemCopyResolvedURL(itemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, NULL);
    printf("%s -> %s\n",
           [(NSString *)CFBridgingRelease(displayName) UTF8String],
           itemURL ? [(NSString *)CFBridgingRelease(CFURLGetString(itemURL)) UTF8String] : "NOT FOUND");
    if (itemURL) CFRelease(itemURL);
  }
  
  CFRelease(sharedFileList);
}
        } else {

// Validate the sidebar list exists and is not empty
NSArray* ValidateSideBarList(LSSharedFileListRef sharedFileList) {
  NSArray *items = CFBridgingRelease(LSSharedFileListCopySnapshot(sharedFileList, NULL));
  if (items.count == 0) {
    // The list is empty
    printf("The Sidebar is empty.\n");
    exit(1); // exit with error
  }
  return items;
}
            }
            NSString *name = [NSString stringWithUTF8String:argv[2]];
            NSURL *uri = [NSURL URLWithString:[NSString stringWithUTF8String:argv[3]]];
            
            return sidebar_insert(name, uri, nil);
        }
        
        if (strcmp(argv[1], "remove") == 0) {
            if (strlen(argv[2]) == 0) {
                printf("No name supplied to remove!\n");
                return 1;
            }
        NSString *name = [NSString stringWithUTF8String:argv[2]];
        NSURL *uri = [NSURL URLWithString:@"file:///"]; // temporary not used
        return sidebar_remove(name, uri);
        }
    } else {
        print_help(argv[0]);
        return 1;
    }
    return 0;
}
