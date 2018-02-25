#import "SettingViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingViewController ()
@property (nonatomic,retain)  UITableView *tableView;
@end

@implementation SettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
      //  self.exaPaperNameArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    self.noteArray = nil;
   // self.segments = nil; // autorelease
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"设置"];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];

    
}

- (IBAction) cancel: (id) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(section == 0) //repeat
        return 1;
    else if(section == 1) //dropbox
        return 1;
    else if(section == 2) //ad
        return 1;
    else if(section == 3) //rate support
        return 2;
    else if(section == 4) //recom app
        return 1;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellADIdentifier = @"ADCell";
    UILabel * myLabel = nil;
    if (indexPath.section == 2) //ad banner
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellADIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
                        /* cell = [[[AdBannerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellADIdentifier] autorelease];
            cell.delegate = self;
            [cell cellDidLoad];*/
        }
        cell.textLabel.text = @"Notes management";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      //  [cell cellWillAppear];
        return cell;
    }
    else //non adbanner
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
            myLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [myLabel setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        if(indexPath.section == 0 && indexPath.row == 0)
        {
            cell.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:169/255.0f alpha:1.0f];
            self.mySegmentedControl.center = cell.contentView.center;
           // NSLog(@"cellForRowAtIndexPath-Segmentwidth = %f", self.tableView.frame.size.width);
            self.mySegmentedControl.frame = CGRectMake(15, (44-32)/2, self.tableView.frame.size.width-30, 32);
            [cell.contentView addSubview:self.mySegmentedControl];
        }
        else if(indexPath.section == 1) // dropbox syn
        {
            if(indexPath.row == 0)
            {
                self.mySwitch.frame = CGRectMake(self.tableView.frame.size.width-65, (44-32)/2, self.tableView.frame.size.width-280, 32);
                myLabel.frame =CGRectMake(15, (44-32)/2, self.tableView.frame.size.width-200, 32);
                myLabel.text = @"Dropbox";
                [cell.contentView addSubview:self.mySwitch];
                [cell.contentView addSubview:myLabel];
            }
        }
        else if(indexPath.section == 3)
        {
            if(indexPath.row == 0)
            {
                cell.textLabel.text = @"Rate in App Store";
            }
            else if(indexPath.row == 1)
            {
                cell.textLabel.text = @"Support";
                cell.detailTextLabel.text = @"Contact us";
            }
        }
        else if(indexPath.section == 4)
        {
            [cell.detailTextLabel setNumberOfLines:2];
            if(indexPath.row == 0)
            {
                //---
                UIImage *image = [UIImage imageNamed:@"evermemolink"];
                //CGSize size = {JKRowHeight-15,JKRowHeight-15};
                // UIImage *shrunkenImage = [self shrinkImage:image toSize:size];
                cell.imageView.image = image;
                //CGColorRef colorref = [[UIColor greenColor] CGColor];
                //   cell.imageView.layer.backgroundColor = colorref;
                //   [cell.imageView.layer setBorderColor:[UIColor colorWithWhite:0 alpha:0.3].CGColor];
                //   [cell.imageView.layer setBorderWidth:3];
                //[cell.imageView.layer setCornerRadius:7];
                cell.textLabel.text = @"Evermemo";
                cell.detailTextLabel.text = @"An powerful, free app that helps you remember everything";
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 4 && indexPath.row == 0)
    {
        return 66;
        //return 288;
    }
    else if(indexPath.section == 2)
    {
        return 50;
    }
    else
        return 44;
    
    NSLog(@"error!!!,should not enter here");
    return 0;
}
//======
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1 )
    {
        [tableView cellForRowAtIndexPath:indexPath].selectionStyle = UITableViewCellSelectionStyleNone;
        return indexPath;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) // note management
    {
       
    }
    else if(indexPath.section == 3 && indexPath.row == 0)
    {
        UIAlertView *someError1 = [[UIAlertView alloc] initWithTitle: @"Rate in APP Store" message: @"Do you wang to exit this application so you can rate it in the iTunes App Store?" delegate: self cancelButtonTitle:[self noButtonTitle] otherButtonTitles:[self yesButtonTitle], nil];
        [someError1 show];
       // [someError1 release];
    }
    else if(indexPath.section == 3 && indexPath.row == 1)
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:@"Just to do (Support)"];
        [picker setToRecipients:@[@"kjin1983@gmail.com"]];
        [picker setMessageBody:nil isHTML:NO];
        [self presentModalViewController:picker animated:YES];
      //  [picker release];
    }
    else if(indexPath.section == 4 && indexPath.row == 0) 
    {   //https://itunes.apple.com/us/app/inoteplus/id693599276?ls=1&mt=8
        //https://itunes.apple.com/us/app/evermemo-to-do-list/id777619095?ls=1&mt=8
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/evermemo-to-do-list/id777619095?ls=1&mt=8"]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//======================================================================
#pragma mark - Table view header footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat result = 0.0f;
    if ([tableView isEqual:self.tableView] && section == 0)
    {
        result = 35.0f;
    }
    else if([tableView isEqual:self.tableView] && section == 4)
    {
        result = 10.0f;
    }
    else if([tableView isEqual:self.tableView] && section == 3)
    {
        result = 20.0f;
    }
    else if([tableView isEqual:self.tableView] && section == 2)
    {
        result = 20;
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat result = 0.0f;
    if ([tableView isEqual:self.tableView] && section == 0)
    {
        result = 30.0f;
    }
    if ([tableView isEqual:self.tableView] && section == 1)
    {
        result = 40.0f;
    }
    else if([tableView isEqual:self.tableView] && section == 3)
    {
        result = 30.0f;
    }
    else if([tableView isEqual:self.tableView] && section == 2)
    {
        result = 10.0f;
    }
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *result = nil;
    if ([tableView isEqual:self.tableView] && section == 0)
    {
        result = @"Sort By";
    }
    else if([tableView isEqual:self.tableView] && section == 4)
    {
        result = @"Recommended App:Special Honored";
    }
    else if([tableView isEqual:self.tableView] && section == 1) // dropbox
    {
        result = @"Use Dropbox to sync your entry";
    }
    return result;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *result = nil;
    if([tableView isEqual:self.tableView] && section == 1) // dropbox
    {
        result = @"If something wrong in sync, just switch off then switch on";
    }
    return result;
}

//for solve the capitalized font if no this functiuon
//http://stackoverflow.com/questions/18912980/uitableview-titleforheaderinsection-shows-all-caps
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
    }
}

