//
//  AppDelegate.h
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFINE_DEBUG    (@"-d")

#define DEFINE_TARGET   (@"-t")

#define DEFINE_KEY      (@"-k")
#define DEFAULT_KEY     (@"message")

#define DEFINE_INPUT    (@"-i")

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (void) setArgs:(NSDictionary * )argsDict;

- (void) run;
- (NSArray * ) result;

- (void) closeWithCode:(int)errorCode;
@end
