#import "SubjectTypeInfoView.h"

@interface SubjectTypeInfoView ()
@property (nonatomic, strong) UILabel *myPaperNameLabel;
@property (nonatomic, strong) UILabel *myPaperInfoLabel;
@property (nonatomic, strong) UIButton *startTestButton;  /*重新开始或者开始答题*/
@property (nonatomic, strong) UIButton *continueTestButton; /*继续答题*/
@end

static NSString *startTestButtonStr = @"开始";
//static NSString *continueTestButtonStr = @"继续答题";

@implementation SubjectTypeInfoView
//--------------------------------------------
#pragma mark init 
- (id)initWithFrame:(CGRect)frame Layout_Context:(NSMutableArray *)context
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layout_content = context;
        self.myPaperNameLabel = [[UILabel alloc] init];
        self.myPaperInfoLabel = [[UILabel alloc] init];
        self.startTestButton = [[UIButton alloc] init];
       // self.continueTestButton = [[UIButton alloc] init];
        [self initButton:self.startTestButton withTitle:startTestButtonStr];
       // [self initButton:self.continueTestButton withTitle:continueTestButtonStr];
        
        [self addSubview:_myPaperNameLabel];
        [self addSubview:_myPaperInfoLabel];
        [self addSubview:_startTestButton];
      //  [self addSubview:_continueTestButton];
        // [self setNeedsLayout];// Initialization code
    }
    return self;
}

- (void)initButton:(UIButton*) button withTitle:(NSString*)titleStr
{
	//action
    [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchDown];
	
	//property
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,1, 0, 0);
    
    //title
    [button setTitle:titleStr forState:UIControlStateNormal];
    //[btn2 setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];  
    
    [button setTitleColor:TESTPAPERINFOBUTTONCOLOR forState:UIControlStateNormal];
    [button setTitleColor:TESTCOLOR forState:UIControlStateSelected];
    button.titleLabel.font = JKFONT_INFOVIEW;//[UIFont systemFontOfSize: 14.0];
    //[button setTitleShadowColor:[UIColor blueColor] forState:UIControlStateNormal];//阴影
  
	//background
    //button.backgroundColor = [UIColor lightGrayColor];
    //[button setBackgroundImage:[UIImage imageNamed:@"PIC"] forState:UIControlStateHighlighted];//背景图像
   
}

//------------------button click handle-------------------------
#pragma mark Button callback
-(void)ButtonClicked:(id)sender
{
    UIButton * button = (UIButton*)sender;
 	if([button.titleLabel.text isEqualToString:startTestButtonStr])
    {
        if([self.delegate respondsToSelector:@selector(handleButtonClicked_createSubjectVC_startTest)]) 
        {
        	[self.delegate handleButtonClicked_createSubjectVC_startTest];
        	return;
        }  
    }
   /* else if ([button.titleLabel.text isEqualToString:continueTestButtonStr])
    {
        if([self.delegate respondsToSelector:@selector(handleButtonClicked_createSubjectVC_continueTest)]) 
        {
        	[self.delegate handleButtonClicked_createSubjectVC_continueTest];
        	return;
        }  
    }*/
}

//------------------layout ui-------------------------------------------
#pragma mark layout UI
- (CGSize) sameRowButtonLayoutWithFrame:(CGRect)container withElement:(UIButton*)button
{
    button.frame = container;
    CGSize updateLTpos = CGSizeMake((container.origin.x + button.frame.size.width), (container.origin.y));
    return updateLTpos;
}

- (CGSize)diffrowLayout:(NSString *)string withFrame:(CGRect)container withElement:(UILabel*)label
{
    label.frame = container;
    label.text = string;
    label.font = JKFONT_INFOVIEW;
    label.textColor = LABELCOLOR;
    label.numberOfLines = 0;
    [label sizeToFit];
   // label.backgroundColor = [UIColor cyanColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    label.frame = CGRectMake((self.bounds.size.width - label.frame.size.width)/2, container.origin.y, label.frame.size.width, label.frame.size.height); //juzhong
    return CGSizeMake((container.origin.x + label.frame.size.width)/*not used*/, (container.origin.y + label.frame.size.height));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //NSLog(@"bound= %f,frame = %f", self.bounds.size.width, self.frame.size.width);
    
    CGSize updatedFrame = [self diffrowLayout:self.layout_content[1] 
    	   withFrame:CGRectMake(0, self.bounds.size.height/3, self.bounds.size.width*2/3, 0) withElement:self.myPaperNameLabel];
    	   
    NSString* subCountAndSetTimeStr = [[NSString alloc]
           initWithFormat:@"%@题",self.layout_content[0]];
    
    updatedFrame = [self diffrowLayout:subCountAndSetTimeStr
    	   withFrame:CGRectMake(0, updatedFrame.height+PARAGRAPH_SPACE, self.bounds.size.width*2/3,0)
           withElement:self.myPaperInfoLabel];
    
    updatedFrame = [self sameRowButtonLayoutWithFrame:CGRectMake((self.bounds.size.width-PAPERINFO_BUTTON_WIDTH)/2 , updatedFrame.height+PARAGRAPH_SPACE, PAPERINFO_BUTTON_WIDTH, PAPERINFO_BUTTON_HEIGHT)
           withElement: self.startTestButton];
    	   
    updatedFrame = [self sameRowButtonLayoutWithFrame:CGRectMake(updatedFrame.width+20, updatedFrame.height, PAPERINFO_BUTTON_WIDTH, PAPERINFO_BUTTON_HEIGHT)
    	   withElement: self.continueTestButton]; 
}


@end
