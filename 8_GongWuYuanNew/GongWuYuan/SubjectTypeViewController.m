//
//  SubjectTypeViewController.m
//  GongWuYuan
//
//  Created by 金柯 on 14-2-2.
//  Copyright (c) 2014年 金 柯. All rights reserved.
//

#import "SubjectTypeViewController.h"
#import "SubjectTypeInfoViewController.h"

static NSString *CellIdentifier = @"Cell";

@interface SubjectTypeViewController ()
{
}

@property (nonatomic, strong) NSArray *arrSubjectTypeStr;

@end

@implementation SubjectTypeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
    	self.arrSubjectTypeStr = @[@"言语理解与表达", @"数量关系", @"判断推理", @"资料分析", @"常识判断"];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    [self initDatas];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)initDatas
{
    if(self.index == 2)
    {
        [self.navigationItem setTitle:@"专项训练"];
    }
    else if(self.index == 3)
    {
        [self.navigationItem setTitle:@"错题集"];
    }
    else if(self.index == 4)
    {
        [self.navigationItem setTitle:@"我的题库"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    return [self.arrSubjectTypeStr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.arrSubjectTypeStr[indexPath.row] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
	/*jk click the notes in table view */
    //show test paper info page
    SubjectTypeInfoViewController * stInfoVC = [[SubjectTypeInfoViewController alloc] initWithNibName:nil bundle:nil];
    // stInfoVC.myIntTid = [[self.exaPaperNameArray[indexPath.row]objectForKey:@"tid"]intValue];
    // stInfoVC.myPaperNameStr = [self.exaPaperNameArray[indexPath.row]objectForKey:@"name"];
    // stInfoVC.mySetTimeStr = [self.exaPaperNameArray[indexPath.row]objectForKey:@"set_time"];
    
    stInfoVC.mySubjectTypeStr = self.arrSubjectTypeStr[indexPath.row];
    stInfoVC.enumInfoFunctionType = self.enumFunctionType;
    [self.navigationController pushViewController:stInfoVC animated:YES];
    
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
