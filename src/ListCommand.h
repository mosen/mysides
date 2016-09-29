#import <Foundation/Foundation.h>
#import <CoreServices/CoreServices.h>
#import "BaseCommand.h"

@interface ListCommand : NSObject <BaseCommand>
@property NSArray *argv;
- (id)initWithArgv:(NSArray *)argv;
- (int)run;
@end
