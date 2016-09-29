#import "AddCommand.h"

@implementation AddCommand
- (id)initWithName:(NSString *)name url:(NSURL *)url {
    self = [super init];
    
    self.url = url;
    self.name = name;
    
    return self;
}

- (int)run {
//    LSSharedFileListRef sflRef = LSSharedFileListCreate(kCFAllocatorDefault, kLSSharedFileListFavoriteItems, NULL);
//    LSSharedFileListInsertItemURL(sflRef, kLSSharedFileListItemLast, (__bridge CFStringRef)name, NULL, (__bridge CFURLRef)uri, NULL, NULL);
//    CFRelease(sflRef);
//    printf("Added sidebar item with name: %s\n", [name UTF8String]);
    return 0;
}
@end
