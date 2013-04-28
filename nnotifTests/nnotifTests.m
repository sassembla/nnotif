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
#define TEST_KEY        (@"TEST_KEY_2013/04/28 21:22:47")
@interface nnotifTests : SenTestCase

@end

@implementation nnotifTests {
    AppDelegate * delegate;
}

- (void) setUp {
    [super setUp];
    delegate = [[AppDelegate alloc] init];
}

- (void) tearDown {
    [super tearDown];
}



/**
 コマンドラインだけの処理、あらゆるinが無い。
 */
- (void) testNoInput {
    [delegate setArgs:@{
        DEFINE_TARGET:TEST_TARGET,
         DEFINE_DEBUG:@"",
         DEFINE_INPUT:TEST_MESSAGE}
     ];
    
    [delegate run];
    
    //デバッグありなので、resultが取得できるはず
    NSArray * result = [delegate result];
    
    //resultには、TEST_MESSAGEが入っている筈
    STAssertNotNil(result, @"result is nil");
    STAssertTrue([result count] == 1, @"not match, %d",[result count]);
    STAssertTrue([[result objectAtIndex:0][DEFAULT_KEY] isEqualToString:TEST_MESSAGE], @"not match");
}

- (void) testNoInput_withKey {
    [delegate setArgs:@{
        DEFINE_TARGET:TEST_TARGET,
         DEFINE_DEBUG:@"",
         DEFINE_INPUT:TEST_MESSAGE,
           DEFINE_KEY:TEST_KEY
        }
     ];
    
    [delegate run];
    
    //デバッグありなので、resultが取得できるはず
    NSArray * result = [delegate result];
    
    //resultには、TEST_MESSAGEが入っている筈
    STAssertNotNil(result, @"result is nil");
    STAssertTrue([result count] == 1, @"not match, %d",[result count]);
    STAssertTrue([[result objectAtIndex:0][TEST_KEY] isEqualToString:TEST_MESSAGE], @"not match");
}


// 入力を受けるためには、全体をNSTaskで組んで実行するとかしないといけない。これは面倒くさい。

/**
 stdin
 標準入力を受ける。
 適当な文字列データを送り込んでみる。
 */
//- (void) testReceiveStdinShort {
//    NSArray * clArray = @[@"-d", @"-t", TEST_TARGET];
//    NSPipe * s_in = [[NSPipe alloc] init];
//    NSPipe * s_out = [[NSPipe alloc] init];
//
//    NSTask * task1 = [[NSTask alloc] init];
//    [task1 setLaunchPath:TEST_NNOTIF_BINPATH];
//    [task1 setArguments:clArray];
//    [task1 setStandardInput:s_in];
//    [task1 setStandardOutput:s_out];
//
//    
//    
//    //データを送り込める。これで、outputがどうなるか、っていうのが判るか。いつ発動するんだろうコレ、、あとstdin扱いになるのかな、、、
//    [[[task1 standardInput] fileHandleForWriting] writeData:[@"test" dataUsingEncoding:NSUTF8StringEncoding]];
//
//    [task1 launch];
//    [task1 waitUntilExit];
    
    
//    NSTask * task = [NSTask a]よく考えたらテストできない、、NSTask全開だね。
//    [delegate setArgs:@{
//     @"-d":@"",
//     @"-t":TEST_TARGET
//     }];
//    
//    //結果が出ている筈。
//    [delegate run];
//    
//    NSArray * result = [delegate result];
//    STFail(@"Unit tests are not implemented yet in nnotifTests");
//}






@end
