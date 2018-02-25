//
//  SubjectView.m
//  GongWuYuan
//
//  Created by 金 柯 on 13-12-26.
//  Copyright (c) 2013年 金 柯. All rights reserved.
//

#import "SubjectView2.h"

/*
self.myCusAnswer = @"" when init
如果这题在数据库里显示做过的，在这里任然显示没做过，不用记录用户答案

if enter from enumSpecializedTrainingType enumWrongSetType enumMyCollectionType, 不用记录用户答案，
要记录状态（对错） 和favorite
*/

@interface SubjectView2 ()

@property (nonatomic)  BOOL showAnswer;
@property (nonatomic)  Byte answerbyte;
@property (nonatomic, strong) NSMutableArray *layout_content;

@property (strong, nonatomic) UIScrollView *scView;
@property (nonatomic, strong) UILabel *typeLabel; //常识判断，资料分析
@property (nonatomic, strong) UILabel *choiceTypeLabel; //单选多选
@property (nonatomic, strong) UILabel *meterialStrLabel;
@property (nonatomic, strong) NSMutableArray *arrMeterialPicLabel;
@property (nonatomic, strong) UILabel *pidInTestLabel;
@property (nonatomic, strong) UILabel *problemStrLabel;
@property (nonatomic, strong) NSMutableArray *arrProblemPicLabel;
@property (nonatomic, strong) UIButton *choiceAButton;
@property (nonatomic, strong) UILabel *choiceAStrLabel;
@property (nonatomic, strong) UILabel *choiceAPicLabel;
@property (nonatomic, strong) UIButton *choiceBButton;
@property (nonatomic, strong) UILabel *choiceBStrLabel;
@property (nonatomic, strong) UILabel *choiceBPicLabel;
@property (nonatomic, strong) UIButton *choiceCButton;
@property (nonatomic, strong) UILabel *choiceCStrLabel;
@property (nonatomic, strong) UILabel *choiceCPicLabel;
@property (nonatomic, strong) UIButton *choiceDButton;
@property (nonatomic, strong) UILabel *choiceDStrLabel;
@property (nonatomic, strong) UILabel *choiceDPicLabel;
@property (nonatomic, strong) UIButton *multichoiceButton;
@property (nonatomic, strong) UILabel *correctAnswerLabel;
@property (nonatomic, strong) UILabel *analyseStrLabel;
@property (nonatomic, strong) UILabel *analysePicLabel;
@end


@implementation SubjectView2

