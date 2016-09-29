#import <Foundation/Foundation.h>
#import "BaseCommand.h"

@interface HelpCommand : NSObject <BaseCommand>
@property NSString *arg0;
+(id<BaseCommand>)withArgv:(NSArray *)argv;
-(int)run;
@end
