
#import "SFLDListCommand.h"

@implementation SFLDListCommand
- (int) run {
    NSLog(@"Setting up XPC connection");
    
    NSXPCConnection *conn = [[NSXPCConnection alloc] initWithMachServiceName:@"com.apple.coreservices.sharedfilelistd.xpc" options:NSXPCConnectionPrivileged];
    NSXPCInterface *sflSvc = [NSXPCInterface interfaceWithProtocol: @protocol(SFLServiceProtocol)];
    NSSet *incomingClasses = [NSSet setWithObjects:[NSArray class], [SFLListChange class], [NSError class], nil];
    [sflSvc setClasses:incomingClasses forSelector:@selector(applyChange:toListWithIdentifier:reply:) argumentIndex:0 ofReply:YES];
    conn.remoteObjectInterface = sflSvc;
    
    conn.invalidationHandler = ^(void){
        NSLog(@"Connection was invalidated");
    };
    
    NSURL *url = [NSURL URLWithString:@"smb://crap"];
    SFLListItem *item = [[SFLListItem alloc] initWithName:@"crap" URL:url properties:nil];
    
    
    SFLListChange *change = [SFLListChange changeWithType:1 item:item];
    
    NSLog(@"%hhd", [SFLListChange supportsSecureCoding]);
    NSLog(@"%@", [change description]);
    
    NSLog(@"Attempting to apply change to XPC service");
    [[conn remoteObjectProxy] applyChange:change toListWithIdentifier:@"com.apple.LSSharedFileList.FavoriteServers" reply:^(NSArray *items, NSError *err) {

        NSLog(@"%@", err);

        NSLog(@"reply");
        for (SFLListChange *changeItem in items) {
            NSLog(@"%@", [changeItem description]);
        }
    }];
    
    [conn resume];
    return 1;
    }
@end
