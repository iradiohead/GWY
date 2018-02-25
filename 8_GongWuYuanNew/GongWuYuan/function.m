//
//  function.m
//  iNotePlus
//
//  Created by 金 柯 on 13-11-27.
//
//

#import "function.h"
#import "GWYAppDelegate.h"
//#import "WHMailActivityItem.h"
//#import "WHMailActivity.h"
SQLITE_API int SQLITE_STDCALL sqlite3_key(
                                          sqlite3 *db,                   /* Database to be rekeyed */
                                          const void *pKey, int nKey     /* The key */
);
NSArray* g_arrayColors = nil;
NSMutableArray* g_arrayColorNames = nil;

int g_nDueRepeat = 0;
int g_applicationIconBadgeNumber = 0;
int command = KDBXNOOP;
BOOL g_isDBlinked = NO;
BOOL g_isFirstTimeOpenApp = NO;

//
int g_usedTimeSeconds = 0;
//========================================================
//-------------------------------------------------------
NSString * getTimeStrFromSec(int Seconds)
{
    int mins = Seconds/60;
    int secs = Seconds%60;
    NSString *minsStr = nil;
    if (mins < 10) {
        minsStr= [[NSString alloc] initWithFormat:@"0%d", mins];
    }
    else
    {
        minsStr = [[NSString alloc] initWithFormat:@"%d", mins];
    }
    __autoreleasing NSString *localStr = [[NSString alloc] initWithFormat:@"%@:%02d", minsStr, secs];
    return localStr;
}
//-------------------------------------------------------
NSString * applicationDocumentsDirectory()
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSString * getLocalPlistFilePath(int bWorkOrLife)
{
    NSString *documentDirectory = applicationDocumentsDirectory();
    NSString *path =nil;
    if(bWorkOrLife == 0)
    {
        path = [documentDirectory stringByAppendingPathComponent:@"NotesList.plist"];
    }
    else if(bWorkOrLife == 1)
    {
        path = [documentDirectory stringByAppendingPathComponent:@"NotesList_per.plist"];
    }
    return path;
}

//------dropbox sync api

BOOL saveTolocalPlist(NSMutableArray * notesArray, int bWorkOrLife)
{
    BOOL bSaveSuccess = [notesArray writeToFile:getLocalPlistFilePath(bWorkOrLife) atomically:YES];
    NSLog(@"saveTolocalPlist-local success=%d", bSaveSuccess);
    return bSaveSuccess;
}

/*BOOL uploadFile(DBFile * dbFile ,int bWorkOrLife)
{
    // NSLog(@"detailview-notearray= %@",self.noteArray);

    if(dbFile) // in case no link in begning, open link before this
    {
        DBError * dbError;
        BOOL bWriteToFile = [dbFile writeContentsOfFile:getLocalPlistFilePath(bWorkOrLife) shouldSteal:NO error:&dbError];
        NSLog(@"uploadFile-bWriteToFile=%d", bWriteToFile);
        if(bWriteToFile == NO )
        {
            NSLog(@"EEEEEEEEEE-uploadfile failed reason = %d", [dbError code]);
            return FALSE;
        }
        return TRUE;
        //    DBError *error;
        //    [self.file update:&error];
    }
    else
    {
        NSLog(@"error-dbfile is nil");
        return FALSE;
    }

}
*/
//global c funtion----------------------------------------
NSString * getTheFunctionTypeByEnum(FunctionTypeEnum enumFuncType)
{
    NSString * str = nil;
    if(enumFuncType == enumTrueSubjectType)
    {
        str = @"国家真题";
    }
    else if(enumFuncType == enumSimulatedSubjectType)
    {
        str = @"地方真题";
    }
    else if(enumFuncType == enumSpecializedTrainingType)
    {
        str = @"专项训练";
    }
    else if(enumFuncType == enumWrongSetType)
    {
        str = @"错题集";
    }
    else if(enumFuncType == enumMyCollectionType)
    {
        str = @"我的题库";
    }
    return str;
    
}


