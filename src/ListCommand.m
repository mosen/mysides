#import "ListCommand.h"

@implementation ListCommand
- (id)initWithArgv:(NSArray *)argv {
    self = [super init];
    self.argv = argv;
    
    return self;
}

- (int)run {
    CFStringRef fileListType;
    
    if ([self.argv count] > 2) {
        NSString *listType = [self.argv objectAtIndex:2];
        
        if ([listType isEqualToString:@"servers"]) {
            fileListType = kLSSharedFileListRecentServerItems;
        } else if ([listType isEqualToString:@"volumes"]) {
            fileListType = kLSSharedFileListFavoriteVolumes;
        } else if ([listType isEqualToString:@"login"]) {
            fileListType = kLSSharedFileListSessionLoginItems;
        } else if ([listType isEqualToString:@"documents"]) {
            fileListType = kLSSharedFileListRecentDocumentItems;
        } else if ([listType isEqualToString:@"applications"]) {
            fileListType = kLSSharedFileListRecentApplicationItems;
        } else {
            printf("That list type was unrecognised");
            return 1;
        }
    } else {
        fileListType = kLSSharedFileListFavoriteItems;
    }

    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, fileListType, NULL);
    UInt32 seed;
    
    if(!sflRef) {
        printf("No list!");
        return 1;
    }
    
    // Grab list snapshot for enumeration
    NSArray *list = CFBridgingRelease(LSSharedFileListCopySnapshot(sflRef, &seed));
    
    for(NSObject *object in list) {
        LSSharedFileListItemRef sflItemRef = (__bridge LSSharedFileListItemRef)object;
        CFStringRef nameRef = LSSharedFileListItemCopyDisplayName(sflItemRef);
        CFURLRef urlRef = NULL;

        urlRef = LSSharedFileListItemCopyResolvedURL(sflItemRef, kLSSharedFileListNoUserInteraction | kLSSharedFileListDoNotMountVolumes, NULL);
        if (urlRef == NULL) break;
        
        printf("%s -> %s\n",
               [(NSString *) CFBridgingRelease(nameRef) UTF8String],
               [(NSString *) CFBridgingRelease(CFURLGetString(urlRef)) UTF8String]);
    }
    
    CFRelease(sflRef);

    return 0;
}
@end
