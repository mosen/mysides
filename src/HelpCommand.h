#import <Foundation/Foundation.h>

@interface HelpCommand : NSObject
@property NSString *arg0;

- (id)initWithArgv:(const char *)argv argc:(int)argc;
@end
