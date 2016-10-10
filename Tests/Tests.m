#import <XCTest/XCTest.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testList {
    sidebar_list();
}

- (void)testRemoveAll {
    int status = sidebar_remove("all", [NSURL URLWithString:@"file:///"]);
}

- (void)testAdd {
    int status = sidebar_add("Test", [NSURL URLWithString:@"file:///tmp"]);
}

@end
