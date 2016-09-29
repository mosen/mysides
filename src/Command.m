#import "Command.h"
#import "HelpCommand.h"
#import "ListCommand.h"

@implementation Command
+ (id<BaseCommand>)commandWithArgv:(char const *)argv argc:(int)argc {
    if (argc < 2) {
        return [HelpCommand withArgv:@[]];
    }
    
    NSInteger count = 0;
    NSMutableArray *argvArr = [[NSMutableArray alloc] initWithCapacity:argc];
    while (count++ < argc) {
        NSString *stringArgument = [NSString stringWithCString: &argv[count]];
        [argvArr addObject:stringArgument];
    }
    
    if (strcmp(&argv[1], "list") == 0) {
        return [[ListCommand alloc] initWithArgv: argvArr];
    } else if (strcmp(&argv[1], "remove") == 0) {
        return [[RemoveCommand alloc] initWithArgv: argvArr];
    } else if (strcmp(&argv[1], "add") == 0) {
        return [[AddCommand alloc] initWithArgv: argvArr];
    } else {
        return [HelpCommand withArgv:@[]];
    }
    
    return nil;
}
@end
