//
//  AppDelegate.m
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"

#define DEFINE_TARGET  (@"-t")
#define DEFINE_KEY  (@"-k")

#define DEFAULT_KEY (@"message")

@implementation AppDelegate {
    NSString * m_key;
    NSString * m_target;
}

- (void)setArgs:(NSDictionary * )argsDict {
    m_target = [[NSString alloc]initWithString:argsDict[DEFINE_TARGET]];
    
    if (argsDict[DEFINE_KEY]) m_key = [[NSString alloc]initWithString:argsDict[DEFINE_KEY]];
    else m_key = DEFAULT_KEY;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSAssert(m_target, @"-t option required for setting target of notify");

    NSDistributedNotificationCenter * center = [NSDistributedNotificationCenter defaultCenter];
    
    char buffer[BUFSIZ];
    while(fgets(buffer, BUFSIZ, stdin)) {
        NSDictionary * dict = @{m_key: [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding]};
        [center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
    }
    
    exit(0);
}

@end