//------------------------------------
void removeNoticationByDueDate(NSString * strID)
{
    UILocalNotification *notificationToCancel = nil;
    for(UILocalNotification * aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        NSString * inFoID = [aNotif.userInfo objectForKey:@"MYNFID"];
        if([inFoID isEqualToString:strID])
        {
            NSLog(@"infoidstr = %@", inFoID);
            notificationToCancel = aNotif;
            break;
        }
    }
    if(notificationToCancel)
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
    }
    else
    {
        NSLog(@"can not find notification from :removeNoticationByDueDate");
    }
}

void setNotification(NSDate * firedate, NSString * alertBody, UILocalNotification * notification)
{
    // [[UIApplication sharedApplication] cancelLocalNotification:];
    // UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification != nil)
    {
        g_applicationIconBadgeNumber++;
        //NSDate *now=[NSDate new];
        notification.fireDate = firedate;//10秒后通知
        // [now release];
        if(g_nDueRepeat == 0)
        {
            NSLog(@"no repeat");
            // notification.repeatInterval = kCFCalendarUnitDay;
        }
        else if(g_nDueRepeat == 1)
        {
            NSLog(@"day repeat");
            notification.repeatInterval = kCFCalendarUnitDay;//循环次数，kCFCalendarUnitWeekday一tian一次
        }
        else if(g_nDueRepeat == 2)
        {
            NSLog(@"week repeat");
            notification.repeatInterval = kCFCalendarUnitWeekday;//循环次数，kCFCalendarUnitWeekday一周一次
        }

        notification.timeZone=[NSTimeZone defaultTimeZone];
        // notification.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;         //应用的红色数字



        notification.soundName = UILocalNotificationDefaultSoundName;//声音，可以换成alarm.soundName = @"myMusic.caf"
        //去掉下面2行就不会弹出提示框
        // notification.alertLaunchImage = @"insterpapaer.png";
        notification.alertBody = alertBody;//提示信息 弹出提示框
        // notification.alertAction = @"open";  //提示框按钮
        notification.hasAction = YES; //是否显示额外的按钮，为no时alertAction消失

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSString * strFireDate = [dateFormat stringFromDate: firedate];
       // [dateFormat release];
        NSDictionary *infoDict = [NSDictionary dictionaryWithObject:strFireDate forKey:@"MYNFID"];
        notification.userInfo = infoDict;
        // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
        //notification.userInfo = infoDict; //添加额外的信息

        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    //[notification release];
}

BOOL isDateSame(NSDate * date1, NSDate* date2)
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSString * strDate1 = [dateFormat stringFromDate: date1];
    NSString * strDate2 = [dateFormat stringFromDate: date2];
   // [dateFormat release];
    if([strDate1 isEqualToString:strDate2])
    {
        return YES;
    }
    else
        return NO;
}

NSUInteger REDeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

BOOL REDeviceIsUIKit7()
{
#ifdef __IPHONE_7_0
    if (REDeviceSystemMajorVersion() >= 7.0)
    {
        return YES;
    }
#endif
    return NO;
}

void setDueRpeat(int repeatType)
{
    g_nDueRepeat = repeatType;
}

//======================================数据库=======================================================
//得到全局的数据库变量
NSString * getDateBasePath()
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"];
}

