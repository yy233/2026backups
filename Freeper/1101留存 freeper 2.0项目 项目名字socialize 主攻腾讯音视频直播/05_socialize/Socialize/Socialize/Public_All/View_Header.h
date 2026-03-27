//
//  ViewHeader.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#ifndef View_Header_h
#define View_Header_h
 

#pragma mark ===== BTN_TAG
 
#define Color_Socialize_GreenColor                      rgba(1, 211, 211, 1) 
 
//color + font

#define Color_BackgroundMainGray                         Y_ColorWith16FromRGB(0xf2f3f9)

#define Color_MainText                                   Y_ColorWith16FromRGB(0x2b2c2f)
#define Color_DetailText                                 Y_ColorWith16FromRGB(0x6e727d)
#define Color_DefineLightText                            Y_ColorWith16FromRGB(0xaaaeb9)
#define Color_BackLightGray                              Y_ColorWith16FromRGB(0xf2f3f9)
#define Color_Line_LigntGray                             Y_ColorWith16FromRGB(0xF0F1F6)
#define Color_FooterBtnGray                              Y_RGBA(170, 174, 185, 1)
#define Color_FooterBtnBlue                              Y_ColorWith16FromRGB(0x1D74FE)  //Color_Main_Bluea
//
//#define Color_Main_Blue                                   Y_ColorWith16FromRGB(0x2672f9)
#define Color_Main_Blue                                   Y_ColorWith16FromRGB(0x1D74FE)
#define Color_Main_Blue_Translucent08                     [Color_Main_Blue colorWithAlphaComponent:0.8]
#define Color_Main_Red                                    Y_ColorWith16FromRGB(0xff3232)
#define Color_Main_Red_Bright                             Y_ColorWith16FromRGB(0xFB4D36)
#define Color_Main_Red_Translucent01                      [Color_Main_Red colorWithAlphaComponent:0.1]
#define Color_Main_Red_Translucent02                      [Color_Main_Red colorWithAlphaComponent:0.2]
#define Color_Main_Red_Translucent03                      [Color_Main_Red colorWithAlphaComponent:0.3]
#define Color_Main_Green                                  Y_ColorWith16FromRGB(0x4bb030)
#define Color_Main_White                                  Y_ColorWith16FromRGB(0xFFFFFF)

#define Color_Text_MainBlack                              Y_ColorWith16FromRGB(0x2b2c2f)
#define Color_Text_MainBlack_Translucent07                [Color_Text_MainBlack colorWithAlphaComponent:0.7]
#define Color_Text_MainBlack_Translucent08                [Color_Text_MainBlack colorWithAlphaComponent:0.8]
#define Color_Text_MainWhite                              Y_ColorWith16FromRGB(0xFFFFFF)
#define Color_Text_MainWhite_Translucent08                [Color_Text_MainWhite colorWithAlphaComponent:0.8]
#define Color_Text_MainWhite_LittleBlue                   Y_ColorWith16FromRGB(0xBBD4FF)
//

#define Color_245Gray                                    Y_RGBA(245, 245, 245, 1)
#define Color_238GrayColor                               Y_RGBA(238, 238, 238, 1)
#define Color_222GrayColor                               Y_RGBA(222, 222, 222, 1)
#define Color_138GrayColor                               Y_RGBA(138, 138, 138, 1)
#define Color_136GrayColor                               Y_RGBA(136, 136, 136, 1)
#define Color_153GrayColor                               Y_RGBA(153, 153, 153, 1)
#define Color_38BlueColor                                Y_RGBA(38, 114, 249, 1)
#define Color_51BlackColor                               Y_RGBA(51, 51, 51, 1)
#define Color_58BlueBlackColor                           Y_RGBA(58, 71, 109, 1)
#define Color_11BlueColor                                Y_ColorWith16FromRGB(0x112957)

#define Color_102Gray                                    Y_RGBA(102, 102, 102, 1)

#define Y_gray_img                                    [UIImage imageWithColor:[UIColor lightGrayColor]]