- (id)initWithFrame:(CGRect)frame Layout_Context:(NSMutableArray *)context
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        self.myCusAnswer = @"";
        //
        self.layout_content = context;
        [self initAllGlobalDatas];
        
        self.scView = [[UIScrollView alloc] init];
        self.typeLabel = [[UILabel alloc] init];
        self.choiceTypeLabel = [[UILabel alloc]init];
        self.meterialStrLabel = [[UILabel alloc] init];
        NSMutableString *pic_name = self.layout_content[METERIAL_P];
        
        self.arrMeterialPicLabel = [[NSMutableArray alloc]init];
        if(![pic_name isEqual: @""])
        {
            NSArray *pic_name_list = [pic_name componentsSeparatedByString:@","];
            for(int i=0; i<pic_name_list.count; i++)
            {
                UILabel *meterialPicLabel = [[UILabel alloc] init];
                [self.arrMeterialPicLabel addObject:meterialPicLabel];
                [self.scView addSubview:self.arrMeterialPicLabel[i]];
            }
        }
        self.pidInTestLabel = [[UILabel alloc] init];
        self.problemStrLabel = [[UILabel alloc] init];
        
        self.arrProblemPicLabel = [[NSMutableArray alloc]init];
        pic_name = self.layout_content[PROBLEM_P];
        if(![pic_name isEqual: @""])
        {
            NSArray *pic_name_list = [pic_name componentsSeparatedByString:@","];
            for(int i=0; i<pic_name_list.count; i++)
            {
                UILabel *problemPicLabel = [[UILabel alloc] init];
                [self.arrProblemPicLabel addObject:problemPicLabel];
                [self.scView addSubview:problemPicLabel];
            }
        }        self.choiceAButton = [[UIButton alloc] init];
        [self initButton:self.choiceAButton withTitle:@"A"];
        self.choiceAStrLabel = [[UILabel alloc] init];
        self.choiceAPicLabel = [[UILabel alloc] init];
        self.choiceBButton = [[UIButton alloc] init];
        [self initButton:self.choiceBButton withTitle:@"B"];
        self.choiceBStrLabel = [[UILabel alloc] init];
        self.choiceBPicLabel = [[UILabel alloc] init];
        self.choiceCButton = [[UIButton alloc] init];
        [self initButton:self.choiceCButton withTitle:@"C"];
        self.choiceCStrLabel = [[UILabel alloc] init];
        self.choiceCPicLabel = [[UILabel alloc] init];
        self.choiceDButton = [[UIButton alloc] init];
        [self initButton:self.choiceDButton withTitle:@"D"];
        self.choiceDStrLabel = [[UILabel alloc] init];
        self.choiceDPicLabel = [[UILabel alloc] init];
        self.correctAnswerLabel = [[UILabel alloc] init];
        self.multichoiceButton = [[UIButton alloc] init];
        self.analyseStrLabel = [[UILabel alloc] init];
        self.analysePicLabel = [[UILabel alloc] init];
        //self.banner = [[GADBannerView alloc] init];
        
        //[self.scView addSubview:self.banner];
        [self.scView addSubview:_typeLabel];
        [self.scView addSubview:self.choiceTypeLabel];
        [self.scView addSubview:_meterialStrLabel];
        [self.scView addSubview:_pidInTestLabel];
        [self.scView addSubview:_problemStrLabel];
        [self.scView addSubview:_choiceAButton];
        [self.scView addSubview:_choiceAStrLabel];
        [self.scView addSubview:_choiceAPicLabel];
        [self.scView addSubview:_choiceBButton];
        [self.scView addSubview:_choiceBStrLabel];
        [self.scView addSubview:_choiceBPicLabel];
        [self.scView addSubview:_choiceCButton];
        [self.scView addSubview:_choiceCStrLabel];
        [self.scView addSubview:_choiceCPicLabel];
        [self.scView addSubview:_choiceDButton];
        [self.scView addSubview:_choiceDStrLabel];
        [self.scView addSubview:_choiceDPicLabel];
        if([self.layout_content[CHOICE_TYPE] isEqualToString:@"多选题"] || [self.layout_content[CHOICE_TYPE] isEqualToString:@"不定项"])
        {
            [self.multichoiceButton addTarget:self action:@selector(MultiChoiceButtonClicked:) forControlEvents:UIControlEventTouchDown];
            [self.scView addSubview:_multichoiceButton];
        }
        [self.scView addSubview:_correctAnswerLabel];
        [self.scView addSubview:_analyseStrLabel];
        [self.scView addSubview:_analysePicLabel];
        [self addSubview:_scView];
    }
    return self;
}



-(void)initAllGlobalDatas
{   //when popup navi viewcontrol, left swipe, then right swipe, create subjectviewcontrol again
    NSString* cusAns = self.myCusAnswer;//self.layout_content[CUS_ANSWER];
    if([cusAns isEqualToString:@""])
    {
        self.showAnswer = NO;
        self.answerbyte = 0;
    }
    else
    {
        self.showAnswer = YES;
        [self getAnswerByte:cusAns]; //set self.answerbyte
    }
}