sqlite3 * openDB()
{
    sqlite3 *database;
    if(sqlite3_open([getDateBasePath() UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        //NSAssert(0, @"Failed to open database");
        return nil;
    }
    NSLog(@"open database");
    sqlite3_key(database, DB_KEY, DB_KEY_LENGTH);
    return database;
}

void closeDB(sqlite3 *database)
{
     int a = sqlite3_close(database);
     NSLog(@"close db %d", a);
}

//testpaperup-1   select 
void getTestPapersByTypeFromTestpaperup(NSMutableArray * exaPaperNameArray, FunctionTypeEnum itemIndex)
{
    sqlite3 *database= openDB();
    //------beginning ios6 book---------------------------------------
    NSString *nameStr = nil;
    NSString *setTimeStr = nil;
    NSString *statusStr = nil;
    NSString *query =nil;
    
    if(itemIndex == enumTrueSubjectType)
    {
        query = [NSString stringWithFormat:@"SELECT tid, name, set_time, status FROM testpaperup where location = '国家' order by time desc"];
        
    }
    else if (itemIndex == enumSimulatedSubjectType)
    {
        query = [NSString stringWithFormat:@"SELECT tid, name, set_time, status FROM testpaperup where location != '国家' order by time desc"];
    }
    //NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where tid = %d", testPaperID];
    //ORDER BY tid
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {   //这个函数将sql文本转换成一个准备语句（prepared statement）对象，同时返回这个对象的指针。
        //这个接口需要一个数据库连接指针以及一个要准备的包含SQL语句的文本。它实际上并不执行（evaluate）这个SQL语句，它仅仅为执行准备这个sql语句
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int tid = sqlite3_column_int(statement, 0);
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            if(rowData)
            {
                nameStr = [[NSString alloc]initWithUTF8String:rowData];
            }
            else
                NSLog(@"rowdata is null");
            
            char *setTimeChar = (char *)sqlite3_column_text(statement, 2);
            if(setTimeChar)
            {
                setTimeStr = [[NSString alloc]initWithUTF8String:setTimeChar];
            }
            else
                NSLog(@"setTimeChar is null");
            
            char *statusChar = (char *)sqlite3_column_text(statement, 3);
            if(statusChar)
            {
                statusStr = [[NSString alloc]initWithUTF8String:statusChar];
                NSLog(@"statusstr = %@",statusStr);
            }
            else
                NSLog(@"statusStr is null");
            
            //create a dictionary, add to array
            NSMutableDictionary *testpaperDic = [[NSMutableDictionary alloc]init];
            NSNumber *tidNumObj = [NSNumber numberWithInteger:tid];
            [testpaperDic setObject:tidNumObj forKey:@"tid"];
            [testpaperDic setValue :nameStr forKey:@"name"];
            [testpaperDic setValue :setTimeStr forKey:@"set_time"];
            [exaPaperNameArray addObject:testpaperDic];
        }
        sqlite3_finalize(statement);
        NSLog(@"exam paper count = %d", exaPaperNameArray.count);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    closeDB(database);
}

//testpaperup
NSString* getUsedTimeFromtestup(int testPaperID)
{
    __autoreleasing NSString * usedTimeNSStr = [[NSString alloc] init];
    sqlite3 *database= openDB();
    NSString *querySQL = [NSString stringWithFormat:@"SELECT used_time from testpaperup where tid = %d", testPaperID];
    
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *usedTimeStr = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            usedTimeNSStr = usedTimeStr;
        }
        else
        {
            NSLog(@"subject id exceed maximum-sqlite3_step(statement) != SQLITE_ROW");
            //popoup alert window to give user a warming that subject id exceed
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return usedTimeNSStr;
}

//problemup-2 select
void getSubjectFromProlemupTable(NSMutableArray * arrLayoutContent, int testPaperID, int subjectId)
{
    sqlite3 *database= openDB();
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * from problemup where tid = %d and pidintest = %d", testPaperID, subjectId];
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSNumber *pid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,PID)];
            NSNumber *pidintest = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,PIDINTEST)];
            NSNumber *tid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,TID)];
         
            NSMutableString *problem_nsStr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,PROBLEM_T)];
            NSMutableString *choice_a_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_A_T)];
            NSMutableString *choice_b_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_B_T)];
            NSMutableString *choice_c_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_C_T)];
            NSMutableString *choice_d_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_D_T)];
            NSMutableString *answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANSWER)];
            NSMutableString *analyse_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANALYSE_T)];
            NSMutableString *problem_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,PROBLEM_P)];
            NSMutableString *choice_a_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_A_P)];
            NSMutableString *choice_b_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_B_P)];
            NSMutableString *choice_c_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_C_P)];
            NSMutableString *choice_d_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_D_P)];
            NSMutableString *analyse_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANALYSE_P)];
            NSMutableString *type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,TYPE)];
            NSMutableString *status_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,STATUS)];
            NSNumber *mid = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, MID)];
            
            NSMutableString *choice_type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_TYPE)];
            NSMutableString *customer_answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CUS_ANSWER)];
            
            NSNumber *favorite = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement, FAVORITE)];
            NSMutableString *meterial_nsstr = [[NSMutableString alloc] init];
            NSMutableString *meterial_addr = [[NSMutableString alloc] init];
            //资料题资料
            if(![mid isEqual: @""])
            {
                NSString *querySQL2 = [NSString stringWithFormat:
                                       @"SELECT * from material where mid = %@", mid];
                const char *query_stmt2 = [querySQL2 UTF8String];
                sqlite3_stmt *statement2;
                if(sqlite3_prepare_v2(database, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        NSString *meterial_nsstr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,1)];
                        NSString *meterial_addr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,2)];
                        [meterial_nsstr appendString:meterial_nsstr_tmp];
                        [meterial_addr appendString:meterial_addr_tmp];
                       // NSLog(@"meterial_nsstr = %@",meterial_nsstr);
                       // NSLog(@"meterial_addr = %@", meterial_addr);
                    }
                    sqlite3_finalize(statement2); //fix bug (lock)
                }
            }
			
			[arrLayoutContent addObject:pid];
			[arrLayoutContent addObject:pidintest];
			[arrLayoutContent addObject:tid];
			[arrLayoutContent addObject:problem_nsStr];
			[arrLayoutContent addObject:choice_a_nsstr];
			[arrLayoutContent addObject:choice_b_nsstr];
			[arrLayoutContent addObject:choice_c_nsstr];
			[arrLayoutContent addObject:choice_d_nsstr];
			[arrLayoutContent addObject:answer_nsstr];
			[arrLayoutContent addObject:analyse_nsstr];
			[arrLayoutContent addObject:problem_addr];
			[arrLayoutContent addObject:choice_a_addr];
			[arrLayoutContent addObject:choice_b_addr];
			[arrLayoutContent addObject:choice_c_addr];
			[arrLayoutContent addObject:choice_d_addr];
			[arrLayoutContent addObject:analyse_addr];
			[arrLayoutContent addObject:type_nsstr];
			[arrLayoutContent addObject:status_nsstr];
			[arrLayoutContent addObject:mid];
			[arrLayoutContent addObject:choice_type_nsstr];
			[arrLayoutContent addObject:customer_answer_nsstr];
			[arrLayoutContent addObject:favorite];
			[arrLayoutContent addObject:meterial_nsstr];
			[arrLayoutContent addObject:meterial_addr];
			
            /*arrLayoutContent = [[NSMutableArray alloc] initWithObjects:
            	pid, pidintest, tid,
            	problem_nsStr,
            	choice_a_nsstr,choice_b_nsstr, choice_c_nsstr,choice_d_nsstr,
            	answer_nsstr,analyse_nsstr,problem_addr ,
            	choice_a_addr,choice_b_addr,choice_c_addr,choice_d_addr,
            	analyse_addr,type_nsstr,
            	status_nsstr,mid,
            	choice_type_nsstr,customer_answer_nsstr,
            	favorite,meterial_nsstr,
            	meterial_addr,
            	nil];*/
        }
        else
        {
            NSLog(@"subject id exceed maximum-sqlite3_step(statement) != SQLITE_ROW");
            //popoup alert window to give user a warming that subject id exceed
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);		
}

