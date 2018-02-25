//
//  SubjectViewController.m
//  GongWuYuan
//
//  Created by 金 柯 on 13-12-9.
//  Copyright (c) 2013年 金 柯. All rights reserved.
//
@import GoogleMobileAds;
#import "SubjectViewController.h"
#import "SubjectView.h"

@interface SubjectViewController ()

@property (nonatomic, strong) NSMutableArray *layout_content;
@property (nonatomic, strong) SubjectView *subView;

@property (nonatomic, strong) UILabel *customLab;
//for favorite
@property (nonatomic, strong) UIButton *favoriteBarButton;
@property(nonatomic, strong) GADInterstitial*interstitial;

@end

@implementation SubjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
         //NSLog(@"initWithNibName");
         self.layout_content = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:YES];
    CGRect frame;
    if(ISLANDSCAPE)
    {
        frame = CGRectMake(0, 0, ScreenHeight,ScreenWidth);
    }
    else
    {
        frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
    }
    self.subView.frame = frame;
    [self.subView setNeedsLayout];
    
    //-----------------
    if( self.layout_content.count != 0 )
    {
        if([self.layout_content[FAVORITE] intValue] == 0)
        {
            [self.favoriteBarButton setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        }
        else if ([self.layout_content[FAVORITE] intValue]== 1)
        {
            [self.favoriteBarButton setBackgroundImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
        }
    }
 	//-----------------
}

//===========================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interstitial = [self createAndLoadInterstitial];
    GADRequest *request = [GADRequest request];
    [self.interstitial loadRequest:request];
    
    [self setUpGestureRecognizers:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //--------------------customize navigationItem--------------------------------------------------
    //Custom backgroundImage UIButton
    UIButton *btnCustom1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCustom1 setFrame:CGRectMake(0, 0, 24, 24)];
    [btnCustom1 addTarget:self action:@selector(navigationBarButtonClick1) forControlEvents:UIControlEventTouchUpInside];
    [btnCustom1 setTitle:@"" forState:UIControlStateNormal];
    [btnCustom1 setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //[btnCustom setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:btnCustom1];//allocate
    
  /*  UIButton *btnCustom2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCustom2 setFrame:CGRectMake(0, 0, 32, 32)];
    [btnCustom2 addTarget:self action:@selector(navigationBarButtonClick2) forControlEvents:UIControlEventTouchUpInside];
    [btnCustom2 setTitle:@"" forState:UIControlStateNormal];
    [btnCustom2 setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:btnCustom2];
    
    UIButton *btnCustom3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCustom3 setFrame:CGRectMake(0, 0, 32, 32)];
    [btnCustom3 addTarget:self action:@selector(navigationBarButtonClick3) forControlEvents:UIControlEventTouchUpInside];
    [btnCustom3 setTitle:@"" forState:UIControlStateNormal];
    [btnCustom3 setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    //[btnCustom setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBarButton3 = [[UIBarButtonItem alloc] initWithCustomView:btnCustom3];*/
    
    NSArray *buttonArrayLeft = [[NSArray alloc]initWithObjects:leftBarButton1,nil];
    
	self.navigationItem.leftBarButtonItems = buttonArrayLeft;
    

    //--------title------------------------------------------------------------------------------
    self.customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [self.customLab setTextAlignment:NSTextAlignmentCenter];
    [self.customLab setTextColor:LABELCOLOR];
    
    NSString * title = getTheFunctionTypeByEnum(self.enumSubjectFunctionType);
    [self.customLab setText:title];
    [self.customLab sizeToFit];
    self.navigationItem.titleView = self.customLab;
    
    //-----------------------------------------------
    if(self.enumSubjectFunctionType == enumTrueSubjectType || self.enumSubjectFunctionType == enumSimulatedSubjectType )
    {
        getSubjectFromProlemupTable(self.layout_content, self.testPaperID, self.subjectId);
        if(self.subjectId <= getSubjectCountByTestpaperIDFromProblemup(self.testPaperID))
        {
            CGRect frame;
            if(ISLANDSCAPE)
            {
                frame = CGRectMake(0, 0, ScreenHeight,ScreenWidth);
            }
            else
            {
                frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
            }
            self.subView = [[SubjectView alloc] initWithFrame:frame Layout_Context:self.layout_content];
            //self.subView.enType = self.enType;
            self.subView.enumSVFunctionType = self.enumSubjectFunctionType;
            self.subView.Controller = self;
            
            [self.view addSubview:_subView];
        }
        else
        {
            UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"题目做完了" message: @"返回试卷页" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [someError1 show];
        }
    }
    //-------------------right bar button--------
    UIButton *rightbtnCustom1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightbtnCustom1 setFrame:CGRectMake(0, 0, 24, 24)];
    [rightbtnCustom1 addTarget:self action:@selector(navigationrightBarButtonClick1) forControlEvents:UIControlEventTouchUpInside];
    [rightbtnCustom1 setTitle:@"" forState:UIControlStateNormal];
    [rightbtnCustom1 setBackgroundImage:[UIImage imageNamed:@"forword.png"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightbtnCustom1];

    self.favoriteBarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.favoriteBarButton setFrame:CGRectMake(0, 0, 24, 24)];
    [self.favoriteBarButton addTarget:self action:@selector(navigationrightBarButtonClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.favoriteBarButton setTitle:@"" forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton2 = [[UIBarButtonItem alloc] initWithCustomView:self.favoriteBarButton];
    
    UIBarButtonItem* fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 25;
    
    NSArray *buttonArrayRight = [[NSArray alloc]initWithObjects:rightBarButton1,fixedSpace,rightBarButton2,nil];
    self.navigationItem.rightBarButtonItems = buttonArrayRight;
    //-----------------------------------------------
}


- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:ADMOB_INTER_AD_ID];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (NSDate*)convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}



