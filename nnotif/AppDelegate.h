//
//  AppDelegate.h
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define KEY_TARGET   (@"-t")

#define KEY_MESSAGEKEY      (@"-k")
#define DEFAULT_MESSAGEKEY     (@"message")

#define KEY_INPUT    (@"-i")
#define KEY_OUTPUT   (@"-o")

#define KEY_VERSION  (@"-v")

#define VERSION     (@"0.8.0")


@interface AppDelegate : NSObject <NSApplicationDelegate>

- (id)initWithArgs:(NSDictionary * )argsDict;

- (void) run;

@end
