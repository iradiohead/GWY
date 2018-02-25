//
//  GWYAppDelegate.m
//  GongWuYuan
//
//  Created by 金 柯 on 13-10-29.
//  Copyright (c) 2013年 金 柯. All rights reserved.
//

#import "GWYAppDelegate.h"
#import "GWYViewController.h"
@import GoogleMobileAds;
@implementation GWYAppDelegate
//@synthesize database=_database;

//#define DBNAME database.db


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if(RK_IS_IPHONE)
    {
        self.viewController = [[GWYViewController alloc] initWithNibName:@"GWYViewController" bundle:nil];
    }
    else
    {
        self.viewController = [[GWYViewController alloc] initWithNibName:@"GWYViewController_ipad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self createEditableCopyOfDatabaseIfNeeded];
    // Initialize Google Mobile Ads SDK
    // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
    [GADMobileAds configureWithApplicationID:ADMOB_APP_ID];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*-(NSString *)getDBPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"];
}

-(sqlite3 *)database
{
	sqlite3 *database;
    if(sqlite3_open([[self getDBPath] UTF8String], &database) != SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
        return nil;
    }
    NSLog(@"open database");
    return database;
}

-(void)openDB
{
    sqlite3_open([[self getDBPath] UTF8String], &database);
}

-(void)closeDB
{
    sqlite3_close(database);
}
*/

#pragma mark sqlite　DB methods
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)createEditableCopyOfDatabaseIfNeeded
{
	// First, test for existence - we don't want to wipe out a user's DB
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDirectory = [self applicationDocumentsDirectory];
    
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"database.db"];
	BOOL dbexits = [fileManager fileExistsAtPath:writableDBPath];
	if (!dbexits)
    {
		// The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath =nil;
        defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"database.db"];
		
		NSError *error;
		BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success)
        {
            NSLog(@"%@",[error localizedDescription] );
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
}

#pragma mark rotate methods
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (RK_IS_IPAD)
    {
        return UIInterfaceOrientationMaskPortrait;
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}



@end
