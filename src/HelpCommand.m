#import "HelpCommand.h"

@implementation HelpCommand
+ (id<BaseCommand>)withArgv:(NSArray *)argv {
    HelpCommand *cmd = [[HelpCommand alloc] init];
    cmd.arg0 = [argv objectAtIndex:0];
    
    return cmd;
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
