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
    NSLog(@"Usage:\n");
    NSLog(@"\t%s list\t- list sidebar items", arg0);
    NSLog(@"\t%s add <name> <uri> [after]\t- append a sidebar item to the end of the list, or after the given name\n", arg0);
    NSLog(@"\t%s insert <name> <uri> [before]\t- insert a sidebar item at the start of the list, or before the given name\n", arg0);
    NSLog(@"\t%s remove <name>\t- remove a sidebar item\n", arg0);
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
            NSLog(@"Removed sidebar item with name: %@", nameRef);
            return 0;
        }
        
    }
    
    NSLog(@"Could not find sidebar item with display name: %@", name);
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
        NSLog(@"No list!");
        return;
    }
    
    // Grab list snapshot for enumeration
    NSArray *list = (__bridge NSArray *)LSSharedFileListCopySnapshot(sflRef, &seed);
    
    for(NSObject *object in list) {
        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)object;
        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
        CFURLRef urlRef = NULL;
        LSSharedFileListItemResolve(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &urlRef, NULL);
        UInt32 itemId = LSSharedFileListItemGetID(sflItemRef);

        NSLog(@"[%u] %@ -> %@", itemId, (__bridge id)nameRef, (__bridge id)urlRef);
        if(urlRef)  CFRelease(urlRef);
        if(nameRef) CFRelease(nameRef);

        CFStringRef props[] = {
            // kLSSharedFileListItemClass,
            kLSSharedFileListItemTemplateSystemSelector,
            kLSSharedFileListSpecialItemIdentifier,
            kLSSharedFileListItemManaged,
        };
        int i;
        for(i = 0; i < sizeof(props)/sizeof(*props); i++) {
            CFTypeRef propRef = LSSharedFileListItemCopyProperty(sflItemRef, props[i]);
            NSLog(@" %p: %@ = %@ (%@)", props[i], (__bridge id)props[i], (__bridge id)propRef, propRef ? (id)CFBridgingRelease(CFCopyTypeIDDescription(CFGetTypeID(propRef))) : nil);
            if(propRef) CFRelease(propRef);
        }
            
    }
    
    CFRelease(sflRef);
}

int main (int argc, char const *argv[])
{
    

//    CFStringRef desiredNameRef = NULL;
    
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
                NSLog(@"No name supplied to remove!\n");
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
    
//    if(argc >= 2) {
//        desiredNameRef = CFStringCreateWithCStringNoCopy(kCFAllocatorDefault, argv[1], kCFStringEncodingUTF8, NULL);
//        if(argc >= 3) {
//            type = atol(argv[2]);
//            if(!type && strlen(argv[2]) != 4) {
//                NSLog(@"type must be 4 characters");
//                return 254;
//            }
//            if(!type) type = (argv[2][3] << 0) + (argv[2][2] << 8) + (argv[2][1] << 16) + (argv[2][0] << 24);
//        }
//    }
    

    
   
    
//    LSSharedFileListItemRef sflItemBeforeRef = (LSSharedFileListItemRef)kLSSharedFileListItemBeforeFirst;
    
//    for(NSObject *object in list) {
//        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)object;
//        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
//        CFURLRef urlRef = NULL;
//        LSSharedFileListItemResolve(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &urlRef, NULL);
//        
//        if(!desiredNameRef) {
//            UInt32 itemId = LSSharedFileListItemGetID(sflItemRef);
//            
//            NSLog(@"[%u] %@ -> %@", itemId, (__bridge id)nameRef, (__bridge id)urlRef);
//            if(urlRef)  CFRelease(urlRef);
//            if(nameRef) CFRelease(nameRef);
//            
//            CFStringRef props[] = {
//                // kLSSharedFileListItemClass,
//                kLSSharedFileListItemTemplateSystemSelector,
//                kLSSharedFileListSpecialItemIdentifier,
//                kLSSharedFileListItemManaged,
//            };
//            int i;
//            for(i = 0; i < sizeof(props)/sizeof(*props); i++) {
//                CFTypeRef propRef = LSSharedFileListItemCopyProperty(sflItemRef, props[i]);
//                NSLog(@" %p: %@ = %@ (%@)", props[i], (__bridge id)props[i], (__bridge id)propRef, propRef ? (id)CFBridgingRelease(CFCopyTypeIDDescription(CFGetTypeID(propRef))) : nil);
//                if(propRef) CFRelease(propRef);
//            }
//        } else {
//            if(CFEqual(nameRef, desiredNameRef)) {
//                if(!type) {
//                    NSLog(@"Cleared: %@", nameRef);
//                    LSSharedFileListInsertItemURL(sflRef, sflItemBeforeRef, nameRef, NULL, urlRef, NULL, (__bridge CFArrayRef)[NSArray arrayWithObject:(__bridge id)kLSSharedFileListItemTemplateSystemSelector]);
//                } else {
//                    LSSharedFileListItemSetProperty(sflItemRef, kLSSharedFileListItemTemplateSystemSelector, CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &type));
//                }
//            }
//        }
//        sflItemBeforeRef = sflItemRef;
//    }
//    
//    CFRelease(sflRef);
    return 0;
}
