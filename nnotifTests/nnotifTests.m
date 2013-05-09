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
#define TEST_MESSAGE_HEADER2    (@"2013/05/04 13:36:08")

#define TEST_KEY        (@"TEST_KEY_2013/04/28 21:22:47")


#define NNOTIF (@"./app/nnotif")

#define TEST_FILEPATH_SINGLELINE    (@"./testresource/inputFileSingleLine.txt")
#define TEST_FILEPATH_MULTILINE     (@"./testresource/inputFileMultiLine.txt")
#define TEST_FILEPATH_MULTILINE_2TABS    (@"./testresource/inputFileMultiLine_with2Tabs.txt")
#define TEST_FILEPATH_MULTILINE_4TABS    (@"./testresource/inputFileMultiLine_with4Tabs.txt")

#define TEST_2TAB   (@"2")
#define TEST_4TAB   (@"4")


#define TEST_OUTPUT (@"./test.log")


@interface TestDistNotificationSender : NSObject @end
@implementation TestDistNotificationSender

- (void) sendNotification:(NSString * )identity withMessage:(NSString * )message withKey:(NSString * )key withOptions:(NSArray * )options {

    NSArray * clArray;
    if (message) clArray = @[@"-t", identity, @"-k", key, @"-i", message];
    else clArray = @[@"-t", identity, @"-k", key];
    
    NSArray * totalParamArray = [clArray arrayByAddingObjectsFromArray:options];
    
    NSTask * task1 = [[NSTask alloc] init];
    [task1 setLaunchPath:NNOTIF];
    [task1 setArguments:totalParamArray];
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

/**
 空行の無視
 */
- (void) testIgnoreBlankLineAsApp {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:message,
                                      KEY_OUTPUT:TEST_OUTPUT,
                            KEY_IGNORE_BLANKLINE:@""
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
    
    STAssertFalse([array containsObject:@""], @"not contained");
}


/**
 改行でのメッセージ分割の無視
 */
- (void) testDontSplitMessageByLineAsApp {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n%@%@", TEST_MESSAGE_HEADER, [[NSDate alloc] init], TEST_MESSAGE_HEADER2, [[NSDate alloc] init]];
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:message,
                                      KEY_OUTPUT:TEST_OUTPUT,
                  KEY_DONT_SPLIT_MESSAGE_BY_LINE:@""
                }
                ];
    
    [delegate run];
    
    //送信カウントは一つ
    STAssertTrue([delegate logWriteCount] == 1, @"not match, %d", [delegate logWriteCount]);
}

/**
 改行でのメッセージ分割の無視中に空の行を送った場合 & ignoreBlankLine
 */
- (void) testDontSplitMessageByLineWithBlankLineWithIgnoreBlankLineAsApp {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                       KEY_INPUT:message,
                                      KEY_OUTPUT:TEST_OUTPUT,
                            KEY_IGNORE_BLANKLINE:@"",
                  KEY_DONT_SPLIT_MESSAGE_BY_LINE:@""
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
    
    //空行が含まれず
    STAssertFalse([array containsObject:@""], @"contained");
    
    //logが1つだけあるはず
    STAssertTrue([array count] == 1, @"not match, %d", [array count]);
}

/**
 特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 */
- (void) testInputFromFile_SingleLineAsApp {
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                        KEY_FILE:TEST_FILEPATH_SINGLELINE,
                                      KEY_OUTPUT:TEST_OUTPUT
                }
                ];
    
    [delegate run];

    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行が無く、logが1つだけあるはず
    STAssertTrue([array count] == 1, @"not match, %d", [array count]);
}

/**
 複数行ある
 特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 */
- (void) testInputFromFile_MultiLineAsApp {
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                        KEY_FILE:TEST_FILEPATH_MULTILINE,
                                      KEY_OUTPUT:TEST_OUTPUT
                }
                ];
    
    [delegate run];
    
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行分だけメッセージが流れる
    STAssertTrue([array count] == 5, @"not match, %d", [array count]);
}

