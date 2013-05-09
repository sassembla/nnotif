#nnotif
###emit NSDistributedNotification command line tool for Mac
version 0.8.2


###options

set TARGET of Notification

	-t targetNSDistributedNotificationName

the MESSAGEKEY of UserInfo

	-k keyOfUserInfo

	default is "message"

INPUT message directly

	-i message

input FILE as message
	
	-f filePath

OUTPUT log

	-o logOutputFilePath

DONT_SPLIT_MESSAGE_BY_LINE  
normally message will split each line. 2 line text will become 2 notification. 

	--dontsplitbyline

IGNORE_BLANKLINE  
ignore blank line. blank line will not send.

	--ignorebl

IGNORE_TABS                 
ignore tabs in message. e.g. if message contains 4-space-tab, will erase then notify.

	--ignoretabs 4

VERSION     

	-v


###usage

	nnotif -t TARGET -k KEY -o ./nnotif.log -f ./messageFile.txt 
	
with "messageFile.txt"

	Message_
	From_
	Me_
	To_ 
	You
	
will generate 5 NSDistributedNotification-post.

	NSDictionary * dict = @{"KEY":@"Message_From_Me_To_You"};

    [[NSDistributedNotificationCenter defaultCenter]postNotificationName:TARGET object:nil userInfo:dict deliverImmediately:YES];



That's all.