//
//  MedicalCareThemeManager.h
//  Community
//
//  Created by 余莹 on 2021/11/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicalCareThemeManager : NSObject
singleton_interface(shareManager);

//@property (nonatomic,strong) UIColor *Medical_
@property (nonatomic,strong) UIColor *Medical_GreenColor;//#12C797
@property (nonatomic,strong) UIColor *Medical_OrangeColor;//#FFA82B
@property (nonatomic,strong) UIColor *Medical_BlueColor;//#1EABFA
@property (nonatomic,strong) UIColor *Medical_PurpleColor;//#811FFF
@property (nonatomic,strong) UIColor *Medical_RedColor;//#FF7E6E


//文本黑色灰色
@property (nonatomic,strong) UIColor *Medical_TextMainColor;//#2B2C2F
@property (nonatomic,strong) UIColor *Medical_TextSubMainColor;//#6E727D
@property (nonatomic,strong) UIColor *Medical_TextGray170Color;//#AAAEB9
//
@property (nonatomic,strong) UIColor *Medical_LineColor;//#C5C9D4
@property (nonatomic,strong) UIColor *Medical_LightGrayBackGroundColor;//#F0F1F6

//字体大小 养老医疗暂不确定大小是否更改
@property (nonatomic,strong) UIFont *Medical_TextFont_18;
@property (nonatomic,strong) UIFont *Medical_TextFont_B15;
@property (nonatomic,strong) UIFont *Medical_TextFont_15;
@property (nonatomic,strong) UIFont *Medical_TextFont_B14;
@property (nonatomic,strong) UIFont *Medical_TextFont_14;
@property (nonatomic,strong) UIFont *Medical_TextFont_12;
@property (nonatomic,strong) UIFont *Medical_TextFont_11;
@end

NS_ASSUME_NONNULL_END
