#import <Foundation/Foundation.h>
#import "BaseCommand.h"
#import "HelpCommand.h"
#import "ListCommand.h"



@interface Command : NSObject
+ (id<BaseCommand>)commandWithArgv:(char const *)argv argc:(int)argc;
@end