/**
 複数行ある特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 改行そのままメッセージ化のオプション付き
 */
- (void) testInputFromFile_MultiLineWithDontSplitMessageByLineAsApp {
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                        KEY_FILE:TEST_FILEPATH_MULTILINE,
                                      KEY_OUTPUT:TEST_OUTPUT,
                  KEY_DONT_SPLIT_MESSAGE_BY_LINE:@""
                }
                ];
    
    [delegate run];
    
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行が無視されるので、1行分logが出る、が、中身が改行含みなので5
    STAssertTrue([array count] == 5, @"not match, %d", [array count]);
    
    //書き込み回数は1
    STAssertTrue([delegate logWriteCount] == 1, @"not match, %d", [delegate logWriteCount]);
}

/**
 タブが含まれているファイル/メッセージ読み込み
 タブはspaceの連続だったり、文字コードだったりすると思うので、入力されたものを使う。
 入力された物を1単位として、入力の中からそのコードを抹消する。
 */
- (void) testIgnore2TabsAsApp {
    //2spaceをタブとして扱う
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                        KEY_FILE:TEST_FILEPATH_MULTILINE_2TABS,
                                      KEY_OUTPUT:TEST_OUTPUT,
                                 KEY_IGNORE_TABS:TEST_2TAB//2spaces
                }
                ];
    
    [delegate run];
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //3行あり、
    STAssertTrue([array count] == 3, @"not match, %d", [array count]);
    
    for (NSString * line in array) {
        STAssertFalse([line hasPrefix:@"  "], @"contains");
    }
}

- (void) testIgnore4TabsAsApp {
    //4spaceをタブとして扱う
    delegate = [[AppDelegate alloc] initWithArgs:@{
                                      KEY_TARGET:TEST_TARGET,
                                        KEY_FILE:TEST_FILEPATH_MULTILINE_4TABS,
                                      KEY_OUTPUT:TEST_OUTPUT,
                                 KEY_IGNORE_TABS:TEST_4TAB//4spaces
                }
                ];
    
    [delegate run];
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //3行あり、
    STAssertTrue([array count] == 3, @"not match, %d", [array count]);
    
    
    for (NSString * line in array) {
        STAssertFalse([line hasPrefix:@"    "], @"contains");
    }
}




///////////////////////////////////////////////////////////////////
///////コマンドラインとしてのテスト
///////////////////////////////////////////////////////////////////



/**
 固定メッセージ
 */
- (void) testOutput {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:TEST_MESSAGE withKey:TEST_KEY withOptions:@[KEY_OUTPUT, TEST_OUTPUT]];
    
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
    [sender sendNotification:TEST_TARGET withMessage:message withKey:TEST_KEY withOptions:@[KEY_OUTPUT, TEST_OUTPUT]];
    
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



/**
 空行の無視
 */
- (void) testIgnoreBlankLine {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
    
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:message withKey:TEST_KEY withOptions:@[KEY_OUTPUT, TEST_OUTPUT, KEY_IGNORE_BLANKLINE]];
    
    
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    STAssertFalse([array containsObject:@""], @"not contained");
}


/**
 改行でのメッセージ分割の無視
 */
- (void) testDontSplitMessageByLine {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n%@%@", TEST_MESSAGE_HEADER, [[NSDate alloc] init], TEST_MESSAGE_HEADER2, [[NSDate alloc] init]];
    
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:message withKey:TEST_KEY withOptions:@[KEY_OUTPUT, TEST_OUTPUT, KEY_DONT_SPLIT_MESSAGE_BY_LINE]];
    
    
//    //送信カウントは一つ
//    STAssertTrue([delegate logWriteCount] == 1, @"not match, %d", [delegate logWriteCount]);
    //送信カウントはみれない。ので、確認が出来ない。ファイルを見て、行数でも確認できない。
}

/**
 改行でのメッセージ分割の無視中に空の行を送った場合 & ignoreBlankLine
 */
