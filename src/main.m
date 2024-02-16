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
void ClearSidebarItems();
void AddSidebarItem(NSString *itemName, NSURL *itemURL);
void RemoveSidebarItem(NSString *itemName);
LSSharedFileListItemRef FindItemByName(NSArray *items, NSString *itemToFind);
NSArray* ValidateSideBarList(LSSharedFileListRef sharedFileList);
BOOL ValidArguments(int argc, const char *argv[]);
void PrintUsage(char const *arg0);


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

// Remove all items from the sidebar
void ClearSidebarItems() {
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListFavoriteItems, NULL);
  LSSharedFileListRemoveAllItems(sharedFileList);
  CFRelease(sharedFileList);
  printf("Removed all sidebar items. \n");
}

// Append an item to the sidebar
void AddSidebarItem(NSString *itemName, NSURL *itemURL) {
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListFavoriteItems, NULL);
  LSSharedFileListInsertItemURL(sharedFileList, kLSSharedFileListItemLast, (__bridge CFStringRef)itemName, NULL, (__bridge CFURLRef)itemURL, NULL, NULL);
  CFRelease(sharedFileList);
  printf("Added sidebar item: %s\n", [itemName UTF8String]);
}

// Remove item from the sidebar
void RemoveSidebarItem(NSString *itemName) {
  LSSharedFileListRef sharedFileList = LSSharedFileListCreate(NULL, kLSSharedFileListFavoriteItems, NULL);
  NSArray *items = ValidateSideBarList(sharedFileList);
  LSSharedFileListItemRef itemToRemove = FindItemByName(items, itemName);
  
  if (itemToRemove != NULL) {
    LSSharedFileListItemRemove(sharedFileList, itemToRemove);
    CFRelease(sharedFileList);
    printf("Removed Sidebar item with name: %s\n", [itemName UTF8String]);
        } else {
    printf("Could not find sidebar item with name: %s\n", [itemName UTF8String]);
    CFRelease(sharedFileList);
  }
}

// Find an item in the list by name
LSSharedFileListItemRef FindItemByName(NSArray *items, NSString *itemToFind) {
  for (id item in items) {
    LSSharedFileListItemRef sharedFileListRef = (__bridge LSSharedFileListItemRef)item;
    CFStringRef itemNameCFRef = LSSharedFileListItemCopyDisplayName(sharedFileListRef);
    NSString *itemName = (__bridge_transfer NSString *)itemNameCFRef;
    if ([itemName isEqualToString:itemToFind]) {
      return sharedFileListRef;
    }
  }
  
  return NULL;
}

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

// Validate the command line arguments
BOOL ValidArguments(int argc, const char *argv[]) {
  if (argc < 2) {
    printf("Error: Missing command.\n");
    PrintUsage(argv[0]);
    return NO;
  }
  
  NSString *command = [NSString stringWithUTF8String:argv[1]];
  if ([command isEqualToString:@"add"] && (argc < 4)) {
    printf("Error: Missing folder name or folder path.\nUsage: mysides add my_folder file:///Users/my_username/my_folder\n");
    return NO;
  }
        
  if ([command isEqualToString:@"remove"] && (argc < 3)) {
    printf("Error: Missing folder name.\nUsage: mysides remove my_folder\n");
    return NO;
            }
  
  return YES;
}

// Print the usage
void PrintUsage(char const *arg0) {
  printf("Usage: %s list|add <name> <uri>|remove <name>\n\n", arg0);
  printf("\t list - Lists sidebar items\n");
  printf("\t add <folder_name> <folder_path> - Appends a sidebar item to the end of the list\n");
  printf("\t remove <folder_name> - Removes a sidebar item\n");
  printf("\t clear - Removes all sidebar items\n");
  printf("\t version - display the version\n\n");
}
