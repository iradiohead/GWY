//
//  TestPaperInfoView.h
//  GongWuYuan
//
//  Created by 金 柯 on 14-1-12.
//  Copyright (c) 2014年 金 柯. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------TestPaperInfoDelegate-------------------------------------------------------------
@protocol TestPaperInfoDelegate <NSObject>

@optional

- (void)handleButtonClicked_createSubjectVC_startTest;
- (void)handleButtonClicked_createSubjectVC_continueTest;

@end

//----------------------------------------------------------------------------------------------
@interface TestPaperInfoView : UIView
{
}

@property (nonatomic, strong) NSMutableArray *layout_content;
@property (nonatomic, weak) id<TestPaperInfoDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Layout_Context:(NSMutableArray *)context;


@end
