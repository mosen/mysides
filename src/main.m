// portions (l) copyleft 2011 Adam Strzelecki nanoant.com
// sidebar modification commands added by github/mosen

// Some interesting IDs:
//   com.apple.LSSharedFileList.SpecialItemIdentifier
//   com.apple.LSSharedFileList.TemplateSystemSelector

#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>

extern CFTypeRef LSSharedFileListItemCopyAliasData(LSSharedFileListItemRef inItem);
extern int _IconRefIsTemplate(IconRef iconRef);

extern CFStringRef kLSSharedFileListSpecialItemIdentifier;
extern CFStringRef kLSSharedFileListItemTargetName;
extern CFStringRef kLSSharedFileListItemManaged;
// I am so smart, this symbol isn't exposed by LaunchServices framework, but I get it anyhow with help of "nm" ;)
#define kLSSharedFileListItemTemplateSystemSelector (CFStringRef)((char *)kLSSharedFileListItemTargetName + (3 * 0x40))
#define kLSSharedFileListItemClass (CFStringRef)((char *)kLSSharedFileListItemBeforeFirst + (3 * 0x40))

void print_help(char const *arg0)
{
    printf("Usage:\n");
    printf("\t%s list\t- list sidebar items", arg0);
    printf("\t%s add <name> <uri> [after]\t- append a sidebar item to the end of the list, or after the given name\n", arg0);
    //printf("\t%s insert <name> <uri> [before]\t- insert a sidebar item at the start of the list, or before the given name\n", arg0);
    printf("\t%s remove <name>\t- remove a sidebar item\n", arg0);
}

// Find shared file list item by its display name
// Not responsible for allocating or releasing the list reference.
id find_itemname(LSSharedFileListRef sflRef, NSString *name)
{
    UInt32 seed;
    NSArray *list = (__bridge NSArray *)LSSharedFileListCopySnapshot(sflRef, &seed);
    
    for(NSObject *obj in list) {
        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)obj;
        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
        if (CFStringCompare(nameRef, (__bridge CFStringRef)name, 0) == 0) {
            return (__bridge id)(sflItemRef);
        }
    }
    
    return nil;
}

// Append an item to the sidebar
// Return the new index of the item added.
int sidebar_add(NSString *name, NSURL *uri, id after)
{
    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
    LSSharedFileListInsertItemURL(sflRef, kLSSharedFileListItemLast, (__bridge CFStringRef)name, NULL, (__bridge CFURLRef)uri, NULL, NULL);
    CFRelease(sflRef);
    printf("Added sidebar item with name: %s\n", [name UTF8String]);
    return 1;
}

// Remove named item from the sidebar
int sidebar_remove(NSString *name, NSURL *uri)
{
    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
    UInt32 seed;
    // Grab list snapshot for enumeration
    NSArray *list = (__bridge NSArray *)LSSharedFileListCopySnapshot(sflRef, &seed);
    
    for(NSObject *obj in list)  {
        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)obj;
        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
        CFURLRef urlRef = NULL;
        LSSharedFileListItemResolve(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &urlRef, NULL);
        
        // Found item: remove
        if (CFStringCompare(nameRef, (__bridge CFStringRef)name, 0) == 0) {
            LSSharedFileListItemRemove(sflRef, sflItemRef);
            CFRelease(sflRef);
            printf("Removed sidebar item with name: %s\n", [(NSString *) CFBridgingRelease(nameRef) UTF8String]);
            return 0;
        }
        
    }
    
    printf("Could not find sidebar item with display name: %s", [name UTF8String]);
    CFRelease(sflRef);
    return 1;
}

int sidebar_insert(NSString *name, NSURL *uri, id before)
{
    return 1;
}

void sidebar_list()
{
    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
    UInt32 seed;
    
    if(!sflRef) {
        printf("No list!");
        return;
    }
    
    // Grab list snapshot for enumeration
    NSArray *list = (__bridge NSArray *)LSSharedFileListCopySnapshot(sflRef, &seed);
    
    for(NSObject *object in list) {
        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)object;
        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
        CFURLRef urlRef = NULL;
        LSSharedFileListItemResolve(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &urlRef, NULL);
//        UInt32 itemId = LSSharedFileListItemGetID(sflItemRef);
        
        printf("%s -> %s\n",
               [(NSString *) CFBridgingRelease(nameRef) UTF8String],
               [(NSString *) CFBridgingRelease(CFURLGetString(urlRef)) UTF8String]);
        if(urlRef)  CFRelease(urlRef);
        if(nameRef) CFRelease(nameRef);
        
//        CFStringRef props[] = {
//            // kLSSharedFileListItemClass,
//            kLSSharedFileListItemTemplateSystemSelector,
//            kLSSharedFileListSpecialItemIdentifier,
//            kLSSharedFileListItemManaged,
//        };
//        int i;
//        for(i = 0; i < sizeof(props)/sizeof(*props); i++) {
//            CFTypeRef propRef = LSSharedFileListItemCopyProperty(sflItemRef, props[i]);
//            printf("\t%p: %s = %s (%s)\n", props[i],
//                   [(NSString *) CFBridgingRelease(props[i]) UTF8String],
//                   propRef,
//                   propRef ? [(id)CFBridgingRelease(CFCopyTypeIDDescription(CFGetTypeID(propRef))) UTF8String] : nil
//                   );
//            if(propRef) CFRelease(propRef);
//        }
        
    }
    
    CFRelease(sflRef);
}

int main (int argc, char const *argv[])
{
    if(argc >= 2) {
        if (strcmp(argv[1], "list") == 0) {
            sidebar_list();
            return 0;
        }
        
        if (strcmp(argv[1], "add") == 0) {
            NSString *name = [NSString stringWithUTF8String:argv[2]];
            NSURL *uri = [NSURL URLWithString:[NSString stringWithUTF8String:argv[3]]];
            
            return sidebar_add(name, uri, nil);
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
