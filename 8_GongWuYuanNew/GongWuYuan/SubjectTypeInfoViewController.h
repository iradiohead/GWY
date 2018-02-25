//
//  TestPaperInfoViewController.h
//  GongWuYuan
//
//  Created by 金柯 on 14-1-12.
//  Copyright (c) 2014年 金 柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectTypeInfoViewController : UIViewController
{
}


@property(nonatomic) int myIntTid;
@property(nonatomic, strong) NSString *myPaperNameStr;
@property(nonatomic, strong) NSString *mySetTimeStr;

@property(nonatomic, strong) NSString *mySubjectTypeStr;

@property (nonatomic ) FunctionTypeEnum enumInfoFunctionType;

@end