//problemup-2 select
void getSubjectByPidAndTypeFromProlemupTable(NSMutableArray *arrLayoutContent, NSString* typeStr, int pid, FunctionTypeEnum enumType)
{
    sqlite3 *database= openDB();
    NSString *querySQL = nil;
    if(enumType == enumSpecializedTrainingType)
    {
    	querySQL = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > %d", typeStr, pid];
    }
    else if(enumType == enumWrongSetType)
    {
    	querySQL = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > %d and status = '错误'", typeStr, pid];
    }
    else if(enumType == enumMyCollectionType)
    {
    	querySQL = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > %d and favorite = 1", typeStr, pid];
//For testing
//        querySQL = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > %d and (problem_p != '' or choice_a_p != '' or choice_b_p != '' or choice_c_p != '' or choice_d_p != '')", typeStr, pid];
    }
    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSNumber *pid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,PID)];
            NSNumber *pidintest = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,PIDINTEST)];
            NSNumber *tid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement,TID)];
            
            NSMutableString *problem_nsStr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,PROBLEM_T)];
            NSMutableString *choice_a_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_A_T)];
            NSMutableString *choice_b_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_B_T)];
            NSMutableString *choice_c_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_C_T)];
            NSMutableString *choice_d_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_D_T)];
            NSMutableString *answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANSWER)];
            NSMutableString *analyse_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANALYSE_T)];
            NSMutableString *problem_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,PROBLEM_P)];
            NSMutableString *choice_a_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_A_P)];
            NSMutableString *choice_b_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_B_P)];
            NSMutableString *choice_c_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_C_P)];
            NSMutableString *choice_d_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_D_P)];
            NSMutableString *analyse_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,ANALYSE_P)];
            NSMutableString *type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,TYPE)];
            NSMutableString *status_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,STATUS)];
            NSNumber *mid = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, MID)];
            
            NSMutableString *choice_type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CHOICE_TYPE)];
            NSMutableString *customer_answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,CUS_ANSWER)];
            
            NSNumber *favorite = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement, FAVORITE)];
            NSMutableString *meterial_nsstr = [[NSMutableString alloc] init];
            NSMutableString *meterial_addr = [[NSMutableString alloc] init];
            //资料题资料
            if(![mid isEqual: @""])
            {
                NSString *querySQL2 = [NSString stringWithFormat:
                                       @"SELECT * from material where mid = %@", mid];
                const char *query_stmt2 = [querySQL2 UTF8String];
                sqlite3_stmt *statement2;
                if(sqlite3_prepare_v2(database, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement2) == SQLITE_ROW)
                    {
                        NSString *meterial_nsstr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,1)];
                        NSString *meterial_addr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,2)];
                        [meterial_nsstr appendString:meterial_nsstr_tmp];
                        [meterial_addr appendString:meterial_addr_tmp];
                        // NSLog(@"meterial_nsstr = %@",meterial_nsstr);
                        // NSLog(@"meterial_addr = %@", meterial_addr);
                    }
                    sqlite3_finalize(statement2); //fix bug (lock)
                }
            }
			
			[arrLayoutContent addObject:pid];
			[arrLayoutContent addObject:pidintest];
			[arrLayoutContent addObject:tid];
			[arrLayoutContent addObject:problem_nsStr];
			[arrLayoutContent addObject:choice_a_nsstr];
			[arrLayoutContent addObject:choice_b_nsstr];
			[arrLayoutContent addObject:choice_c_nsstr];
			[arrLayoutContent addObject:choice_d_nsstr];
			[arrLayoutContent addObject:answer_nsstr];
			[arrLayoutContent addObject:analyse_nsstr];
			[arrLayoutContent addObject:problem_addr];
			[arrLayoutContent addObject:choice_a_addr];
			[arrLayoutContent addObject:choice_b_addr];
			[arrLayoutContent addObject:choice_c_addr];
			[arrLayoutContent addObject:choice_d_addr];
			[arrLayoutContent addObject:analyse_addr];
			[arrLayoutContent addObject:type_nsstr];
			[arrLayoutContent addObject:status_nsstr];
			[arrLayoutContent addObject:mid];
			[arrLayoutContent addObject:choice_type_nsstr];
			[arrLayoutContent addObject:customer_answer_nsstr];
			[arrLayoutContent addObject:favorite];
			[arrLayoutContent addObject:meterial_nsstr];
			[arrLayoutContent addObject:meterial_addr];
        }
        else
        {
            NSLog(@"!!!!!!!!!!!!!!!!from begining!!");
            // pid is too large, try from beginning
            NSString *querySQL2 = nil; // [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > 0", typeStr];
            if(enumType == enumSpecializedTrainingType)
		    {
		    	querySQL2 = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > 0", typeStr];
		    }
		    else if(enumType == enumWrongSetType)
		    {
		    	querySQL2 = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > 0 and status = '错误'", typeStr];
		    }
		    else if(enumType == enumMyCollectionType)
		    {
		    	querySQL2 = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > 0 and favorite = 1", typeStr];
//For testing
//                querySQL2 = [NSString stringWithFormat:@"SELECT * from problemup where type = '%@' and pid > 0 and (problem_p != '' or choice_a_p != '' or choice_b_p != '' or choice_c_p != '' or choice_d_p != '')", typeStr];
		    }
            
            const char *query_stmt2 = [querySQL2 UTF8String];
            sqlite3_stmt *statement2;
            if (sqlite3_prepare_v2(database, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement2) == SQLITE_ROW)
                {
                    NSNumber *pid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement2,PID)];
                    NSNumber *pidintest = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement2,PIDINTEST)];
                    NSNumber *tid = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement2,TID)];
                    
                    NSMutableString *problem_nsStr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,PROBLEM_T)];
                    NSMutableString *choice_a_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_A_T)];
                    NSMutableString *choice_b_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_B_T)];
                    NSMutableString *choice_c_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_C_T)];
                    NSMutableString *choice_d_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_D_T)];
                    NSMutableString *answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,ANSWER)];
                    NSMutableString *analyse_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,ANALYSE_T)];
                    NSMutableString *problem_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,PROBLEM_P)];
                    NSMutableString *choice_a_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_A_P)];
                    NSMutableString *choice_b_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_B_P)];
                    NSMutableString *choice_c_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_C_P)];
                    NSMutableString *choice_d_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_D_P)];
                    NSMutableString *analyse_addr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,ANALYSE_P)];
                    NSMutableString *type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,TYPE)];
                    NSMutableString *status_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,STATUS)];
                    NSNumber *mid = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement2, MID)];
                    
                    NSMutableString *choice_type_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CHOICE_TYPE)];
                    NSMutableString *customer_answer_nsstr = [[NSMutableString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement2,CUS_ANSWER)];
                    
                    NSNumber *favorite = [[NSNumber alloc] initWithInt: sqlite3_column_int(statement2, FAVORITE)];
                    NSMutableString *meterial_nsstr = [[NSMutableString alloc] init];
                    NSMutableString *meterial_addr = [[NSMutableString alloc] init];
                    //资料题资料
                    if(![mid isEqual: @""])
                    {
                        NSString *querySQL3 = [NSString stringWithFormat:
                                               @"SELECT * from material where mid = %@", mid];
                        const char *query_stmt3 = [querySQL3 UTF8String];
                        sqlite3_stmt *statement3;
                        if(sqlite3_prepare_v2(database, query_stmt3, -1, &statement3, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement3) == SQLITE_ROW)
                            {
                                NSString *meterial_nsstr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement3,1)];
                                NSString *meterial_addr_tmp = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement3,2)];
                                [meterial_nsstr appendString:meterial_nsstr_tmp];
                                [meterial_addr appendString:meterial_addr_tmp];
                                // NSLog(@"meterial_nsstr = %@",meterial_nsstr);
                                // NSLog(@"meterial_addr = %@", meterial_addr);
                            }
                            sqlite3_finalize(statement3);
                        }
                    }
                    
                    [arrLayoutContent addObject:pid];
                    [arrLayoutContent addObject:pidintest];
                    [arrLayoutContent addObject:tid];
                    [arrLayoutContent addObject:problem_nsStr];
                    [arrLayoutContent addObject:choice_a_nsstr];
                    [arrLayoutContent addObject:choice_b_nsstr];
                    [arrLayoutContent addObject:choice_c_nsstr];
                    [arrLayoutContent addObject:choice_d_nsstr];
                    [arrLayoutContent addObject:answer_nsstr];
                    [arrLayoutContent addObject:analyse_nsstr];
                    [arrLayoutContent addObject:problem_addr];
                    [arrLayoutContent addObject:choice_a_addr];
                    [arrLayoutContent addObject:choice_b_addr];
                    [arrLayoutContent addObject:choice_c_addr];
                    [arrLayoutContent addObject:choice_d_addr];
                    [arrLayoutContent addObject:analyse_addr];
                    [arrLayoutContent addObject:type_nsstr];
                    [arrLayoutContent addObject:status_nsstr];
                    [arrLayoutContent addObject:mid];
                    [arrLayoutContent addObject:choice_type_nsstr];
                    [arrLayoutContent addObject:customer_answer_nsstr];
                    [arrLayoutContent addObject:favorite];
                    [arrLayoutContent addObject:meterial_nsstr];
                    [arrLayoutContent addObject:meterial_addr];
                }
                sqlite3_finalize(statement2);
            }
            //popoup alert window to give user a warming that subject id exceed
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}

