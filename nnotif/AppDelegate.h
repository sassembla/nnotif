//
//  AppDelegate.h
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#define KEY_TARGET      (@"-t")

#define KEY_MESSAGEKEY  (@"-k")
#define DEFAULT_MESSAGEKEY  (@"message")

#define KEY_INPUT       (@"-i")
#define KEY_FILE        (@"-f")

#define KEY_OUTPUT      (@"-o")

#define KEY_DONT_SPLIT_MESSAGE_BY_LINE  (@"--dontsplitbyline")
#define KEY_IGNORE_BLANKLINE            (@"--ignorebl")
#define KEY_IGNORE_TABS                 (@"--ignoretabs")

#define DEFINE_SPACE    (@" ")

#define KEY_VERSION     (@"-v")


#define VERSION         (@"0.8.2")


@interface AppDelegate : NSObject <NSApplicationDelegate>

- (id)initWithArgs:(NSDictionary * )argsDict;

- (long) logWriteCount;

- (void) run;

@end
