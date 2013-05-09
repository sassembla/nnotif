#nnotif
###Emit NSDistributedNotification from command line.
command line tool for Mac  
version 0.8.2

###SAMPLE
####emit NSDistributedNotification with pipe

	//send output of tail to TARGET receiver.
	tail -f something.log | nnotif -t TARGET
	
####emit NSDistributedNotification standalone

	//send "MyMessage" to TARGET receiver.
	nnotif -t TARGET -i MyMessage


###OPTIONS

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
ignore tabs in message. e.g. if message contains 4-space-tab, will be erased then notify.

	--ignoretabs 4

VERSION     

	-v


##USAGE

	nnotif -t TARGET -k KEY -o ./nnotif.log -f ./messageFile.txt 
	
with "messageFile.txt"

	Message_
	From_
	Me_
	To_ 
	You
	
will generate only 1 NSDistributedNotification-post. same as below in Obj-C

	NSDictionary * dict = @{"KEY":@"Message_From_Me_To_You"};

    [[NSDistributedNotificationCenter defaultCenter]postNotificationName:TARGET object:nil userInfo:dict deliverImmediately:YES];

if you want to emit NSDistributedNotification each line,
use --dontsplitbyline option.

	nnotif -t TARGET -k KEY -o ./nnotif.log -f ./messageFile.txt --dontsplitbyline

will generate 5 NSDistributedNotification-post.



##INSTALL
* 1.clone this repository.
* 2.right-click nnotif.app > show package
* 3.get nnotif from /Contents/MacOS/nnotif

That's all.