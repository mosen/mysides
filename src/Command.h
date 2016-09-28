#import <Foundation/Foundation.h>
#import "HelpCommand.h"
#import "ListCommand.h"

@interface Command : NSObject
+ (id)commandWithArgv:(char const *)argv argc:(int)argc;
@end