//-----------------------------------------------------------------
//problemup-2 select
int getSubjectCountByTypeFromProlemupTable(NSString* typeStr)
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {//where tid = %d testPaperID
        
        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where type = '%@'", typeStr];
        const char *sqlStatement = [querySQL UTF8String];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"123-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;
}

//problemup-2 select
int getSubjectCountFromProlemupTable()
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {//where tid = %d testPaperID
        
        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup"];
        const char *sqlStatement = [querySQL UTF8String];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"123-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;
}

//problemup-2 select
int getSubjectCountByTestpaperIDFromProblemup(int testPaperID)
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {//where tid = %d testPaperID

        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode

        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where tid = %d", testPaperID];
        const char *sqlStatement = [querySQL UTF8String];

      //  const char* sqlStatement = "SELECT COUNT(*) FROM testpaperup where tid = %d , testPaperID"; //SELECT tid,name FROM testpaperup ORDER BY tid
        sqlite3_stmt *statement;

        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }

        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;
}

//problemup-2 select 
int getSubjectTypeCount(NSString * subjectTypeStr)
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {//where tid = %d testPaperID
        
        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where type = '%@'", subjectTypeStr];
        const char *sqlStatement = [querySQL UTF8String];
        
        //  const char* sqlStatement = "SELECT COUNT(*) FROM testpaperup where tid = %d , testPaperID"; //SELECT tid,name FROM testpaperup ORDER BY tid
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"3-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        
        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;
}

