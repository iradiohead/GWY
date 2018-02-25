#import "GWYViewController.h"
#import "InfiniteScrollPicker.h"
#import "TestPaperViewController.h"
#import "SubjectTypeViewController.h"

#import "SettingViewController.h"

@interface GWYViewController ()
{
	InfiniteScrollPicker *isp;
    InfiniteScrollPicker *isp2;
    InfiniteScrollPicker *isp3;
}

@end

@implementation GWYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
	// Do any additional setup after loading the view, typically from a nib.

	    
    /* NSMutableArray *set1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++)
    {
        [set1 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"s1_%d.png", i]]];
    }*/
    
    /* NSMutableArray *set2 = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 4; i++) {
        [set2 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"s2_%d.png", i]]];
    }*/
    
    NSMutableArray *set3 = [[NSMutableArray alloc] init];
    if(RK_IS_IPHONE)
    //for (int i = 0; i < 6; i++)
    {
        [set3 addObject:[UIImage imageNamed:@"zhenti.png"]];
        [set3 addObject:[UIImage imageNamed:@"moni.png"]];
        [set3 addObject:[UIImage imageNamed:@"xunlian.png"]];
        [set3 addObject:[UIImage imageNamed:@"cuoti.png"]];
        [set3 addObject:[UIImage imageNamed:@"tiku.png"]];
      //  [set3 addObject:[UIImage imageNamed:@"shezhi.png"]];
    }
    else if(RK_IS_IPAD)
    {
    	
    	[set3 addObject:[UIImage imageNamed:@"zhenti_ipad.png"]];
        [set3 addObject:[UIImage imageNamed:@"moni_ipad.png"]];
        [set3 addObject:[UIImage imageNamed:@"xunlian_ipad.png"]];
        [set3 addObject:[UIImage imageNamed:@"cuoti_ipad.png"]];
        [set3 addObject:[UIImage imageNamed:@"tiku_ipad.png"]];
       // [set3 addObject:[UIImage imageNamed:@"shizhi_ipad.png"]];
    }
    
    
    
    //-----------------
    /* 
    isp = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    //CGRect test = self.view.frame;
    [self.view addSubview:isp];
    [isp setItemSize:CGSizeMake(50, 50)];
    [isp setImageAry:set1];
    */
    
    /* 
    isp2 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, 110, 320, 120)];
    [isp2 setImageAry:set2];
    [isp2 setHeightOffset:30.0];
    [isp2 setPositionRatio:2.0];
    [isp2 setAlphaOfobjs:0.3];
    [self.view addSubview:isp2];
    */
    //NSLog(@"height =%f", ScreenWidth -100);
    CGSize imageSize = [(UIImage *)[set3 objectAtIndex:0] size];
    isp3 = [[InfiniteScrollPicker alloc] initWithFrame:CGRectMake(0, (ScreenHeight-imageSize.height)/2, ScreenWidth, imageSize.height+50)];
    [self.view addSubview:isp3];
    [isp3 setImageAry:set3];
    [isp3 setHeightOffset:20];
    [isp3 setPositionRatio:2];
    [isp3 setAlphaOfobjs:0.8];
    /*
    //admob----------------
    self.banner = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0, 20.0, //windowHeight - GAD_SIZE_320x50.height - 44,
                                                                      ScreenWidth,
                                                                      GAD_SIZE_320x50.height)];
    self.banner.adUnitID = ADMOBID;
    self.banner.rootViewController = self;
    [self.view addSubview:self.banner];
    [self.banner loadRequest:[GADRequest request]];
    self.banner = nil;
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)infiniteScrollPicker:(InfiniteScrollPicker *)infiniteScrollPicker didSelectAtImage:(UIImage *)image
{
    //SubjectViewCtl *controller = [[SubjectViewCtl alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    //[self.navigationController pushViewController:controller animated:YES];
    //[self.view addSubview:controller];
   // NSLog(@"selected");
}

-(void)touchPhotoAction:(UIGestureRecognizer *)gestureRecognizer
{
    //这个view是手势所属的view，也就是增加手势的那个view  
    UIView *egoivPhotoView = [gestureRecognizer view];
    int tPhotoIndex = [egoivPhotoView tag];
    
    if(tPhotoIndex == 0 || tPhotoIndex == 1)
    {
        TestPaperViewController * tpViewController = [[TestPaperViewController alloc] initWithStyle:  UITableViewStylePlain];
        //tpViewController->myTest = 10;
        if(tPhotoIndex == 0)
            tpViewController.enumFunctionType = enumTrueSubjectType;
        else if(tPhotoIndex == 1)
            tpViewController.enumFunctionType = enumSimulatedSubjectType;
        
        
        UINavigationController * navCon = [[UINavigationController alloc] initWithRootViewController:tpViewController];
        [self presentViewController:navCon animated:YES completion:nil];
        //[self.navigationController pushViewController:tpViewController animated:YES];
        NSLog(@"PhotoIndex __%d",tPhotoIndex );
    }
    else if(tPhotoIndex == 2 || tPhotoIndex == 3 || tPhotoIndex == 4)
    {
        SubjectTypeViewController * stViewCtl = [[SubjectTypeViewController alloc] initWithStyle:UITableViewStyleGrouped];
        stViewCtl.index = tPhotoIndex;
        if(tPhotoIndex == 2)
        {
        	stViewCtl.enumFunctionType = enumSpecializedTrainingType;
        }
        else if(tPhotoIndex == 3)
        {
        	stViewCtl.enumFunctionType = enumWrongSetType;
        }
        else if(tPhotoIndex == 4)
        {
        	stViewCtl.enumFunctionType = enumMyCollectionType;
        }
        
        UINavigationController * navCon = [[UINavigationController alloc] initWithRootViewController:stViewCtl];
        [self presentViewController:navCon animated:YES completion:nil];
        NSLog(@"PhotoIndex __%d",tPhotoIndex );
    }
    else if(tPhotoIndex == 5)
    {
        SettingViewController * settingVC = [[SettingViewController alloc]initWithStyle:UITableViewStyleGrouped];
        UINavigationController * navCon = [[UINavigationController alloc] initWithRootViewController:settingVC];
        [self presentViewController:navCon animated:YES completion:nil];
       // NSLog(@"PhotoIndex __%d",tPhotoIndex );
        // setting view
        
    }
    
   
}

@end
