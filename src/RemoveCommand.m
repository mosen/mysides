#import "RemoveCommand.h"

@implementation RemoveCommand
- (int)run{
    return 0;
}
//- (int)run {
//    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
//    UInt32 seed;
//    // Grab list snapshot for enumeration
//    NSArray *list = CFBridgingRelease(LSSharedFileListCopySnapshot(sflRef, &seed));
//    
//    if ([[name lowercaseString] isEqualToString: @"all"]) {
//        LSSharedFileListRemoveAllItems(sflRef);
//        CFRelease(sflRef);
//        
//        return 0;
//    } else {
//        printf("neq all\n");
//        
//        for(NSObject *obj in list)  {
//            LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)obj;
//            CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
//            CFURLRef urlRef = NULL;
//            LSSharedFileListItemResolve(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, &urlRef, NULL);
//            
//            // Found item: remove
//            if (CFStringCompare(nameRef, (__bridge CFStringRef)name, 0) == 0) {
//                LSSharedFileListItemRemove(sflRef, sflItemRef);
//                CFRelease(sflRef);
//                printf("Removed sidebar item with name: %s\n", [(NSString *) CFBridgingRelease(nameRef) UTF8String]);
//                return 0;
//            }
//            if (nameRef) CFRelease(nameRef);
//        }
//    }
//    
//    
//    
//    printf("Could not find sidebar item with display name: %s\n", [name UTF8String]);
//    CFRelease(sflRef);
//    return 1;
//}

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

@end
