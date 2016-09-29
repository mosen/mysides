#import <XCTest/XCTest.h>
#import "SFLDListCommand.h"

@interface SFLDTests : XCTestCase

@end

@implementation SFLDTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharedFileListDaemonConnection {
    SFLDListCommand *cmd = [[SFLDListCommand alloc] init];
    int status = [cmd run];
}

@end