- (void)initButton:(UIButton*) button withTitle:(NSString*)title
{
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = CHOICEBUTTONDIAMETER/2;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,1, 0, 0);
    
    [button addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:LABELCOLOR forState:UIControlStateNormal];
   // [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    button.backgroundColor = [UIColor whiteColor];

    if(self.showAnswer)
    {
        if ([self.myCusAnswer rangeOfString:title].location != NSNotFound)
        {
            if([self.myCusAnswer rangeOfString:title].location != NSNotFound)
            {
                button.backgroundColor = [UIColor greenColor];
                [button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
            }
            else
            {
                button.backgroundColor = [UIColor redColor];
                [button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
            }
        }
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return final;
}


- (CGSize)samerowLayoutAttri:(NSAttributedString *)string withFrame:(CGRect)container withElement:(UILabel*)labelView
{
    labelView.frame = container;
    labelView.attributedText = string;
    labelView.textColor = LABELCOLOR;
    //labelView.font = JKFONT;
    //problemView.Text = problem_nsStr;
    labelView.numberOfLines = 0;
    [labelView sizeToFit];
    CGSize updateFrame = CGSizeMake((container.origin.x + labelView.frame.size.width), (container.origin.y));
    return updateFrame;
}

- (CGSize)samerowLayout:(NSMutableString *)string withFrame:(CGRect)container withElement:(UILabel*)labelView
{
    labelView.frame = container;
    labelView.Text = string;
    labelView.font = JKFONT_1;
    labelView.textColor = LABELCOLOR;
    //problemView.Text = problem_nsStr;
    labelView.numberOfLines = 0;
    [labelView sizeToFit];
    CGSize updateFrame = CGSizeMake((container.origin.x + labelView.frame.size.width), (container.origin.y));
    return updateFrame;
}
//---------choince button---------------------------------
- (CGSize) choiceButtonWithFrame:(CGRect)container withElement:(UIButton*)button
{
  //  button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = container;
    CGSize updateLTpos = CGSizeMake((container.origin.x + button.frame.size.width), (container.origin.y));
    return updateLTpos;
}
//---------多选确定 button---------------------------------
- (CGSize) multiConfirmButtonWithFrame:(CGRect)container withElement:(UIButton*)button
{
    //  button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = container;
    CGSize updateLTpos = CGSizeMake((container.origin.x + button.frame.size.width), (container.origin.y + button.frame.size.height));
    return updateLTpos;
}

-(void)fillAnswerByte:(NSString *)choice
{
    if ([choice isEqualToString:@"A"])
    {
        self.answerbyte = self.answerbyte ^ 0x1;
    }
    else if([choice isEqualToString:@"B"])
    {
        self.answerbyte = self.answerbyte ^ 0x2;
    }
    else if([choice isEqualToString:@"C"])
    {
        self.answerbyte = self.answerbyte ^ 0x4;
    }
    else if([choice isEqualToString:@"D"])
    {
        self.answerbyte = self.answerbyte ^ 0x8;
    }
    NSLog(@"answerbyte = %d", self.answerbyte);
}

-(void)getAnswerByte:(NSString*) answerCusStr
{
    int i;
    for(i = 0; i< answerCusStr.length; i++)
    {
        unichar indexchar = [answerCusStr characterAtIndex:i];
        NSString * temp = [[NSString alloc] initWithCharacters:&indexchar length:1];
        [self fillAnswerByte:temp];
    }
    NSLog(@"getAnswerByte = %d",self.answerbyte);
}

-(NSMutableString *)getCustomerAnswer
{
    __autoreleasing NSMutableString *answer = [[NSMutableString alloc] init];
    if(self.answerbyte&0x1)
        [answer appendString:@"A"];
    if(self.answerbyte&0x2)
        [answer appendString:@"B"];
    if(self.answerbyte&0x4)
        [answer appendString:@"C"];
    if(self.answerbyte&0x8)
        [answer appendString:@"D"];
    return answer;
}

-(BOOL)checkAnswerByte:(NSString *)correctAnswer customerAns:(NSString*)cusAns
{
    if([cusAns isEqualToString:correctAnswer])
        return TRUE;
    else
        return FALSE;
}

//----------------------------------------------------------------
#pragma mark BUTTON CALLBACK
-(void)ButtonClicked:(id)sender
{
    UIButton * button = (UIButton*)sender;
    if(!self.showAnswer)
    {
        [self fillAnswerByte:button.titleLabel.text];
       // NSLog(@"choice type: %@", self.layout_content[TYPE]);
        if([self.layout_content[CHOICE_TYPE] isEqualToString:@"单选题"])
        {
            self.showAnswer = TRUE; //layout show answer
            NSString * correct_answer = [[NSString alloc] initWithString:self.layout_content[ANSWER]];
            
           
            NSMutableString * customer_answer = [self getCustomerAnswer];
            /* updateCustomerAnswer(customer_answer, self.layout_content[PID]);
            self.layout_content[CUS_ANSWER] = customer_answer;*/
            
            self.myCusAnswer = customer_answer;
            
            if([self checkAnswerByte:correct_answer customerAns: customer_answer])
            {
                button.backgroundColor =[UIColor greenColor];
                [button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
                
                updateStatusInProblemTB(@"正确", self.layout_content[PID]);
                self.layout_content[STATUS] = @"正确";
            }
            else
            {
                button.backgroundColor =[UIColor redColor];
                [button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
                
                updateStatusInProblemTB(@"错误", self.layout_content[PID]);
                self.layout_content[STATUS] = @"错误";
            }
            [self setNeedsLayout];//
        }
        else if([self.layout_content[CHOICE_TYPE] isEqualToString:@"多选题"] || [self.layout_content[CHOICE_TYPE] isEqualToString:@"不定项"]) // multi choice
        {
            //[self fillAnswerByte:button.titleLabel.text];
            if(CGColorEqualToColor(button.backgroundColor.CGColor, [UIColor blueColor].CGColor))
            {   // equal
                button.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                button.backgroundColor = [UIColor blueColor];
            }
        }//end multi choice
    }
}

#pragma mark BUTTON CALLBACK
-(void)MultiChoiceButtonClicked:(id)sender
{
    //UIButton * button = (UIButton*)sender;
    self.showAnswer = TRUE; //layout show answer
    NSString * correct_answer = [[NSString alloc] initWithString:self.layout_content[ANSWER]];
    
    NSMutableString * customer_answer = [self getCustomerAnswer];
    updateCustomerAnswer(customer_answer, self.layout_content[PID]);
    self.layout_content[CUS_ANSWER] = customer_answer;
    
    if([self checkAnswerByte:correct_answer customerAns: customer_answer])
    {
        //button.backgroundColor =[UIColor greenColor];
        //[button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
        
        updateStatusInProblemTB(@"正确", self.layout_content[PID]);
        self.layout_content[STATUS] = @"正确";
    }
    else
    {
        //button.backgroundColor =[UIColor redColor];
        //[button setTitleColor:CHOICEBUTTONTITLECOLOR forState:UIControlStateNormal];
        
        updateStatusInProblemTB(@"错误", self.layout_content[PID]);
        self.layout_content[STATUS] = @"错误";
    }
    [self setNeedsLayout];//
}

///-------------------------------------------------------
#pragma mark UI LAYOUT

- (CGSize)diffrowLayoutAttri:(NSAttributedString *)string withFrame:(CGRect)container withElement:(UILabel*)labelView
{
    labelView.frame = container;
    labelView.attributedText = string;
    labelView.textColor = LABELCOLOR;
    // labelView.font = JKFONT;
    //problemView.Text = problem_nsStr;
    labelView.numberOfLines = 0;
    [labelView sizeToFit];
    CGSize updateLTpos = CGSizeMake((container.origin.x + labelView.frame.size.width)/*not used*/, (container.origin.y + labelView.frame.size.height));
    return updateLTpos;
}

- (CGSize)diffrowLayout:(NSMutableString *)string withFrame:(CGRect)container withElement:(UILabel*)labelView
{
    labelView.frame = container;
    labelView.Text = string;
    labelView.font = JKFONT_1;
    labelView.textColor = LABELCOLOR;
    //problemView.Text = problem_nsStr;
    labelView.numberOfLines = 0;
    [labelView sizeToFit];
    CGSize updateFrame = CGSizeMake((container.origin.x + labelView.frame.size.width)/*not used*/, (container.origin.y + labelView.frame.size.height));
    return updateFrame;
}


-(NSAttributedString*)getPicAttriStr:(NSMutableString*)picName returnPicWidth:(float *) picWidth
{
    NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:nil ofType:nil ];
    UIImage * smileImage = [ UIImage imageNamed : picName]; //my emoticon image named a.jpg
    //   float picWidth = 0;
    if ( smileImage.size.width > ScreenWidth )
    {
        *picWidth = ScreenWidth*0.9;
    }
    else if(smileImage.size.width > ScreenWidth/2)
    {
        *picWidth = ScreenWidth *0.8;
    }
    else
    {
        *picWidth = ScreenWidth *0.5;
    }
    
    UIImage * smileImage1 = [self shrinkImage: smileImage toSize: CGSizeMake(*picWidth, smileImage.size.height* (*picWidth)/smileImage.size.width)];
    textAttachment.image = smileImage1 ;
    return  [ NSAttributedString attributedStringWithAttachment:textAttachment ] ;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

   // NSLog(@"bound= %f,frame = %f",self.bounds.size.width,self.frame.size.width);
    
    NSMutableString *type_nsstr = self.layout_content[TYPE];
    CGSize updateFrame = [self samerowLayout:type_nsstr withFrame:CGRectMake(LEFT_SPACE, UP_SPACE, 0, 0) withElement:self.typeLabel];

    // 单选多选label
    NSMutableString *choice_type_nsstr = self.layout_content[CHOICE_TYPE];
    updateFrame = [self diffrowLayout:choice_type_nsstr withFrame:CGRectMake(ScreenWidth - 60, updateFrame.height, 0, 0) withElement:self.choiceTypeLabel];
    
    //---------METERIAL-----------资料题先显示资料
    NSMutableString *meterial_nsstr = self.layout_content[METERIAL_T];
    if(![meterial_nsstr isEqual: @""])
    {
        updateFrame = [self diffrowLayout:meterial_nsstr withFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, TEXTWIDTH2, 0) withElement:self.meterialStrLabel];
    }

    NSMutableString *pic_name = self.layout_content[METERIAL_P];
    if(![pic_name isEqual: @""])
    {
        NSArray *pic_name_list = [pic_name componentsSeparatedByString:@","];
        for(int i=0; i<pic_name_list.count; i++)
        {
            float widthPic = 0;
            NSAttributedString * attStr = [self getPicAttriStr:pic_name_list[i] returnPicWidth:&widthPic];
            NSLog(@"test = %@",self.arrMeterialPicLabel[i]);
            updateFrame = [self diffrowLayoutAttri:attStr
        							 withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) 
        						   withElement:self.arrMeterialPicLabel[i]];
        }
    }
    
    if( self.enumSVFunctionType == enumTrueSubjectType || self.enumSVFunctionType == enumSimulatedSubjectType )
    {
        //-----pid ----------//通过历年真题或模拟题进人的答题页显示试卷内题号
        NSMutableString *pid_in_test = [[NSMutableString alloc] initWithFormat:@"%@. ", self.layout_content[PIDINTEST] ];
        updateFrame=[self samerowLayout:pid_in_test 
        					  withFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, 0, 0) 
        					withElement:self.pidInTestLabel];
    }
    else
    {
    	// not show it
    }
    
    //-----------------problem------------------
    if(self.enumSVFunctionType == enumTrueSubjectType || self.enumSVFunctionType == enumSimulatedSubjectType)
    {
	    NSMutableString *problem_nsstr = self.layout_content[PROBLEM_T];
	    if(![problem_nsstr isEqual: @""])
	        updateFrame = [self diffrowLayout:problem_nsstr withFrame:CGRectMake(INTERNAL_LEFT_SPACE, updateFrame.height, TEXTWIDTH3, 0) withElement:self.problemStrLabel];
	}
	else if(self.enumSVFunctionType == enumSpecializedTrainingType ||self.enumSVFunctionType == enumWrongSetType || self.enumSVFunctionType == enumMyCollectionType )
	{
		NSMutableString *problem_nsstr = self.layout_content[PROBLEM_T];
	    if(![problem_nsstr isEqual: @""])
	        updateFrame = [self diffrowLayout:problem_nsstr withFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, TEXTWIDTH3, 0) withElement:self.problemStrLabel];
	}
	
	
    //--------problem image
    pic_name = self.layout_content[PROBLEM_P];
    if(![pic_name isEqual: @""])
    {
        NSArray *pic_name_list = [pic_name componentsSeparatedByString:@","];
        for(int i=0; i<pic_name_list.count; i++)
        {
            float widthPic = 0;
            NSAttributedString * attStr = [self getPicAttriStr:pic_name_list[i] returnPicWidth:&widthPic];
            updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.arrProblemPicLabel[i]];
        }
    }
	
    // ----choice a 
    updateFrame = [self choiceButtonWithFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, CHOICEBUTTONDIAMETER, CHOICEBUTTONDIAMETER) withElement:self.choiceAButton];

    NSMutableString *choice_a_nsstr = self.layout_content[CHOICE_A_T];
    if(![choice_a_nsstr isEqual: @""])
        updateFrame = [self diffrowLayout:choice_a_nsstr withFrame:CGRectMake(INTERNAL_LEFT_SPACE, updateFrame.height+CHOICEBUTTONDIAMETER/5, TEXTWIDTH, 0) withElement:self.choiceAStrLabel];

    //----choice a image
    pic_name = self.layout_content[CHOICE_A_P];
    if(![pic_name isEqual: @""])
    {
        float widthPic = 0;
        NSAttributedString * attStr = [self getPicAttriStr:pic_name returnPicWidth:&widthPic];
        updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.choiceAPicLabel];
    }

    //----choice b
    updateFrame = [self choiceButtonWithFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, CHOICEBUTTONDIAMETER, CHOICEBUTTONDIAMETER) withElement:self.choiceBButton];

    NSMutableString *choice_b_nsstr = self.layout_content[CHOICE_B_T];
    if(![choice_b_nsstr isEqual: @""])
        updateFrame = [self diffrowLayout:choice_b_nsstr withFrame:CGRectMake(INTERNAL_LEFT_SPACE, updateFrame.height+CHOICEBUTTONDIAMETER/5, TEXTWIDTH, 0) withElement:self.choiceBStrLabel];

    //----choice b image
    pic_name = self.layout_content[CHOICE_B_P];
    if(![pic_name isEqual: @""])
    {
        float widthPic = 0;
        NSAttributedString * attStr = [self getPicAttriStr:pic_name returnPicWidth:&widthPic];
        updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.choiceBPicLabel];
    }

    //----choice c
    updateFrame = [self choiceButtonWithFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, CHOICEBUTTONDIAMETER, CHOICEBUTTONDIAMETER) withElement:self.choiceCButton];
    //updateFrame = [self samerowLayout:choice_c withFrame:CGRectMake(20, updateFrame.height+20, 0, 0)];

    NSMutableString *choice_c_nsstr = self.layout_content[CHOICE_C_T];
    if(![choice_c_nsstr isEqual: @""])
        updateFrame = [self diffrowLayout:choice_c_nsstr withFrame:CGRectMake(INTERNAL_LEFT_SPACE, updateFrame.height+CHOICEBUTTONDIAMETER/5, TEXTWIDTH, 0) withElement:self.choiceCStrLabel];

    //----choice c image
    pic_name = self.layout_content[CHOICE_C_P];
    if(![pic_name isEqual: @""])
    {
        float widthPic = 0;
        NSAttributedString * attStr = [self getPicAttriStr:pic_name returnPicWidth:&widthPic];
        updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.choiceCPicLabel];
    }

    //---- choice d
    updateFrame = [self choiceButtonWithFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, CHOICEBUTTONDIAMETER, CHOICEBUTTONDIAMETER) withElement:self.choiceDButton];

    NSMutableString *choice_d_nsstr = self.layout_content[CHOICE_D_T];
    if(![choice_d_nsstr isEqual: @""])
        updateFrame = [self diffrowLayout:choice_d_nsstr withFrame:CGRectMake(INTERNAL_LEFT_SPACE, updateFrame.height+CHOICEBUTTONDIAMETER/5, TEXTWIDTH, 0) withElement:self.choiceDStrLabel];

    //-----choice d image
    pic_name = self.layout_content[CHOICE_D_P];
    if(![pic_name isEqual: @""])
    {
        float widthPic = 0;
        NSAttributedString * attStr = [self getPicAttriStr:pic_name returnPicWidth:&widthPic];
        updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.choiceDPicLabel];
    }
    if([self.layout_content[CHOICE_TYPE] isEqualToString:@"多选题"] || [self.layout_content[CHOICE_TYPE] isEqualToString:@"不定项"])
    {
        updateFrame = [self multiConfirmButtonWithFrame:CGRectMake((self.bounds.size.width-MULTI_CHOICE_BUTTON_WIDTH)/2, updateFrame.height+PARAGRAPH_SPACE, MULTI_CHOICE_BUTTON_WIDTH, MULTI_CHOICE_BUTTON_HEIGHT) withElement:self.multichoiceButton];
        self.multichoiceButton.layer.borderWidth = 1;
        self.multichoiceButton.layer.cornerRadius = MULTI_CHOICE_BUTTON_HEIGHT/6;
        self.multichoiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter ;
        self.multichoiceButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.multichoiceButton.contentEdgeInsets = UIEdgeInsetsMake(0,1, 0, 0);
        
        
        [self.multichoiceButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.multichoiceButton setTitleColor:LABELCOLOR forState:UIControlStateNormal];
        //[button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        self.multichoiceButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        self.multichoiceButton.backgroundColor = [UIColor whiteColor];
        if(self.showAnswer)
            self.multichoiceButton.hidden = TRUE;
    }

