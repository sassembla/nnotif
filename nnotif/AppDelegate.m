//
//  AppDelegate.m
//  nnotif
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {    
    NSString * m_key;
    NSString * m_target;
    
    NSString * m_input;
    NSString * m_output;
    NSFileHandle * m_writeHandle;
}

- (id)initWithArgs:(NSDictionary * )argsDict {
    if (self = [super init]) {
        NSAssert(argsDict[KEY_TARGET], @"CAUTION: no-target defined. please set -t TARGET_OF_NOTIFICATION_IDENTITY_STRING");
        m_target = [[NSString alloc]initWithString:argsDict[KEY_TARGET]];
        
        
        if (argsDict[KEY_MESSAGEKEY]) m_key = [[NSString alloc]initWithString:argsDict[KEY_MESSAGEKEY]];
        else m_key = DEFAULT_MESSAGEKEY;
        
        
        if (argsDict[KEY_INPUT]) m_input = [[NSString alloc]initWithString:argsDict[KEY_INPUT]];
        if (argsDict[KEY_OUTPUT]) {
            [self setOutput:argsDict[KEY_OUTPUT]];
            
            m_output = [[NSString alloc]initWithString:argsDict[KEY_OUTPUT]];
        }
        if (argsDict[KEY_VERSION]) NSLog(@"nnotif version:%@", VERSION);
    }
    return self;
}

- (void) run {
    NSDistributedNotificationCenter * center = [NSDistributedNotificationCenter defaultCenter];
    
    if (m_input) {
        NSDictionary * dict = @{m_key: m_input};
        [center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
        [self writeLogline:m_input];
    } else {
        FILE * input = stdin;
        
        char buffer[BUFSIZ];
        while(fgets(buffer, BUFSIZ, input)) {
            NSString * message = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
            NSDictionary * dict = @{m_key: message};
            
            [center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
            [self writeLogline:message];
        }
    }
    if (false) exit(0);
}

- (void) setOutput:(NSString * )path {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //存在しても何も言わないので、先に存在チェック
    NSFileHandle * readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    //ファイルが既に存在しているか
    if (readHandle) {
        NSLog(@"output-target file already exist, we overwrite.");
    }
    
    bool result = [fileManager createFileAtPath:path contents:nil attributes:nil];
    
    NSAssert1(result, @"the output-file:%@ cannot generate or append", path);
    
    if (result) {
        m_writeHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    }
}

- (void) writeLogline:(NSString * )log {
    if (m_writeHandle) {
        NSString * formattedMessage = [[NSString alloc] initWithFormat:@"%@:sent to target:%@ key:%@\n", log, m_target, m_key];
        [m_writeHandle writeData:[formattedMessage dataUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
