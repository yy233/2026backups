//
//  PensionThemeManage.h
//  Community
//
//  Created by 余莹 on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PensionThemeManager : NSObject
singleton_interface(shareManager)
//@property (nonatomic,strong) UIColor *Pension_ ;
@property (nonatomic,strong) UIColor *Pension_OrangeColor;//#FFA82B
@property (nonatomic,strong) UIColor *Pension_RedColor;//#FF7E6E
@property (nonatomic,strong) UIColor *Pension_BlueColor;//#539CFC
@property (nonatomic,strong) UIColor *Pension_Gray197Color;//#C5C5C5

//绿色总
@property (nonatomic,strong) UIColor *Pension_NavGreenBackGroundColor;//nav绿色背景色 #36C8C1
@property (nonatomic,strong) UIColor *Pension_SubMainGreenColor;//#38C1BA
@property (nonatomic,strong) UIColor *Pension_GradualGreen_DrayGreenColor;//#38C1BA
@property (nonatomic,strong) UIColor *Pension_GradualGreen_LightGreenColor;//#2CE7BD


//文本黑色灰色
@property (nonatomic,strong) UIColor *Pension_TextMainColor;//#2B2C2F
@property (nonatomic,strong) UIColor *Pension_TextSubMainColor;//#6E727D
@property (nonatomic,strong) UIColor *Pension_TextGray170Color;//#AAAEB9
//
@property (nonatomic,strong) UIColor *Pension_LineColor;//#C5C9D4
@property (nonatomic,strong) UIColor *Pension_LightGrayBackGroundColor;//#F0F1F6

//字体大小 养老医疗暂不确定大小是否更改
@property (nonatomic,strong) UIFont *Pension_TextFont_18;
@property (nonatomic,strong) UIFont *Pension_TextFont_B15;
@property (nonatomic,strong) UIFont *Pension_TextFont_15;
@property (nonatomic,strong) UIFont *Pension_TextFont_B14;
@property (nonatomic,strong) UIFont *Pension_TextFont_14;
@property (nonatomic,strong) UIFont *Pension_TextFont_B13;
@property (nonatomic,strong) UIFont *Pension_TextFont_13;
@property (nonatomic,strong) UIFont *Pension_TextFont_12;
@property (nonatomic,strong) UIFont *Pension_TextFont_11;


@end

NS_ASSUME_NONNULL_END
