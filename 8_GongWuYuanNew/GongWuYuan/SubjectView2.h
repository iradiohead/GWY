//
//  SubjectView.h
//  GongWuYuan
//
//  Created by 金 柯 on 13-12-26.
//  Copyright (c) 2013年 金 柯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectViewController2.h"

@class  GADBannerView;
@interface SubjectView2 : UIView
{
}
	
//@property (nonatomic ) SubjectViewEnum enType;
@property (nonatomic ) FunctionTypeEnum enumSVFunctionType;
@property (nonatomic, strong)  GADBannerView * banner;
@property (nonatomic ) SubjectViewController2* Controller;


@property (nonatomic, strong) NSString *myCusAnswer;


//--------
- (id)initWithFrame:(CGRect)frame Layout_Context:(NSMutableArray *)context;
	

@end