//--------------------
    // answer
    NSMutableString *answer_nsstr = [[NSMutableString alloc] initWithString: self.layout_content[ANSWER]];
    if(![answer_nsstr isEqual: @""])
    {
        NSString* cusAns = self.myCusAnswer;//self.layout_content[CUS_ANSWER];
        if(self.showAnswer)
        {
            BOOL answer_correct = [self checkAnswerByte:answer_nsstr customerAns:cusAns];
            if(answer_correct)
            {
                //show correct picture
            }
            else
            {
                //show wrong picture
                [answer_nsstr insertString:@"正确答案：" atIndex:0];
                updateFrame = [self diffrowLayout:answer_nsstr withFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, TEXTWIDTH2, 0) withElement:self.correctAnswerLabel];
            }
            
            NSMutableString *analyse_nsstr = self.layout_content[ANALYSE_T];
            if(![analyse_nsstr isEqual: @""])
                updateFrame = [self diffrowLayout:analyse_nsstr withFrame:CGRectMake(LEFT_SPACE, updateFrame.height+PARAGRAPH_SPACE, TEXTWIDTH2, 0) withElement:self.analyseStrLabel];
            
            pic_name = self.layout_content[ANALYSE_P];
            if(![pic_name isEqual: @""])
            {
                float widthPic = 0;
                NSAttributedString * attStr = [self getPicAttriStr:pic_name returnPicWidth:&widthPic];
                updateFrame = [self diffrowLayoutAttri:attStr withFrame:CGRectMake((ScreenWidth-widthPic)/2, updateFrame.height+PARAGRAPH_SPACE, 0, 0) withElement:self.analysePicLabel];
            }
            /*
            //admob----------------
            self.banner.frame = CGRectMake(0.0, updateFrame.height,ScreenWidth, GAD_SIZE_320x50.height);
            self.banner.adUnitID = ADMOBID;
            self.banner.rootViewController = self.Controller;
            [self.banner loadRequest:[GADRequest request]];
            updateFrame.height = updateFrame.height+GAD_SIZE_320x50.height;
             */
        }
    }
//-------------------
    self.scView.backgroundColor = [UIColor whiteColor];
    self.scView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGSize contentSize = CGSizeMake(self.bounds.size.width, updateFrame.height);
    self.scView.contentSize = contentSize;
}

@end
