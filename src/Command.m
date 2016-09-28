#import "Command.h"
#import "ListCommand.h"

@implementation Command
+ (id)commandWithArgv:(char const *)argv argc:(int)argc {
    if (argc < 2) {
        return [[HelpCommand alloc] init];
    }
    
    NSInteger count = 0;
    NSMutableArray *argvArr = [[NSMutableArray alloc] initWithCapacity:argc];
    while (count++ < argc) {
        NSString *stringArgument = [NSString stringWithCString: &argv[count]];
        [argvArr addObject:stringArgument];
    }
    
    if (strcmp(&argv[1], "list") == 0) {
        
        return [[ListCommand alloc] init];
        
    } else if (strcmp(&argv[1], "remove") == 0) {
     
    } else if (strcmp(&argv[1], "add") == 0) {
        
        
    } else {
        return [[HelpCommand alloc] init];
    }
    
    return nil;
}
@end