#pragma mark - alertView callback
//------------------alertview callback--------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Ok"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//==================gesture==================================================
#pragma mark - gesture
- (void)setUpGestureRecognizers:(UIViewController *)viewController
{
    // Swipe right: pop the current view and go back one level
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popCurrentViewOut:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [viewController.view addGestureRecognizer:rightSwipeGesture];


    // Swipe left: push a new view
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pushNewViewIn:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [viewController.view addGestureRecognizer:leftSwipeGesture];
}

- (void)popCurrentViewOut:(UIGestureRecognizer *)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];//:subjectVC animated:YES];
   // [self popViewController];
}

- (void)pushNewViewIn:(UIGestureRecognizer *)gestureRecognizer
{
	
    [self CreateNewSubjectViewAndPushIn];
    
    /*
    // If current view controller responds to viewControllerToPush, then acquire that view controller
    // and push it to the view hierarchy.
    UIViewController *currentViewController = [self currentViewController];
    if ([currentViewController respondsToSelector:@selector(viewControllerToPush)])
    {
        UIViewController *newViewController = [currentViewController performSelector:@selector(viewControllerToPush)];
        [self pushViewController:newViewController];
    }*/
}

- (void)CreateNewSubjectViewAndPushIn
{
    if(self.subjectId%20==0)
    {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    }
    SubjectViewController * subjectVC = [[SubjectViewController alloc] init];
    if(self.enumSubjectFunctionType == enumTrueSubjectType || self.enumSubjectFunctionType == enumSimulatedSubjectType)
    {// now do not need this enum judge, because of subjectviewcontroller2 exist
        subjectVC.testPaperID = self.testPaperID;// [[self.exaPaperNameArray[indexPath.row]objectForKey:@"tid"] intValue];
        subjectVC.subjectId = self.subjectId + 1;
    }
    [self.navigationController pushViewController:subjectVC animated:YES];
}

//==============navigator bar action=============================================
#pragma mark - navigator bar action
-(void)selectLeftAction:(id)sender
{
     [self.navigationController popToRootViewControllerAnimated:YES]; //直接跳到根viewcontroller
    //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏左按钮" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //[alter show];
}
//-----
-(IBAction)navigationBarButtonClick1
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)navigationBarButtonClick2
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)navigationBarButtonClick3
{
    [self.navigationController popViewControllerAnimated:YES];
}

//---right bar button
-(IBAction)navigationrightBarButtonClick1  // next subject
{
    [self CreateNewSubjectViewAndPushIn];
}

-(IBAction)navigationrightBarButtonClick2:(id)sender  //favorite
{
	if([self.layout_content[FAVORITE]intValue] == 0)
	{ // 4.png favorite
		[self.favoriteBarButton setBackgroundImage:[UIImage imageNamed:@"select2.png"] forState:UIControlStateNormal];
        
		self.layout_content[FAVORITE] = [[NSNumber alloc] initWithInt:1];
		updateFavoriteToProblemupTB(self.layout_content[PID],self.layout_content[FAVORITE]);
	}
	else if([self.layout_content[FAVORITE]intValue] == 1)
	{
		[self.favoriteBarButton setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
		self.layout_content[FAVORITE] = [[NSNumber alloc] initWithInt:0];
        updateFavoriteToProblemupTB(self.layout_content[PID], self.layout_content[FAVORITE]);
	}
}


#pragma mark - rotate
//---------------------------------------------------------
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //屏幕将要转到时执行
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation ==                        UIInterfaceOrientationLandscapeRight)
    {  //如果是模向时执行啥事件
        // 重新加载一个Nib文件
        //[[NSBundle mainBundle] loadNibNamed:@"LoginViewLandscape" owner:self options:nil];
        //   [self.tableView reloadData];
        // NSLog(@"cccccccccccccccccccc");
    }
    else
    {
        //   [self.tableView reloadData];
        //如果是纵向时执行啥事件
        // 重新加载一个Nib文件
        // [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
        // NSLog(@"kkkkkkkkkkkkkkkkkkkkk");
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.subView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //屏幕转动结束后触发，跟上面的差不多，也可以调用这个
    //有刷新的问题
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