- (void) testDontSplitMessageByLineWithBlankLineWithIgnoreBlankLine {
    NSString * message = [[NSString alloc]initWithFormat:@"%@%@\n", TEST_MESSAGE_HEADER, [[NSDate alloc] init]];
   
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:message withKey:TEST_KEY withOptions:@[KEY_OUTPUT, TEST_OUTPUT, KEY_IGNORE_BLANKLINE, KEY_DONT_SPLIT_MESSAGE_BY_LINE]];
    
   
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //空行が含まれず
    STAssertFalse([array containsObject:@""], @"contained");
    
    //logが1つだけあるはず
    STAssertTrue([array count] == 1, @"not match, %d", [array count]);
}


/**
 特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 */
- (void) testInputFromFile_SingleLine {
    
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:nil withKey:TEST_KEY withOptions:
     @[KEY_OUTPUT, TEST_OUTPUT,
     KEY_FILE, TEST_FILEPATH_SINGLELINE]];
    
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行が無く、logが1つだけあるはず
    STAssertTrue([array count] == 1, @"not match, %d", [array count]);
}

/**
 複数行ある
 特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 */
- (void) testInputFromFile_MultiLine {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:nil withKey:TEST_KEY withOptions:
     @[KEY_OUTPUT, TEST_OUTPUT,
     KEY_FILE, TEST_FILEPATH_MULTILINE]];
    
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行分だけメッセージが流れる
    STAssertTrue([array count] == 5, @"not match, %d", [array count]);
}

/**
 複数行ある特定ファイルを読み込み、その内容をメッセージとして一発で飛ばす
 改行そのままメッセージ化のオプション付き
 */
- (void) testInputFromFile_MultiLineWithDontSplitMessageByLine {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:nil withKey:TEST_KEY withOptions:
     @[KEY_OUTPUT, TEST_OUTPUT,
     KEY_FILE, TEST_FILEPATH_MULTILINE, KEY_DONT_SPLIT_MESSAGE_BY_LINE]];
    
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //改行が無視されるので、1行分logが出る、が、中身が改行含みなので5
    STAssertTrue([array count] == 5, @"not match, %d", [array count]);
    
    //書き込み回数は確かめようが無い
}


/**
 タブが含まれているファイル/メッセージ読み込み
 タブはspaceの連続だったり、文字コードだったりすると思うので、入力されたものを使う。
 入力された物を1単位として、入力の中からそのコードを抹消する。
 */
- (void) testIgnore2Tabs {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:nil withKey:TEST_KEY withOptions:
     @[KEY_OUTPUT, TEST_OUTPUT,
     KEY_FILE, TEST_FILEPATH_MULTILINE_2TABS,
     KEY_IGNORE_TABS, TEST_2TAB]];
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //3行あり、
    STAssertTrue([array count] == 3, @"not match, %d", [array count]);
    
    for (NSString * line in array) {
        STAssertFalse([line hasPrefix:@"  "], @"contains");
    }
}

- (void) testIgnore4Tabs {
    TestDistNotificationSender * sender = [[TestDistNotificationSender alloc] init];
    [sender sendNotification:TEST_TARGET withMessage:nil withKey:TEST_KEY withOptions:
     @[KEY_OUTPUT, TEST_OUTPUT,
     KEY_FILE, TEST_FILEPATH_MULTILINE_4TABS,
     KEY_IGNORE_TABS, TEST_4TAB
     ]];
    
    //メッセージが飛べば、logに出る筈
    //起動している筈なので、ファイルが書き出されている筈
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:TEST_OUTPUT];
    STAssertNotNil(handle, @"handle is nil");
    
    NSData * data = [handle readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //logがあるはず
    NSArray * array = [string componentsSeparatedByString:@"\n"];
    
    //3行あり、
    STAssertTrue([array count] == 3, @"not match, %d", [array count]);
    
    
    for (NSString * line in array) {
        STAssertFalse([line hasPrefix:@"    "], @"contains");
    }
}

@end
