//
//  GWYAppDelegate.h
//  GongWuYuan
//
//  Created by 金 柯 on 13-10-29.
//  Copyright (c) 2013年 金 柯. All rights reserved.
#import <UIKit/UIKit.h>
#import "sqlite3.h"

@class GWYViewController;

@interface GWYAppDelegate : UIResponder <UIApplicationDelegate>
{
  //  sqlite3 *database;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GWYViewController *viewController;
//@property (nonatomic)sqlite3 *database;


@end
