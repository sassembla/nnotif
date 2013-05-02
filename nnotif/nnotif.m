//
//  nnotif.m
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "nnotif.h"
#import "AppDelegate.h"

#define KEY_PERFIX  (@"-")


@implementation nnotif

int NSApplicationMain(int argc, const char *argv[]) {
    @autoreleasepool {
        NSMutableArray * keyAndValueStrArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < argc; i++) {
            
            [keyAndValueStrArray addObject:[NSString stringWithUTF8String:argv[i]]];
            
        }
        
        NSMutableDictionary * argsDict = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < [keyAndValueStrArray count]; i++) {
            NSString * keyOrValue = keyAndValueStrArray[i];
            if ([keyOrValue hasPrefix:KEY_PERFIX]) {
                NSString * key = keyOrValue;
                
                // get value
                if (i + 1 < [keyAndValueStrArray count]) {
                    NSString * value = keyAndValueStrArray[i + 1];
                    if ([value hasPrefix:KEY_PERFIX]) {
                        [argsDict setValue:@"" forKey:key];
                    } else {
                        [argsDict setValue:value forKey:key];
                    }
                }
                else {
                    NSString * value = @"";
                    [argsDict setValue:value forKey:key];
                }
            }
        }
        
        if (argsDict[KEY_TARGET]) {
            AppDelegate * delegate = [[AppDelegate alloc] initWithArgs:argsDict];
            [delegate run];
        } else {
            AppDelegate * delegate = [[AppDelegate alloc]init];
            NSApplication * application = [NSApplication sharedApplication];
            [application setDelegate:delegate];
            
            [NSApp run];
        }
        
        return 0;
    }
    
}
@end
