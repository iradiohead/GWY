//
//  SubjectViewController.h
//  GongWuYuan
//
//  Created by 金 柯 on 13-12-9.
//  Copyright (c) 2013年 金 柯. All rights reserved.

#import <UIKit/UIKit.h>

@interface SubjectViewController2 : UIViewController
{
}


//for subjecttypeinfoviewcontroller
//@property (nonatomic ) SubjectViewEnum enType;
@property (nonatomic ) FunctionTypeEnum enumSubjectFunctionType;
@property (nonatomic, strong) NSString *mySubjectTypeStr;
@property (nonatomic) int myPid;

//


//------------

//for testpaperinfoviewcontroller
//@property (nonatomic ) int testPaperID;
//@property (nonatomic ) int subjectId;

@end
