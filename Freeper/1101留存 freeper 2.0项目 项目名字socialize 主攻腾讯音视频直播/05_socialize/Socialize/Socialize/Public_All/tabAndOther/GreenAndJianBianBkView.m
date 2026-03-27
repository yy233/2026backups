//
//  GreenAndJianBianBkView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/14.
//

#import "GreenAndJianBianBkView.h"

@interface GreenAndJianBianBkView ()

@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,assign) CGFloat all_H;
@property (nonatomic,strong) UIImageView *selfBkImg;

@end

@implementation GreenAndJianBianBkView

- (UIImageView *)selfBkImg{
    if(!_selfBkImg){
        _selfBkImg = [[UIImageView alloc]init];
    }
    return _selfBkImg;
}

- (CAGradientLayer *)jianBianGLayer{
    CAGradientLayer *gl = [CAGradientLayer layer];
    /**
     0904 只用蓝色和透明 不要黄绿色
     gl.frame = CGRectMake(0,0,Screen_W,Screen_H *0.5);
     gl.startPoint = CGPointMake(0.5, 0);
     gl.endPoint = CGPointMake(0.5, 0.99);
     gl.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:250/255.0 blue:252/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:218/255.0 green:253/255.0 blue:211/255.0 alpha:0.0].CGColor];
     gl.locations = @[@(0), @(1.0f)];
     */

    gl.frame = CGRectMake(0,0,Screen_W,Screen_H *0.5);
    gl.startPoint = CGPointMake(0.0, 0.0);//起始点
    gl.endPoint = CGPointMake(0, 1.0);//结束点
    gl.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:250/255.0 blue:252/255.0 alpha:1.0].CGColor,
                  (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.0].CGColor];
    gl.locations = @[@(0.35), @(1.0f)];////颜色渐变位置分割线 递增 分界线才不明显
    
    return gl;
    
}

- (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return outputImage;
}

//上半部分渐变色 后半白色  (sub都是0.25的高度) rgba(215, 250, 252, 1) kJianBianColor_Green_C (218, 253, 211, 1)  Theme_Bk_COlOR_Light_Str 三色渐变 改为绿白两色
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //notice
        Y_NSNotificationCenter_Creat_NameAction(WebView_Theme_Change_NoticeName, changeZhuTi);//changeZhuTi 语言切换通知可用于黑白色主题切换
        if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
            [self jianBianImgInit];
        }else{
            self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
            self.selfBkImg.image = [UIImage imageWithColor:[UIColor clearColor] size: self.selfBkImg.frame.size];
        }
        
        /**
         self.all_H = frame.size.height;
         //渐变色
         UIColor * beginColor =  [Y_ToolOfOthers getColorWithHexString:kJianBianColor_Blue_Str];
         UIColor * center_Color = [[Y_ToolOfOthers getColorWithHexString:kJianBianColor_Green_Str] colorWithAlphaComponent:0.5];
         UIColor * bottom_endColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
         //位置
         CGRect topRect = CGRectMake(0, 0, Screen_W, self.all_H*0.25);
         CGRect bottomRect = CGRectMake(0, self.all_H*0.25, Screen_W, self.all_H*0.25);
         //大小高度
         self.topView = [[UIView alloc]initWithFrame:topRect];
         self.bottomView = [[UIView alloc]initWithFrame:bottomRect];
         //add
         [self addSubview:self.topView];
         [self addSubview:self.bottomView];
         

         
         if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
             self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str]; //底部背景露出一截了
             //彩色
             self.topView.backgroundColor = [UIColor y_colorGradientChangeWithSize:topRect.size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:center_Color];
             self.bottomView.backgroundColor = [UIColor y_colorGradientChangeWithSize:bottomRect.size direction:IHGradientChangeDirectionVertical startColor:center_Color endColor:bottom_endColor];
             
         }else{
             self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
             //舍弃彩色
             self.topView.backgroundColor =  self.backgroundColor;
             self.bottomView.backgroundColor =  self.backgroundColor;
         }
         */
        
        
        
      
        
    }
    return self;
}

- (void)jianBianImgInit{
    self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
    UIImage *allImg = [self imageFromLayer: [self jianBianGLayer]];
    [self addSubview:self.selfBkImg];
    self.selfBkImg.frame = CGRectMake(0,0,Screen_W, Screen_H * 0.5);
    self.selfBkImg.image = allImg;
    self.selfBkImg.contentMode = UIViewContentModeScaleAspectFill;


}
- (void)changeZhuTi{
    NSLog(@"渐变色 背景更新处理");
    
    
   /**
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        //渐变色
        UIColor * beginColor =  [Y_ToolOfOthers getColorWithHexString:kJianBianColor_Blue_Str];
        UIColor * center_Color = [Y_ToolOfOthers getColorWithHexString:kJianBianColor_Green_Str];
        UIColor * bottom_endColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
        //位置
        CGRect topRect = CGRectMake(0, 0, Screen_W, self.all_H*0.25);
        CGRect bottomRect = CGRectMake(0, self.all_H*0.25, Screen_W, self.all_H*0.25);

        //不新增 只更改颜色
        //
        self.topView.backgroundColor = [UIColor y_colorGradientChangeWithSize:topRect.size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:center_Color];
        self.bottomView.backgroundColor = [UIColor y_colorGradientChangeWithSize:bottomRect.size direction:IHGradientChangeDirectionVertical startColor:center_Color endColor:bottom_endColor];
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Light_Str];
        
        
    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
        //舍弃彩色
        self.topView.backgroundColor =  self.backgroundColor;
        self.bottomView.backgroundColor =  self.backgroundColor;
    }*/
    
    
    if([[ShareLocale shared].nowThemeStr isEqualToString: Now_Theme_light]){
        [self jianBianImgInit];
    }else{
        self.backgroundColor =  [Y_ToolOfOthers getColorWithHexString:Theme_Bk_COlOR_Drak_Str ];;
        self.selfBkImg.image = [UIImage imageWithColor:[UIColor clearColor] size: self.selfBkImg.frame.size];
    }
    
}
@end
