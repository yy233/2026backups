//
//  MyHeaderView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "MyHeaderView.h"

@implementation MyHeaderView
+ (MyHeaderView *)instaceThisViewSelf{
    NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:@"MyHeaderView" owner:self options:nil];

    return [nibView objectAtIndex:0];
}

- (id)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder: coder];
    if(self){
//        self.headimgTopBtn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];//无效果
    
    }
    return self;
}


- (void)addNotice{
    Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, noticeOfChangTheme);
}


#define  kTheme_Type_Key   @"Theme_Type"
- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"awakeFromNib     %1f",self.bounds.size.height);
    self.frame = CGRectMake(0, 0, Screen_W, 144);
    [self subV];
    self.headimg.layer.cornerRadius  = 6;
    self.headimg.layer.masksToBounds = YES;
    self.headimg.contentMode = UIViewContentModeScaleAspectFill;
    self.headimg.backgroundColor = Color_245Gray;
    
    
    
    
    _nickName.font = [UIFont systemFontOfSize:18.0];
    _idInfo.font = [UIFont systemFontOfSize:15.0];
    
    _idInfo.superview.backgroundColor = [UIColor clearColor];
    if([[ShareLocale shared].nowThemeStr isEqualToString:Now_Theme_light]){
        _nickName.textColor = Color_51BlackColor;
        _idInfo.textColor = Color_153GrayColor;
    }else{
        _nickName.textColor = [UIColor whiteColor];
        _idInfo.textColor = Color_153GrayColor;
    }
    
    [self addNotice];
    
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
        // self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"]; //底部背景露出一截了
        _nickName.textColor = Color_51BlackColor;
        _idInfo.textColor = Color_153GrayColor;
        
    }else{
        // self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:@"#000000" ];;
        _nickName.textColor = [UIColor whiteColor];
        _idInfo.textColor = Color_153GrayColor;
        
    }
    
    [self.headimgTopBtn newAnBtnWithTextStr:@""];
    [self.idInfoTopBtn newAnBtnWithTextStr:@""];
    self.idInfoTopBtn.imageView.contentMode = UIViewContentModeCenter;
    
    
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
//        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        self.backgroundColor =  [UIColor clearColor]; //底部背景露出一截了
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code"]];
        
    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code_dark"]];
        
    }
    
    self.headimgTopBtn.titleLabel.text = @"";
    self.idInfoTopBtn.imageView.layer.masksToBounds = YES;
}



- (void)noticeOfChangTheme{
    NSString *nowThemeStr =  [[NSUserDefaults standardUserDefaults] objectForKey:kTheme_Type_Key];//Theme_Type #define  kTheme_Type_Key   @"Theme_Type"
    if([nowThemeStr isEqualToString: @"light"]){
      //  self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:@"#FFFFFF"]; //底部背景露出一截了
        _nickName.textColor = Color_51BlackColor;
        _idInfo.textColor = Color_153GrayColor;
        
    }else{
      //  self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:@"#000000" ];;
        _nickName.textColor = [UIColor whiteColor];
        _idInfo.textColor = Color_153GrayColor;
        
    }
    
    [self.headimgTopBtn newAnBtnWithTextStr:@""];
    [self.idInfoTopBtn newAnBtnWithTextStr:@""];
    self.idInfoTopBtn.imageView.contentMode = UIViewContentModeCenter;
    

    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        //self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        self.backgroundColor = [UIColor clearColor];
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code"]];

    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code_dark"]];

    }
}

//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    NSLog(@"drawRect     %1f",self.bounds.size.height);
//
//}

//- (void)layoutSubviews{//UI更改时会被多次调用
//    [super layoutSubviews];
//    NSLog(@" MyHeaderView layoutSubviews     %1f",self.bounds.size.height);
//
//}


- (void)subV{
 
    
    [self.headimgTopBtn newAnBtnWithTextStr:@""];
    [self.idInfoTopBtn newAnBtnWithTextStr:@""];
    self.idInfoTopBtn.imageView.contentMode = UIViewContentModeCenter;
    

    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code"]];

    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];
        [ self.idInfoTopBtn newAnBtnWithImg:[UIImage imageNamed:@"img_my_qr_code_dark"]];

    }
}

@end
