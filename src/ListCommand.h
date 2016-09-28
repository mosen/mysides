#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "Command.h"

@interface ListCommand : NSObject
@property NSArray *argv;
- (id)initWithArgv:(NSArray *)argv;
- (int)run;
@end
