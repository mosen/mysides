#import "HelpCommand.h"

@implementation HelpCommand
- (id)initWithArgv:(const char *)argv argc:(int)argc {
    self = [super init];
    _arg0 = [NSString stringWithCString:&argv[0] encoding:NSASCIIStringEncoding];

    return self;
}

- (int)run {
    printf("Usage: %s list|add <name> <uri>|remove <name>\n", [_arg0 cStringUsingEncoding:NSASCIIStringEncoding]);
    printf("\n");
    printf("\t list - list sidebar items\n");
    printf("\t add - append a sidebar item to the end of the list\n");
    printf("\t remove - remove a sidebar item\n");
    printf("\n");
    
    return 1;
}
@end