int  getSubjectByTypeAndStatusCount(NSString * subjectTypeStr, NSString * statusStr)
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {//where tid = %d testPaperID
        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where type = '%@' and status = '%@'", subjectTypeStr, statusStr];
        const char *sqlStatement = [querySQL UTF8String];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"getSubjectByTypeAndStatusCount-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;
}

int  getSubjectByTypeAndFavoriteCount(NSString * subjectTypeStr)
{
    int count = 0;
    sqlite3 *database = nil;
    const char * path =[getDateBasePath() UTF8String];
    if (sqlite3_open(path, &database) == SQLITE_OK)
    {
        sqlite3_key(database, DB_KEY, DB_KEY_LENGTH); //decode
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM problemup where type = '%@' and favorite = 1", subjectTypeStr];
        const char *sqlStatement = [querySQL UTF8String];
        sqlite3_stmt *statement;
        if( sqlite3_prepare_v2(database, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            if( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"getSubjectByTypeAndStatusCount-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        closeDB(database);
    }
    return count;	
}

//---------------------------------------------------------------------------------
//testpaperup-1 problemup-2
void initializeDatebase(int testPaperID)
{
	sqlite3 *database= openDB();
    NSString *querySQL = [NSString stringWithFormat:
                          @"update testpaperup set status = '未完成', used_time = '' where tid = %d", testPaperID];

    const char *query_stmt = [querySQL UTF8String];
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"成功插入数据!");
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }

    //-----init the problemup table--------
	NSString * querySQL2 = [NSString stringWithFormat:
		@"update problemup set customer_answer = '', status ='未完成', favorite = 0  where pid in (select pid from problemup where tid = %d)",testPaperID];
    const char *query_stmt2 = [querySQL2 UTF8String];
    sqlite3_stmt *statement2;
    if(sqlite3_prepare_v2(database, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(statement2) == SQLITE_DONE)
        {
            NSLog(@"成功update数据!");
        }
        sqlite3_finalize(statement2);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    // debug for testing whether udpate the record
    /*  NSString *querySQL3 = [NSString stringWithFormat:@"SELECT status FROM problemup where pid = 10"];
    const char *sqlStatement3 = [querySQL3 UTF8String];
    sqlite3_stmt *statement3;

    if( sqlite3_prepare_v2(database, sqlStatement3, -1, &statement3, NULL) == SQLITE_OK )
    {
        //Loop through all the returned rows (should be just one)
        if( sqlite3_step(statement3) == SQLITE_ROW )
        {

            char *statusChar = (char *)sqlite3_column_text(statement3, 0);
            if(statusChar)
            {
                NSString* statusStr = [[NSString alloc]initWithUTF8String:statusChar];
                NSLog(@"statusstr = %@",statusStr);
            }
            else
                NSLog(@"statusStr is null");

        }
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }*/

    //------------------
    closeDB(database);
}

int largestFinishedSubjectID(int testPaperID)
{
	sqlite3 *database= openDB();
	NSString *querySQL = [NSString stringWithFormat:@"SELECT customer_answer FROM problemup where tid = %d order by pidintest", testPaperID];
    const char *sqlStatement = [querySQL UTF8String];

    NSString *customer_answerStr = nil;
    NSMutableArray *cAnswerArray =[[NSMutableArray alloc] init];

    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, sqlStatement, -1, &statement, nil) == SQLITE_OK)
    {   //这个函数将sql文本转换成一个准备语句（prepared statement）对象，同时返回这个对象的指针。
        //这个接口需要一个数据库连接指针以及一个要准备的包含SQL语句的文本。它实际上并不执行（evaluate）这个SQL语句，它仅仅为执行准备这个sql语句
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *rowData = (char *)sqlite3_column_text(statement, 0);
            if( rowData )
            {
                customer_answerStr = [[NSString alloc]initWithUTF8String:rowData];
            }
            else
                NSLog(@"rowdata is null");

            [cAnswerArray addObject:customer_answerStr];
        }
        sqlite3_finalize(statement);
        NSLog(@"cAnswerArraycont = %lu", cAnswerArray.count);
    }
    int i =0;
    //judge whether is @"" in customer answer
    for(i = cAnswerArray.count-1; i >= 0; i--)
    {
    	NSString * tempAnswer = cAnswerArray[i];
    	if(![tempAnswer isEqualToString:@""])
    	{
    		break;
    	}
    }
    closeDB(database);
    return i+1+1;
}

