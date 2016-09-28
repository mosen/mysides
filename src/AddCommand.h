//
//  AddCommand.h
//  mysides
//
//  Created by Eamon Brosnan on 26/09/2016.
//  Copyright © 2016 com.github.mosen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddCommand : NSObject
@property NSURL *url;
@property NSString *name;

- (int)run;
@end
