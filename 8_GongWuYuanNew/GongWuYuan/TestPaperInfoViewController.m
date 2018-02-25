//
//  TestPaperInfoViewController.m
//  GongWuYuan
//
//  Created by 金柯 on 14-1-12.
//  Copyright (c) 2014年 金 柯. All rights reserved.
//

#import "TestPaperInfoViewController.h"
#import "TestPaperInfoView.h"
#import "SubjectViewController.h"

@interface TestPaperInfoViewController ()<TestPaperInfoDelegate>
{
}
@property(nonatomic, strong) UILabel *myPaperNameLabel;
@property (nonatomic, strong) TestPaperInfoView *testPaperInfoView;

//used timer
@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic) int usedSeconds;

@end

@implementation TestPaperInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

-(void)dealloc

{
    NSLog(@"testpaperinfoviewcontroller-dealloc");
    //Objects release here
    
   // [super dealloc];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
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
    self.testPaperInfoView.frame = frame;
    [self.testPaperInfoView setNeedsLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    NSLog(@"testpaperinfoviewcontroller-viewwilldisappear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        
    CGRect frame;
    if(ISLANDSCAPE)
    {
        frame = CGRectMake(0, 0, ScreenHeight,ScreenWidth);
    }
    else
    {
        frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
    }
    //get subjects count according to tid
    int subCount = getSubjectCountByTestpaperIDFromProblemup(self.myIntTid);
    NSString* subCountStr = [[NSString alloc] initWithFormat:@"%d",subCount];
    
    
    NSMutableArray *layout_content = [[NSMutableArray alloc] initWithObjects:subCountStr, self.myPaperNameStr, self.mySetTimeStr,nil];
    self.testPaperInfoView = [[TestPaperInfoView alloc] initWithFrame:frame Layout_Context:layout_content];
    self.testPaperInfoView.delegate = self;
    
    //paper name label:
    /*
    self.myPaperNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, BecauseOfBarTranNO+20, self.view.frame.size.width-10, 44)];
    self.myPaperNameLabel.backgroundColor = [UIColor grayColor];
    self.myPaperNameLabel.font = JKFONT_1;
    [self.myPaperNameLabel setTextAlignment:NSTextAlignmentCenter];
    self.myPaperNameLabel.text = self.myPaperNameStr;
    //[self.myPaperNameLabel sizeToFit];
    [self.myPaperNameLabel.layer setCornerRadius:3];
    self.myPaperNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.myPaperNameLabel.numberOfLines = 0;
    //
    [self.view addSubview:self.myPaperNameLabel];
     */
    [self.view addSubview:_testPaperInfoView];
	// Do any additional setup after loading the view.
    
   
    //
    
}

#pragma mark - timer callback
- (void)TimerCallback:(id)sender
{
    g_usedTimeSeconds++;
    NSLog(@"-TimerCallback = %d seconds ",g_usedTimeSeconds);
    
    NSString* usedTimeStr = getTimeStrFromSec(g_usedTimeSeconds);
    UILabel* customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    [customLab setTextColor:[UIColor colorWithRed:0.0f/255.0f green:255/255.0f blue:0/255.0f alpha:1.0f]];
    
    [customLab setText:usedTimeStr];
    [customLab sizeToFit];
    self.navigationItem.titleView = customLab;
}
//-----------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------rotate--------------------------------------------------------
#pragma mark - rotate
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.testPaperInfoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}
//=================================datebase op========================


//=================================delegate function===================
#pragma mark -
#pragma mark - TestPaperInfoDelegate

-(void)handleButtonClicked_createSubjectVC_startTest
{
	//initialize all the fields in the database
	initializeDatebase(self.myIntTid);

	SubjectViewController * subjectVC = [[SubjectViewController alloc] init];
    
    subjectVC.enumSubjectFunctionType = self.enumInfoFunctionType;
    subjectVC.testPaperID = self.myIntTid;
    subjectVC.subjectId = 1; //from 1
    
    //set timer
  //  self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(TimerCallback:) userInfo:nil repeats:YES];
    //
    NSString* usedTimeStr =  getUsedTimeFromtestup(self.myIntTid);
    if([usedTimeStr isEqualToString:@""])
    {
        g_usedTimeSeconds = 0;
    }
    else
    {
        g_usedTimeSeconds = [usedTimeStr intValue];
    }
    usedTimeStr = getTimeStrFromSec(g_usedTimeSeconds);
    subjectVC.usedTimerStr = usedTimeStr;
    
    [self.navigationController pushViewController:subjectVC animated:YES];
}

-(void)handleButtonClicked_createSubjectVC_continueTest
{
	//get largest finished subject id
	int finishSubjectId = largestFinishedSubjectID(self.myIntTid);
	
	SubjectViewController * subjectVC = [[SubjectViewController alloc] init];
  //  subjectVC.enType = enumTestPaperType;
    subjectVC.testPaperID = self.myIntTid;
    subjectVC.subjectId = finishSubjectId; //from 1
    subjectVC.enumSubjectFunctionType = self.enumInfoFunctionType;
    
    NSString* usedTimeStr = getUsedTimeFromtestup(self.myIntTid);
    if([usedTimeStr isEqualToString:@""])
    {
        g_usedTimeSeconds = 0;
    }
    else
    {
        g_usedTimeSeconds = [usedTimeStr intValue];
    }
    usedTimeStr = getTimeStrFromSec(g_usedTimeSeconds);
    subjectVC.usedTimerStr = usedTimeStr;
    
    [self.navigationController pushViewController:subjectVC animated:YES];
}

@end