void updateStatusInProblemTB(NSString *status, NSNumber *problemID)
{
    sqlite3 *database= openDB();

    NSLog(@"__problem id_updateStatusInProblemTB = %@",problemID);
    //----init the testpapaerup table------
    //NSString *querySQL = [NSString stringWithFormat:
    //                    @"INSERT OR REPLACE INTO testpaperup (tid, status, used_time)""VALUES(?,?,?);"];
    NSLog(@"status are %@", status);
    NSString *querySQL = [NSString stringWithFormat:
                          @"update problemup set status = '%@' where pid = %@", status, problemID];

    const char *query_stmt = [querySQL UTF8String];

    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        //  sqlite3_bind_int(statement, 1, testPaperID);
        //  sqlite3_bind_text(statement, 2, [@"未完成" UTF8String], -1, NULL);
        //  sqlite3_bind_text(statement, 3, [@"" UTF8String], -1, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"成功插入数据!");
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    closeDB(database);
}
//problemup
void updateCustomerAnswer(NSMutableString *customerAnswer, NSNumber *problemID)
{
    sqlite3 *database= openDB();
    NSLog(@"__problem id_updateCustomerAnswer = %@",problemID);

    //----init the testpapaerup table------
    //NSString *querySQL = [NSString stringWithFormat:
    //                    @"INSERT OR REPLACE INTO testpaperup (tid, status, used_time)""VALUES(?,?,?);"];
    NSLog(@"customerAnswer = %@",customerAnswer);
    NSString *querySQL = [NSString stringWithFormat:
                          @"update problemup set customer_answer = '%@' where pid = %@", customerAnswer, problemID];
    
    
    NSLog(@"querySQL = %@",querySQL);
    const char *query_stmt = [querySQL UTF8String];

    NSLog(@"query_stmt = %s",query_stmt);
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        //  sqlite3_bind_int(statement, 1, testPaperID);
        //  sqlite3_bind_text(statement, 2, [@"未完成" UTF8String], -1, NULL);
        //  sqlite3_bind_text(statement, 3, [@"" UTF8String], -1, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"成功插入数据!");
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog( @"-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    closeDB(database);
}

//problemup    update
void updateFavoriteToProblemupTB(NSNumber *problemID, NSNumber* Favorite)
{
	sqlite3 *database= openDB();
    NSString *querySQL = [NSString stringWithFormat:
                          @"update problemup set favorite = %@ where pid = %@", Favorite, problemID];

    const char *query_stmt = [querySQL UTF8String];

    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"成功插入数据!");
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v. Error is:  %s", sqlite3_errmsg(database) );
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog( @"-Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }
    closeDB(database);
}
