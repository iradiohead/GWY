//
//  TestPaperViewController.h
//  GongWuYuan
//
//  Created by 金 柯 on 13-10-30.
//  Copyright (c) 2013年 金 柯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestPaperViewController : UITableViewController
{
	@public
        int myTest;
}
@property (nonatomic ) FunctionTypeEnum enumFunctionType;

- (id)initWithStyle:(UITableViewStyle)style;

@end