//===============rate in app store=======
- (NSString *) yesButtonTitle
{
    return @"Yes";
}

- (NSString *) noButtonTitle
{
    return @"No";
}
// https://itunes.apple.com/us/app/just-to-do/id727040242?ls=1&mt=8
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:[self yesButtonTitle]])
    {
      //  NSString *str = [NSString stringWithFormat:
      //  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=727040242"];
      //  BOOL bOpen =  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        BOOL bOpen = [[UIApplication sharedApplication] openURL:
                      [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=727040242"]];
        NSLog(@"User pressed the Yes button ==%d ",bOpen);
        
        // link to an app homepage
     //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/just-to-do/id727040242?ls=1&mt=8"]];
    }
    else if ([buttonTitle isEqualToString:[self noButtonTitle]])
    {
        NSLog(@"User pressed the No button.");
    }
}

//==========rotate================
#pragma mark - rotate
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"willRotateToInterfaceOrientation");
    //Â±èÂπïÂ∞ÜË¶ÅËΩ¨Âà∞Êó∂ÊâßË°å
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation ==                        UIInterfaceOrientationLandscapeRight)
    {  //Â¶ÇÊûúÊòØÊ®°ÂêëÊó∂ÊâßË°åÂï•‰∫ã‰ª∂
        // ÈáçÊñ∞Âä†ËΩΩ‰∏Ä‰∏™NibÊñá‰ª∂
        //[[NSBundle mainBundle] loadNibNamed:@"LoginViewLandscape" owner:self options:nil];
        //   [self.tableView reloadData];
        
        NSLog(@"cccccccccccccccccccc");
        
        
    }else
    {
        //   [self.tableView reloadData];
        
        
        //Â¶ÇÊûúÊòØÁ∫µÂêëÊó∂ÊâßË°åÂï•‰∫ã‰ª∂
        // ÈáçÊñ∞Âä†ËΩΩ‰∏Ä‰∏™NibÊñá‰ª∂
        // [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
        NSLog(@"kkkkkkkkkkkkkkkkkkkkk");
    }  
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"willAnimateRotationToInterfaceOrientation");
    //NSLog(@"table view width = %f",  CGRectGetWidth(self.tableView.frame));
    
  /*  UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 80)];
    [viewHeader setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    UIImageView *sigilImageViewheader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Justtodo"]];
    [sigilImageViewheader setCenter:viewHeader.center];
    [sigilImageViewheader setAlpha:0.3];
    [viewHeader addSubview:sigilImageViewheader];
    [sigilImageViewheader release];
    self.tableView.tableHeaderView = viewHeader;
    [viewHeader release];*/
    //---------
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 100)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    UIImageView *sigilImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"copyright"]];
    [sigilImageView setCenter:view.center];
    [sigilImageView setAlpha:0.3];
    [view addSubview:sigilImageView];
  //  [sigilImageView release];
    self.tableView.tableFooterView = view;
  //  [view release];
    
   
    
    [self.tableView reloadData];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
     NSLog(@"didRotateFromInterfaceOrientation");
    //Â±èÂπïËΩ¨Âä®ÁªìÊùüÂêéËß¶ÂèëÔºåË∑ü‰∏äÈù¢ÁöÑÂ∑Æ‰∏çÂ§öÔºå‰πüÂèØ‰ª•Ë∞ÉÁî®Ëøô‰∏™
    //ÊúâÂà∑Êñ∞ÁöÑÈóÆÈ¢ò
    
}


@end