//
#define  FontSize_MoneyWallet_Bold(_num)       [UIFont boldSystemFontOfSize:_num]
#define  FontSize_MoneyWallet_Nomail(_num)     [UIFont systemFontOfSize:_num]
//
#define  FontSize_ElectronicSignature_Bold(_num)       [UIFont boldSystemFontOfSize:_num]
#define  FontSize_ElectronicSignature_Nomail(_num)     [UIFont systemFontOfSize:_num]
//
//
#define  FontSize_Vip_Bold(_num)       [UIFont boldSystemFontOfSize:_num]
#define  FontSize_Vip_Nomail(_num)     [UIFont systemFontOfSize:_num]
//
#define  FontSize_Orders_Bold(_num)       [UIFont boldSystemFontOfSize:_num]
#define  FontSize_Orders_Nomail(_num)     [UIFont systemFontOfSize:_num]
 
//

#define Y_ImgNameStr_BaseArrow             @"ps_youla"  //箭头
#define Y_PlaceholderImage_GrayColorImg    [UIImage imageWithColor: Color_Line_LigntGray] //PlaceholderImage占位
 
#pragma mark ====   基础宏
#define Please_enter_phone_number @"请输入手机号"
#define Please_enter_password_number @"请输入密码"
#define Please_enter_code_number @"请输入验证码"
#define PASSWORD_ERR_IS_DIFFERENT_STR @"两次密码不匹配"
#define PASSWORD_ERR_FORMAT_STR @"错误的密码格式"
#define Str_Girl     @"女"
#define Str_Boy      @"男"
#define Str_Gender_Nomal    @"保密"



/////////////////////////////////////////////////////////////////////////////////
//比如StatusBar或者底部安全距离来判断

#define isIPhoneXSeries     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
 ||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
)\
:\
NO)

#pragma mark =====
/** 屏幕宽高*/
#define Screen_W             [UIScreen mainScreen].bounds.size.width
#define Screen_H             [UIScreen mainScreen].bounds.size.height
/////////////////////////////////////////////////////////////////////////////////
#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height
//#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define Is_IPhoneX (Screen_Width >=375.0f && Screen_Height >=812.0f && Is_Iphone)
#define Is_IPhoneXX (Screen_Width >=375.0f && Screen_Height >=812.0f)
/////////////////////////////////////////////////////////////////////////////////
//#define KNavBarHeight        (isIPhoneXSeries ? (88.0):(64.0))          /** 导航栏高度 */
//#define kStatusBar_Height    (isIPhoneXSeries ? (44.0):(20.0))          /** 状态栏高度 */
//#define kTabBar_Height       (isIPhoneXSeries ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
//#define kBottom_SafeHeight   (isIPhoneXSeries ? (34.0):(0))             /** 底部横条高度 */
#define KNavBarHeight        (Is_IPhoneXX ? (88.0):(64.0))          /** 导航栏高度 */
#define kStatusBar_Height    (Is_IPhoneXX ? (44.0):(20.0))          /** 状态栏高度 */
#define kTabBar_Height       (Is_IPhoneXX ? (49.0 + 34.0):(49.0))   /** 标签栏高度 */
#define kBottom_SafeHeight   (Is_IPhoneXX ? (34.0):(0))             /** 底部横条高度 */
#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define kRGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
#define kkScale390(x) (x * (UIScreen.mainScreen.bounds.size.width / 390.0))

/////////////////////////////////////////////////////////////////////////////////
 

#pragma mark =====
// RGB颜色
// 十六进制颜色
#define Y_ColorWith16FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Y_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Y_RGB(r,g,b)  Y_RGBA(r,g,b,1.0f)
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

 
#pragma mark === 渐变 color

#define Y_Gradient_Color(width,height,_BeginColor,_EndColor) [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:_BeginColor endColor:_EndColor]
 
//随机
#define Y_randomColor   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.5]



//
#import "UIButton+RefreshLocation.h"
#import "UIButton+ButtonEdgeInset.h" //可用

#endif /* View_Header_h */
