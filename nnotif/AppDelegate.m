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
    
    bool m_ignoreBlankLine;
    bool m_dontSplitByLine;
    
    NSNumber * m_ignoreTabsCount;
    
    NSDistributedNotificationCenter * m_center;
    
    long m_writeCount;
}

- (id)initWithArgs:(NSDictionary * )argsDict {
    if (self = [super init]) {
        NSAssert(argsDict[KEY_TARGET], @"CAUTION: no-target defined. please set -t TARGET_OF_NOTIFICATION_IDENTITY_STRING");
        m_target = [[NSString alloc]initWithString:argsDict[KEY_TARGET]];
        
        m_center = [NSDistributedNotificationCenter defaultCenter];
        
        if (argsDict[KEY_MESSAGEKEY]) m_key = [[NSString alloc]initWithString:argsDict[KEY_MESSAGEKEY]];
        else m_key = DEFAULT_MESSAGEKEY;
        
        
        //キーのコンフリクトがある場合退場
        if (argsDict[KEY_INPUT] && argsDict[KEY_FILE]) NSAssert2(false, @"cannot use key %@ with %@", KEY_INPUT, KEY_FILE);
        
        
        if (argsDict[KEY_INPUT]) m_input = [[NSString alloc]initWithString:argsDict[KEY_INPUT]];
        
        if (argsDict[KEY_OUTPUT]) {
            [self setOutput:argsDict[KEY_OUTPUT]];
            
            m_output = [[NSString alloc]initWithString:argsDict[KEY_OUTPUT]];
        }
        
        if (argsDict[KEY_IGNORE_TABS]) {
            m_ignoreTabsCount = [NSNumber numberWithInt:[argsDict[KEY_IGNORE_TABS] intValue]];
        }
        
        if (argsDict[KEY_FILE]) {
            //存在しても何も言わないので、先に存在チェック
            NSFileHandle * readHandle = [NSFileHandle fileHandleForReadingAtPath:argsDict[KEY_FILE]];
            
            //ファイルが存在しているか
            if (readHandle) {
                m_input = [self loadLinesFromFile:readHandle];
            } else {
                NSAssert2(false, @"couldn't find file of %@ :%@", KEY_FILE, argsDict[KEY_FILE]);
            }
        }
        
        m_dontSplitByLine = false;
        if (argsDict[KEY_DONT_SPLIT_MESSAGE_BY_LINE]) m_dontSplitByLine = true;
        
        m_ignoreBlankLine = false;
        if (argsDict[KEY_IGNORE_BLANKLINE]) m_ignoreBlankLine = true;
        
        if (argsDict[KEY_VERSION]) NSLog(@"nnotif version:%@", VERSION);
    }
    return self;
}


- (long) logWriteCount {
    return m_writeCount;
}

- (void) run {
    
    //直通の入力がある場合と無い場合で分岐
    if (m_input) {
        
        [self send:m_input];
        
    } else {
        FILE * input = stdin;
        
        char buffer[BUFSIZ];
        while(fgets(buffer, BUFSIZ, input)) {
            NSString * message = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
            [self send:message];
        }
    }
    if (false) exit(0);
}

/**
 DistNotifへのメッセージの投入
 */
- (void) send:(NSString * )message {

    //タブ消去
    if (m_ignoreTabsCount) {
        NSMutableString * ignoreTargetSpaces = [[NSMutableString alloc]init];
        for (int i = 0; i < [m_ignoreTabsCount intValue]; i++) {
            [ignoreTargetSpaces appendString:DEFINE_SPACE];
        }
        
        message = [message stringByReplacingOccurrencesOfString:ignoreTargetSpaces withString:@""];
    }
    
    //改行でメッセージを分割するかしないか
    if (m_dontSplitByLine) {
        if (m_ignoreBlankLine) {
            NSMutableArray * noBLStrings = [[NSMutableArray alloc]init];
            NSArray * messageArray = [message componentsSeparatedByString:@"\n"];
            for (NSString * ignoreBLMessage in messageArray) {
                if (0 == [ignoreBLMessage length]) continue;
                [noBLStrings addObject:ignoreBLMessage];
            }
            
            if (0 < [noBLStrings count]) {
                NSString * noBLString = [noBLStrings componentsJoinedByString:@"\n"];
                NSDictionary * dict = @{m_key: noBLString};
                [m_center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
                [self writeLogline:noBLString];
            }
        } else {
            NSDictionary * dict = @{m_key: message};
            [m_center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
            [self writeLogline:message];
        }
    } else {
        NSArray * messageArray = [message componentsSeparatedByString:@"\n"];
        
        for (NSString * ignoreBLMessage in messageArray) {
            
            if (m_ignoreBlankLine && 0 == [ignoreBLMessage length]) continue;
            
            NSDictionary * dict = @{m_key: ignoreBLMessage};
            
            [m_center postNotificationName:m_target object:nil userInfo:dict deliverImmediately:YES];
            [self writeLogline:ignoreBLMessage];
        }
    }

}

- (void) setOutput:(NSString * )path {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    //存在しても何も言わないので、先に存在チェック
    NSFileHandle * readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    bool result = false;
    
    //ファイルが既に存在しているか
    if (readHandle) {
        NSLog(@"output-target file already exist, we append.");
        result = true;
    } else {
        result = [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    
    NSAssert1(result, @"the output-file:%@ cannot generate or append", path);
    
    if (result) {
        m_writeHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        m_writeCount = [m_writeHandle seekToEndOfFile];
        [m_writeHandle seekToFileOffset:m_writeCount];
    }
}

/**
 ハンドルから文字列を読み出し文字列を返す
 */
- (NSString * ) loadLinesFromFile:(NSFileHandle * )readHandle {
    NSData * data = [readHandle readDataToEndOfFile];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


- (void) writeLogline:(NSString * )log {
    if (m_writeHandle) {
        NSString * formattedMessage;

        if (0 < m_writeCount) {
            formattedMessage = [[NSString alloc] initWithFormat:@"\nmessage:%@  sent to target:%@ key:%@", log, m_target, m_key];
        } else {
            formattedMessage = [[NSString alloc] initWithFormat:@"message:%@    sent to target:%@ key:%@", log, m_target, m_key];
        }
        
        [m_writeHandle writeData:[formattedMessage dataUsingEncoding:NSUTF8StringEncoding]];
        m_writeCount++;
    }
}

@end
