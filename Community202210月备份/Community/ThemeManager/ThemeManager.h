//
//  ThemeManager.h
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * kSaveThemeTypeWithStr_White =  @"W";
static NSString * kSaveThemeTypeWithStr_Dray =  @"D";

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ThemeType_White,
    ThemeType_Drak,
} ThemeType;
@interface ThemeManager : NSObject
singleton_interface(shareManager)
@property (nonatomic,strong) NSString *saveThemeTypeWithStr;//0924保存tabbar时使用;
@property (nonatomic,assign) ThemeType type;

//0818色卡
//————————颜色
@property (nonatomic,strong) UIColor *themeBackGroundColor;//背景色#001534
@property (nonatomic,strong) UIColor *themeContentBackGroundColor;//内容底色#112957
//内容底色 深色不动 浅色type=则为纯白色内容
@property (nonatomic,strong) UIColor *themeContentBackGroundColor_DrakNoChangeAndWW;
//内容底色 浅色不动  深色type=则和vc深蓝色相同
@property (nonatomic,strong) UIColor *themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
//内容底色 vc的主题色一样 深色==重蓝色 浅色==非白。==themeBackGroundColor==vcbg
@property (nonatomic,strong) UIColor *themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;

@property (nonatomic,strong) UIColor *themeLineColor;//分割线条#3E5177
//
@property (nonatomic,strong) UIColor *themeBtnBlueColor;//按钮 #2672F9
@property (nonatomic,strong) UIColor *themeTipRedColor;//观点提示 #FF0033
//
@property (nonatomic,strong) UIColor *themeTextMainColor;//文字主色 #2B2C2F
@property (nonatomic,strong) UIColor *themeTextDetailColor;//副文本 #6E727D
@property (nonatomic,strong) UIColor *detailTextColor;
//———————— 字体大小
@property (nonatomic,strong) UIFont *themeTextFont18;
@property (nonatomic,strong) UIFont *themeTextFont15;
@property (nonatomic,strong) UIFont *themeTextFont15B;
@property (nonatomic,strong) UIFont *themeTextFont14;
@property (nonatomic,strong) UIFont *themeTextFont13;
@property (nonatomic,strong) UIFont *themeTextFont12;
@property (nonatomic,strong) UIFont *themeTextFont11;

//———————---------------------------------------------------
//login
@property (nonatomic,strong) UIImage *loginModulethemeImgVCBackViewImg;
@property (nonatomic,strong) UIColor *loginModulethemeColorVCBackViewColor;
@property (nonatomic,strong) UIColor *loginModuleTextColor;
@property (nonatomic,strong) UIColor *loginModuleDetailTextColorIsAlphaEighty;
@property (nonatomic,strong) UIColor *loginModuleDetailTextColorIsAlphaFifty;

//main_img
@property (nonatomic,strong) UIColor *themeColorVCBackViewColor;
//mainvc
@property (nonatomic,strong) UIImage *mainViewLayerContentsImg;

@property (nonatomic,strong) UIColor *mainItemBackGroundColor;
@property (nonatomic,strong) UIColor *mainTextColor;
@property (nonatomic,strong) UIColor *mainTexDetailLightBluetColor;
@property (nonatomic,strong) UIColor *mainContentBackgroundColor;//内容背景色 drak时的相对于底色的浅一点的蓝色
@property (nonatomic,strong) UIColor *mainContentLineColor;//内容 分割线色


@property (nonatomic,strong) UIColor *mainSectionHeaderTextColor;
@property (nonatomic,strong) UIColor *mainSearchBarTextFieldBackGroundColor;
@property (nonatomic,strong) UIColor *mainSearchBarTextColor;
@property (nonatomic,strong) UIColor *mainInterestingNewsBackGroundColor;
@property (nonatomic,strong) UIColor *mainInterestingNewsTextColor;
@property (nonatomic,strong) UIColor *mainInterestingNewsDetailTextColor;

//main_cell_sub
//menu
@property (nonatomic,strong) UIColor *mainMenuCellFirstItemBackGroundColor;
@property (nonatomic,strong) UIColor *mainMenuCellOtherItemBackGroundColor;
@property (nonatomic,strong) UIColor *mainMenuCellFirstItemTextColor;
@property (nonatomic,strong) UIColor *mainMenuCellOtherItemTextColor;
//urgent
@property (nonatomic,strong) UIColor *mainUrgentCellBackGroundColor;
@property (nonatomic,strong) UIColor *mainUrgentCellTextColor;
//addressBook
@property (nonatomic,strong) UIColor *mainAddressBookCellBackGroundColor;
@property (nonatomic,strong) UIColor *mainAddressBookCellTextColor;

//guest
@property (nonatomic,strong) UIColor *guestMainTextColor;
@property (nonatomic,strong) UIColor *guestDetailTextColor;
@property (nonatomic,strong) UIColor *guestAccompanyNavViewMainTextColor;
@property (nonatomic,strong) UIColor *guestAccompanyNavViewMainDetailTextColor;

//菜单 更多vc
@property (nonatomic,strong) UIColor *meueMoreVcBackgroundColor;
@property (nonatomic,strong) UIColor *meueMoreContentItemBackgroundColor;
//来访 编辑界面
@property (nonatomic,strong) UIColor *guestInfoRegisterVcBackgroundColor;
@property (nonatomic,strong) UIColor *guestInfoRegisterContentCellBackgroundColor;
//业主 城市社区等层级选择 界面
@property (nonatomic,strong) UIColor *chooseUserCityAndOtherVcBackgroundColor;
@end
NS_ASSUME_NONNULL_END
