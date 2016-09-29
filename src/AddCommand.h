#import <Foundation/Foundation.h>
#import "BaseCommand.h"

@interface AddCommand : NSObject <BaseCommand>
@property NSURL *url;
@property NSString *name;

- (int)run;
@end
