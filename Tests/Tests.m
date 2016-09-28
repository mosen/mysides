#import <XCTest/XCTest.h>
#import "SFLDListCommand.h"
#import "ListCommand.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {

    [super tearDown];
}

// Default: favorites
- (void)testListCommand {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list"]];
    [cmd run];
}

// Currently connected servers
- (void)testListServers {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list", @"servers"]];
    [cmd run];
}

- (void)testListVolumes {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list", @"volumes"]];
    [cmd run];
}

// Login items - Completely deprecated now
- (void)testListLogin {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list", @"login"]];
    [cmd run];
}

// Recent Documents
- (void)testListDocuments {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list", @"documents"]];
    [cmd run];
}

// Recent Applications
- (void)testListApplications {
    ListCommand *cmd = [[ListCommand alloc] initWithArgv:@[@"mysides", @"list", @"applications"]];
    [cmd run];
}

// XPC: com.apple.sharedfilelistd tests

- (void)testSFLDListCommand {
    SFLDListCommand *cmd = [[SFLDListCommand alloc] init];
    int x = [cmd run];
}

@end
