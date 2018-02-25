//
//  TestPaperInfoViewController.m
//  GongWuYuan
//
//  Created by 金柯 on 14-1-12.
//  Copyright (c) 2014年 金 柯. All rights reserved.
//

#import "SubjectTypeInfoViewController.h"
#import "SubjectTypeInfoView.h"
#import "SubjectViewController2.h"

@interface SubjectTypeInfoViewController ()<SubjectTypeInfoDelegate>
{
}
@property(nonatomic, strong) UILabel *myPaperNameLabel;
@property (nonatomic, strong) SubjectTypeInfoView *subjectTypeInfoView;

@end

@implementation SubjectTypeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    self.subjectTypeInfoView.frame = frame;
    [self.subjectTypeInfoView setNeedsLayout];
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
    
    //  get subjects count according to tid
    //  int subCount = GetTestPaperSubjectsCount(self.myIntTid);
    //  NSString* subCountStr = [[NSString alloc] initWithFormat:@"%d",subCount];
    
    //
    int subCount = 0;
    if( self.enumInfoFunctionType == enumSpecializedTrainingType )
    {
    	subCount = getSubjectTypeCount(self.mySubjectTypeStr);
    }
    else if( self.enumInfoFunctionType == enumWrongSetType)
    {
    	subCount = getSubjectByTypeAndStatusCount(self.mySubjectTypeStr, @"错误");
    }
    else if(self.enumInfoFunctionType == enumMyCollectionType )
    {
    	subCount = getSubjectByTypeAndFavoriteCount(self.mySubjectTypeStr);
    }
    NSString* subCountStr = [[NSString alloc] initWithFormat:@"%d", subCount];
    //
    
    NSMutableArray *layout_content = [[NSMutableArray alloc] initWithObjects:subCountStr, self.mySubjectTypeStr, @"none",nil];
    self.subjectTypeInfoView = [[SubjectTypeInfoView alloc] initWithFrame:frame Layout_Context:layout_content];
    self.subjectTypeInfoView.delegate = self;
    
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
    [self.view addSubview:self.subjectTypeInfoView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//=================================delegate function===================
#pragma mark -
#pragma mark - TestPaperInfoDelegate

-(void)handleButtonClicked_createSubjectVC_startTest
{
    /*SubjectViewController2 only for
    enumSpecializedTrainingType = 2,
    enumWrongSetType = 3,
    enumMyCollectionType = 4
     */
	SubjectViewController2 * subjectVC = [[SubjectViewController2 alloc] init];
    // int subjectCountWithType = getSubjectCountByTypeFromProlemupTable(self.mySubjectTypeStr);
    int subjectCount = getSubjectCountFromProlemupTable();
    int randomNum = arc4random()%subjectCount; //[0, subjectCount)
    subjectVC.myPid = randomNum;
   // subjectVC.enType = enumSubjectType;
    subjectVC.enumSubjectFunctionType = self.enumInfoFunctionType;
    subjectVC.mySubjectTypeStr = self.mySubjectTypeStr;
 
    [self.navigationController pushViewController:subjectVC animated:YES];
}

// not used now
-(void)handleButtonClicked_createSubjectVC_continueTest
{
/*	//get largest finished subject id
	int finishSubjectId = largestFinishedSubjectID(self.myIntTid);
	
	SubjectViewController * subjectVC = [[SubjectViewController alloc] init];
    subjectVC.testPaperID = self.myIntTid;
    subjectVC.subjectId = finishSubjectId; //from 1
    [self.navigationController pushViewController:subjectVC animated:YES];*/
}

//------rotate--------------------------------------------------------
#pragma mark - rotate
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.subjectTypeInfoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
}


@end
