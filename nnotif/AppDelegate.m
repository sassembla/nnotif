//
//  AppDelegate.m
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {
    bool m_debug;
    
    NSString * m_key;
    NSString * m_target;
    
    NSString *  m_input;
    NSMutableArray * m_result;
}

- (void)setArgs:(NSDictionary * )argsDict {
    m_debug = false;
    if (argsDict[DEFINE_DEBUG]) {
        m_debug = true;
        m_result = [[NSMutableArray alloc]init];
    }
    
    if (argsDict[DEFINE_TARGET]) {
        m_target = [[NSString alloc]initWithString:argsDict[DEFINE_TARGET]];
    } else {
        NSLog(@"CAUTION: no-target defined. please set -t TARGET_OF_NOTIFICATION_IDENTITY_STRING");
    }
    
    if (argsDict[DEFINE_KEY]) m_key = [[NSString alloc]initWithString:argsDict[DEFINE_KEY]];
    else m_key = DEFAULT_KEY;
    
    
    if (argsDict[DEFINE_INPUT]) {
        m_input = [[NSString alloc]initWithString:argsDict[DEFINE_INPUT]];
    }
}

/**
 appとして動作する場合
 */
- (void)applicationDidFinishLaunching:(NSNotification * )aNotification
{
    if (m_target) [self run];
    [self closeWithCode:0];
}

- (void) run {
    NSDistributedNotificationCenter * center = [NSDistributedNotificationCenter defaultCenter];
    
    if (m_input) {
        NSDictionary * dict = @{m_key: m_input};
        if (m_debug) [m_result addObject:dict];
        [center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
    } else {
        FILE * input = stdin;
        
        char buffer[BUFSIZ];
        while(fgets(buffer, BUFSIZ, input)) {
            NSString * message = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
            NSDictionary * dict = @{m_key: message};
            
            if (m_debug) [m_result addObject:dict];
            [center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
        }

    }
}

- (NSArray * ) result {
    return m_result;
}


- (void) closeWithCode:(int)errorCode {
    exit(errorCode);
}

@end
