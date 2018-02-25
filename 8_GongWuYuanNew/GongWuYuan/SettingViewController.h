//
//  SettingViewController.h
//  iNotePlus
//
//  Created by 金 柯 on 13-10-19.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


//@class RootViewController;
@interface SettingViewController : UITableViewController 
{
	
}


@property (nonatomic,strong)  NSArray *segments;
@property (nonatomic,strong)  UISegmentedControl *mySegmentedControl;
@property (nonatomic,strong)  UISwitch *mySwitch;
@property (nonatomic)    NSInteger index;


//@property (nonatomic,assign)  RootViewController *rootViewCtl;
@property (nonatomic,strong)  NSMutableArray * noteArray;

- (IBAction) clickButtonDone: (id) sender;

@end
