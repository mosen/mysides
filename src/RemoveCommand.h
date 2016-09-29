#import <Foundation/Foundation.h>
#import "BaseCommand.h"

@interface RemoveCommand : NSObject <BaseCommand>

@property NSString *name;

- (int)run;
@end
