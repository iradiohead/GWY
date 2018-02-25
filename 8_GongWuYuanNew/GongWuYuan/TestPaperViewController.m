//
//  TestPaperViewController.m
//  GongWuYuan
//
//  Created by 金 柯 on 13-10-30.
//  Copyright (c) 2013年 金 柯. All rights reserved.

#import "TestPaperViewController.h"
#import "TestPaperInfoViewController.h"


static NSString *CellIdentifier = @"Cell";

@interface TestPaperViewController ()
{
	
}

@property (nonatomic, strong) NSMutableArray * exaPaperNameArray;

@end


@implementation TestPaperViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.exaPaperNameArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if( self.enumFunctionType == enumTrueSubjectType )
    {
        [self.navigationItem setTitle:@"国家真题"];
    }
    else if( self.enumFunctionType == enumSimulatedSubjectType )
    {
        [self.navigationItem setTitle:@"地方真题"];
    }
    
    getTestPapersByTypeFromTestpaperup(self.exaPaperNameArray, self.enumFunctionType );
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)] ;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
//得到全局的数据库变量
-(sqlite3 *)getDB
{
    GWYAppDelegate *appDelegate = (GWYAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.database;
}
*/
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int a = self.exaPaperNameArray.count;
    NSLog(@"rows = %d",a);
    return a;
   // return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [self.exaPaperNameArray[indexPath.row] objectForKey:@"name"];
    
    // cell.detailTextLabel.text = [[self.array objectAtIndex:indexPath.row] objectForKey:@"title"];
    // [cell setThumbnail:[UIImage imageNamed:[[self.array objectAtIndex:indexPath.row] objectForKey:@"image"]]];
    // [cell setFavourite:[[[self.array objectAtIndex:indexPath.row] objectForKey:@"isFavourite"] boolValue] animated:NO];
    // cell.delegate = self;
    // Configure the cell...
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   /*jk click the notes in table view */
    //show test paper info page
    TestPaperInfoViewController * tpInfoVC = [[TestPaperInfoViewController alloc] initWithNibName:nil bundle:nil];

    tpInfoVC.myIntTid = [[self.exaPaperNameArray[indexPath.row]objectForKey:@"tid"]intValue];
    tpInfoVC.myPaperNameStr = [self.exaPaperNameArray[indexPath.row]objectForKey:@"name"];
    tpInfoVC.mySetTimeStr = [self.exaPaperNameArray[indexPath.row]objectForKey:@"set_time"];
    
    tpInfoVC.enumInfoFunctionType = self.enumFunctionType;
    
    
    [self.navigationController pushViewController:tpInfoVC animated:YES];
    
    /*SubjectViewController * subjectVC = [[SubjectViewController alloc] init];
    subjectVC.testPaperID = [[self.exaPaperNameArray[indexPath.row]objectForKey:@"tid"] intValue];
    subjectVC.subjectId = 1; //from 1
    [self.navigationController pushViewController:subjectVC animated:YES];*/
}

- (IBAction) cancel: (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
