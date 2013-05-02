//
//  nnotifTests.h
//  nnotifTests
//
//  Created by sassembla on 2013/04/26.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AppDelegate.h"

#define TEST_TARGET     (@"TEST_TARGET_2013/04/28 10:23:16")

#define TEST_MESSAGE    (@"TEST_MESSAGE_2013/04/28 20:51:50")
#define TEST_MESSAGE_HEADER (@"2013/05/02 14:15:13_")

#define TEST_KEY        (@"TEST_KEY_2013/04/28 21:22:47")


#define NNOTIF (@"./app/nnotif")

#define TEST_OUTPUT (@"/Users/sassembla/Desktop/test.txt")


@interface TestDistNotificationSender : NSObject @end
@implementation TestDistNotificationSender

- (void) sendNotification:(NSString * )identity withMessage:(NSString * )message withKey:(NSString * )key {
    
    NSArray * clArray = @[@"-t", identity, @"-k", key, @"-i", message, @"-o", TEST_OUTPUT];
    
    NSTask * task1 = [[NSTask alloc] init];
    [task1 setLaunchPath:NNOTIF];
    [task1 setArguments:clArray];
    [task1 launch];
    [task1 waitUntilExit];
    
    //待つ
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}
@end



@interface nnotifTests : SenTestCase

@end

@implementation nnotifTests {
    AppDelegate * delegate;
}

- (void) tearDown {
    [super tearDown];
}



/**
 コマンドラインだけの処理、あらゆるinが無い。
 */
- (void) testNoInputAsApp {
    
    delegate = [[AppDelegate alloc] initWithArgs:@{
        KEY_TARGET:TEST_TARGET,
         KEY_INPUT:TEST_MESSAGE}
     ];
    
    [delegate run];
    
    //到着を確認する手段が無い
}

/**
 キー指定あり
 */
- (void) testNoInputAsApp_withKey {
    
    delegate = [[AppDelegate alloc] initWithArgs:@{
        KEY_TARGET:TEST_TARGET,
         KEY_INPUT:TEST_MESSAGE,
           KEY_MESSAGEKEY:TEST_KEY
        }
     ];
    
    [delegate run];
    
    //到着を確認する手段が無い
}

/**
 固定内容の出力あり
 定数を出力する
 */
- (void) testOutputAsApp {
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:TEST_MESSAGE,
                                      KEY_OUTPUT:TEST_OUTPUT
                }
                ];
    
    [delegate run];
    
    
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //message :sent to target: key:
    NSString * expected = [[NSString alloc]initWithFormat:@"%@:sent to target:%@ key:%@", TEST_MESSAGE, TEST_TARGET, DEFAULT_MESSAGEKEY];
    STAssertTrue([array containsObject:expected], @"not contained");
}

/**
 固定内容の出力あり
 変化する値を出力する
 */
- (void) testOutputAsApp2 {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:message,
                                      KEY_OUTPUT:TEST_OUTPUT
                }
                ];
    
    [delegate run];
    
    
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    NSString * expected = [[NSString alloc]initWithFormat:@"%@:sent to target:%@ key:%@", message, TEST_TARGET, DEFAULT_MESSAGEKEY];
    STAssertTrue([array containsObject:expected], @"not contained");
}

- (void) testVersionPrint {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                     KEY_VERSION:@"",
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:message,
                                      KEY_OUTPUT:TEST_OUTPUT
                }
                ];
    
    [delegate run];
}

///////コマンドラインとしてのテスト

/**
 固定メッセージ
 */
- (void) testOutput {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:TEST_MESSAGE withKey:TEST_KEY];
    
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    NSString * expected = [[NSString alloc]initWithFormat:@"%@:sent to target:%@ key:%@", TEST_MESSAGE, TEST_TARGET, TEST_KEY];
    STAssertTrue([array containsObject:expected], @"not contained, %@", array);
}

/**
 可変メッセージ
 */
- (void) testOutput2 {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:message withKey:TEST_KEY];
    
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    NSString * expected = [[NSString alloc]initWithFormat:@"%@:sent to target:%@ key:%@", message, TEST_TARGET, TEST_KEY];
    STAssertTrue([array containsObject:expected], @"not contained, %@", array);
}



@end
