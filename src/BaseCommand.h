#ifndef BaseCommand_h
#define BaseCommand_h
@protocol BaseCommand
@required
+(id<BaseCommand>)withArgv:(NSArray *)argv;
-(int)run;
@optional
@end

#endif /* BaseCommand_h */
