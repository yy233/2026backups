//
//  ThemeManager.m
//  Community
//
//  Created by 余莹 on 2020/11/24.
//

#import "ThemeManager.h"
#define Color_Menu_Item_begin Y_RGB(100,203, 224)
#define Color_Menu_Item_end Y_RGB(52,104, 241)

@interface ThemeManager ()
@property (nonatomic,strong) UIColor *mainItemBackGroundColor_drak;
@property (nonatomic,strong) UIColor *mainItemBackGroundColor_white;
@end
@implementation ThemeManager
singleton_implementation(shareManager)

- (NSString *)saveThemeTypeWithStr{
    if (!_saveThemeTypeWithStr) {
        _saveThemeTypeWithStr = @"";
    }
    return _saveThemeTypeWithStr;
}

- (ThemeType)type{
    if (!_type) {
        _type = ThemeType_White;
    }
    return _type;
}

#pragma mark ===
//0818 色卡

/**
 //0818色卡
 @property (nonatomic,strong) UIColor *themeBackGroundColor;//背景色#001534
 @property (nonatomic,strong) UIColor *themeContentBackGroundColor;//内容底色#112957
 @property (nonatomic,strong) UIColor *themeLineColor;//分割线条#3E5177
 //
 @property (nonatomic,strong) UIColor *themeBtnBlueColor;//按钮 #2672F9
 @property (nonatomic,strong) UIColor *themeTipRedColor;//观点提示 #FF0033
 //
 @property (nonatomic,strong) UIColor *themeTextMainColor;//文字主色 #2B2C2F #2B2C2F
 @property (nonatomic,strong) UIColor *themeTextDetailColor; #6E727D
 
 
 
 */
//背景色
//Y_RGBA(240, 241, 246, 1);  #F0F1F6  主背景底色 非白 浅白
//0,21,52 Y_RGBA(0, 21, 52, 1); #001534  主背景底色 重蓝色 主蓝
- (UIColor *)themeBackGroundColor{
    if (!_themeBackGroundColor) {
//        _themeBackGroundColor =  Y_ColorWith16FromRGB(0x2672F9);
        _themeBackGroundColor =  Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_White) {
//        _themeBackGroundColor = Color_245Gray;//Y_ColorWith16FromRGB(0x2672F9);
        _themeBackGroundColor =  Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_Drak) {
        _themeBackGroundColor = Y_ColorWith16FromRGB(0x001534);
    }
    return _themeBackGroundColor;
}
//内容底色 --三种
//内容底色  F0F1F6 ==240,241,246 浅白色
//内容底色 //Y_RGBA(17, 41, 87, 1);== #112957  非重蓝色 内容背景色
- (UIColor *)themeContentBackGroundColor{
    if (!_themeContentBackGroundColor) {
        _themeContentBackGroundColor =  Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_White) {
        _themeContentBackGroundColor = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_Drak) {
        _themeContentBackGroundColor = Y_ColorWith16FromRGB(0x112957);
    }
    return _themeContentBackGroundColor;
}
//内容底色 深色不动 浅色type=则为纯白色内容
- (UIColor *)themeContentBackGroundColor_DrakNoChangeAndWW{
    if (!_themeContentBackGroundColor_DrakNoChangeAndWW) {
        _themeContentBackGroundColor_DrakNoChangeAndWW = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _themeContentBackGroundColor_DrakNoChangeAndWW =  [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _themeContentBackGroundColor_DrakNoChangeAndWW = Y_ColorWith16FromRGB(0x112957);
    }
    return _themeContentBackGroundColor_DrakNoChangeAndWW;
}
//内容底色 浅色为纯白  深色type=则和vc深蓝色相同
- (UIColor *)themeContentBackGroundColor_WhiteIsWwAndDrayIsDD{
    if (!_themeContentBackGroundColor_WhiteIsWwAndDrayIsDD) {
        _themeContentBackGroundColor_WhiteIsWwAndDrayIsDD = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _themeContentBackGroundColor_WhiteIsWwAndDrayIsDD =  [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _themeContentBackGroundColor_WhiteIsWwAndDrayIsDD =  Y_ColorWith16FromRGB(0x001534);//(0, 21, 52, 1); #001534  主背景底色 重蓝色 主蓝 vc蓝
    }
    return _themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
}
//内容底色 vc的主题色一样 深色==重蓝色 浅色==非白。==themeBackGroundColor==vcbg
- (UIColor *)themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD{
    if (!_themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD) {
        _themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD = Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_White) {
        _themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD =  Y_ColorWith16FromRGB(0xF0F1F6);
    }
    if (self.type==ThemeType_Drak) {
        _themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD =  Y_ColorWith16FromRGB(0x001534);//(0, 21, 52, 1); #001534  主背景底色 重蓝色 主蓝 vc蓝
    }
    return _themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
}
//分割线条
- (UIColor *)themeLineColor{
    if (!_themeLineColor) {
        _themeLineColor =  Y_ColorWith16FromRGB(0xC5C9D4);
    }
    if (self.type==ThemeType_White) {
        _themeLineColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    if (self.type==ThemeType_Drak) {
        _themeLineColor = Y_ColorWith16FromRGB(0x3E5177);
    }
    return _themeLineColor;
}
//按钮
- (UIColor *)themeBtnBlueColor{
    if (!_themeBtnBlueColor) {
        _themeBtnBlueColor =  Y_ColorWith16FromRGB(0x2672F9);
    }
    return _themeBtnBlueColor;
}
//观点提示
- (UIColor *)themeTipRedColor{
    if (!_themeTipRedColor) {
        _themeTipRedColor =  Y_ColorWith16FromRGB(0xFF0033);
    }
    return _themeTipRedColor;
}

//文字主色
- (UIColor *)themeTextMainColor{
    if (!_themeTextMainColor) {
        _themeTextMainColor =  Y_ColorWith16FromRGB(0xFFFFFF);
    }
    if (self.type==ThemeType_White) {
        _themeTextMainColor = Y_ColorWith16FromRGB(0x2B2C2F);
    }
    if (self.type==ThemeType_Drak) {
        _themeTextMainColor = Y_ColorWith16FromRGB(0xFFFFFF);//白
    }
    return _themeTextMainColor;
}
//副文本 
- (UIColor *)themeTextDetailColor{
    if (!_themeTextDetailColor) {
        _themeTextDetailColor =  Y_ColorWith16FromRGB(0x6E727D);
    }
    if (self.type==ThemeType_White) {
        _themeTextDetailColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    if (self.type==ThemeType_Drak) {
        _themeTextDetailColor = Y_ColorWith16FromRGB(0xAAAEB9);
    }
    return _themeTextDetailColor;
}
- (UIColor *)detailTextColor{
    if (!_detailTextColor) {
        _detailTextColor =  Y_ColorWith16FromRGB(0x6E727D);
    }
    if (self.type==ThemeType_White) {
        _detailTextColor = Y_ColorWith16FromRGB(0x6E727D);
    }
    if (self.type==ThemeType_Drak) {
        _detailTextColor = Y_ColorWith16FromRGB(0xC5C9D4);
    }
    return _detailTextColor;
} 

//———————— 字体大小
- (UIFont *)themeTextFont18{
    if (!_themeTextFont18) {
        _themeTextFont18 = [UIFont systemFontOfSize:18.f];
    }
    return _themeTextFont18;
}
- (UIFont *)themeTextFont15{
    if (!_themeTextFont15) {
        _themeTextFont15 = [UIFont systemFontOfSize:15.f];
    }
    return _themeTextFont15;
}
- (UIFont *)themeTextFont15B{
    if (!_themeTextFont15B) {
        _themeTextFont15B = [UIFont boldSystemFontOfSize:15.f];
    }
    return _themeTextFont15B;
}
- (UIFont *)themeTextFont14{
    if (!_themeTextFont14) {
        _themeTextFont14 = [UIFont systemFontOfSize:14.f];
    }
    return _themeTextFont14;
}
- (UIFont *)themeTextFont13{
    if (!_themeTextFont13) {
        _themeTextFont13 = [UIFont systemFontOfSize:13.f];
    }
    return _themeTextFont13;
}
 
- (UIFont *)themeTextFont12{
    if (!_themeTextFont12) {
        _themeTextFont12 = [UIFont systemFontOfSize:12.f];
    }
    return _themeTextFont12;
}
- (UIFont *)themeTextFont11{
    if (!_themeTextFont11) {
        _themeTextFont11 = [UIFont systemFontOfSize:11.f];
    }
    return _themeTextFont11;
}


#pragma mark ==login
- (UIColor *)loginModulethemeColorVCBackViewColor{
    if (!_loginModulethemeColorVCBackViewColor) {
        _loginModulethemeColorVCBackViewColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _loginModulethemeColorVCBackViewColor = Y_RGBA(0, 21, 52, 1);// 重蓝色 主蓝
    }
    if (self.type==ThemeType_Drak) {
        _loginModulethemeColorVCBackViewColor = Y_RGBA(0, 21, 52, 1);
    }
    return _loginModulethemeColorVCBackViewColor;
}
- (UIImage *)loginModulethemeImgVCBackViewImg{
    if (!_loginModulethemeImgVCBackViewImg) {
        _loginModulethemeImgVCBackViewImg = [UIImage imageNamed:@"loginbackImg"];
    }
    if (self.type==ThemeType_White) {
        _loginModulethemeImgVCBackViewImg = [UIImage imageNamed:@"loginbackImg"];
    }
    if (self.type==ThemeType_Drak) {
        _loginModulethemeImgVCBackViewImg =[UIImage imageNamed:@"loginbackImg"];
    }
    return _loginModulethemeImgVCBackViewImg;
}
- (UIColor *)loginModuleTextColor{
    if (!_loginModuleTextColor) {
        _loginModuleTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
//        _loginModuleTextColor = [UIColor blackColor];
        _loginModuleTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _loginModuleTextColor = [UIColor whiteColor];
    }
    return _loginModuleTextColor;
}
- (UIColor *)loginModuleDetailTextColorIsAlphaEighty{
    if (!_loginModuleDetailTextColorIsAlphaEighty) {
        _loginModuleDetailTextColorIsAlphaEighty = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
//        _loginModuleDetailTextColorIsAlphaEighty = [UIColor blackColor];
        _loginModuleDetailTextColorIsAlphaEighty = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    }
    if (self.type==ThemeType_Drak) {
        _loginModuleDetailTextColorIsAlphaEighty = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    }
    return _loginModuleDetailTextColorIsAlphaEighty;
}
- (UIColor *)loginModuleDetailTextColorIsAlphaFifty{
    if (!_loginModuleDetailTextColorIsAlphaFifty) {
        _loginModuleDetailTextColorIsAlphaFifty = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
//        _loginModuleDetailTextColorIsAlphaFifty = [UIColor blackColor];
        _loginModuleDetailTextColorIsAlphaFifty = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    }
    if (self.type==ThemeType_Drak) {
        _loginModuleDetailTextColorIsAlphaFifty = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    }
    return _loginModuleDetailTextColorIsAlphaFifty;
}

#pragma mark == main 主题色
//Y_RGBA(240, 241, 246, 1);  #F0F1F6  主背景底色 非白
//(0, 21, 52, 1) 重蓝色 主蓝
- (UIColor *)themeColorVCBackViewColor{
    if (!_themeColorVCBackViewColor) {
        _themeColorVCBackViewColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _themeColorVCBackViewColor = Y_RGBA(240, 241, 246, 1);//_RGBA(240, 241, 246, 1); #F0F1F6
    }
    if (self.type==ThemeType_Drak) {
        _themeColorVCBackViewColor = Y_RGBA(0, 21, 52, 1);// 重蓝色 主蓝
    }
    return _themeColorVCBackViewColor;
}

- (UIImage *)mainViewLayerContentsImg{
    if (!_mainViewLayerContentsImg) {
        _mainViewLayerContentsImg =  [UIImage imageWithColor:[UIColor whiteColor]];
    }
    if (self.type==ThemeType_White) {
//        UIImage *whiteBackImg = [UIImage imageNamed:@"mainBackImg_0.png"];// 0903白色不使用背景 使用颜色
//        _mainViewLayerContentsImg = whiteBackImg;
//        _mainViewLayerContentsImg =  [UIImage imageWithColor:self.themeColorVCBackViewColor];//0924非白色的浅色
        _mainViewLayerContentsImg =  [UIImage imageWithColor:[UIColor zy_colorWithHexString:@"#F7F7F9"]];
        if (isNil(_mainViewLayerContentsImg)) {
            _mainViewLayerContentsImg = [UIImage imageWithColor:[UIColor whiteColor]];
        }
    }
    if (self.type==ThemeType_Drak) {
//        UIImage *drakBackImg = [UIImage imageNamed:@"mainBackImg_1.png"];
//        _mainViewLayerContentsImg = drakBackImg;
//        _mainViewLayerContentsImg = [UIImage imageNamed:@"mainBackImg_1.png"];
        _mainViewLayerContentsImg =  [UIImage imageWithColor:[UIColor zy_colorWithHexString:@"#011535"]];
        if (isNil(_mainViewLayerContentsImg)) {
            _mainViewLayerContentsImg = [UIImage imageWithColor:[UIColor blueColor]];
        }
    }
    return _mainViewLayerContentsImg;
}

#pragma mark ===
- (UIColor *)mainItemBackGroundColor{
    if (!_mainItemBackGroundColor) {
        _mainItemBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainItemBackGroundColor = self.mainItemBackGroundColor_white;
    }
    if (self.type==ThemeType_Drak) {
        _mainItemBackGroundColor = self.mainItemBackGroundColor_drak;
    }
    return _mainItemBackGroundColor;
}

//
- (UIColor *)mainItemBackGroundColor_drak{
    if (!_mainItemBackGroundColor_drak) {
        _mainItemBackGroundColor_drak = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    if (self.type==ThemeType_White) {
        _mainItemBackGroundColor_drak = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    if (self.type==ThemeType_Drak) {
        _mainItemBackGroundColor_drak = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    return _mainItemBackGroundColor_drak;
}
- (UIColor *)mainItemBackGroundColor_white{
    if (!_mainItemBackGroundColor_white) {
        _mainItemBackGroundColor_white = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainItemBackGroundColor_white = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainItemBackGroundColor_white = [UIColor whiteColor];
    }
    return _mainItemBackGroundColor_white;
}
#pragma mark === 主要文本色
- (UIColor *)mainTextColor{
    if(!_mainTextColor){
        _mainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _mainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainTextColor = [UIColor whiteColor];
    }
    return _mainTextColor;
}
- (UIColor *)mainTexDetailLightBluetColor{
    if (!_mainTexDetailLightBluetColor) {
        _mainTexDetailLightBluetColor  = Y_RGBA(195, 216, 255, 1);
    }
    if (self.type==ThemeType_White) {
        _mainTexDetailLightBluetColor = [UIColor grayColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainTexDetailLightBluetColor = Y_RGBA(195, 216, 255, 1);
    }
    return _mainTexDetailLightBluetColor;
}

- (UIColor *)mainContentBackgroundColor{//内容背景色
    if (!_mainContentBackgroundColor) {
        _mainContentBackgroundColor  = [UIColor lightGrayColor];
    }
    if (self.type==ThemeType_White) {
        _mainContentBackgroundColor = [UIColor lightGrayColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainContentBackgroundColor = Y_RGBA(17, 41, 87, 1);
    }
    return _mainContentBackgroundColor;
}
- (UIColor *)mainContentLineColor{//内容 分割线色
    if (!_mainContentLineColor) {
        _mainContentLineColor  = [UIColor lightGrayColor];
    }
    if (self.type==ThemeType_White) {
        _mainContentLineColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];;
    }
    if (self.type==ThemeType_Drak) {
        _mainContentLineColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
    }
    return _mainContentLineColor;
}

#pragma mark ===
- (UIColor *)mainSearchBarTextFieldBackGroundColor{ //主页搜索框相关色
    if (!_mainSearchBarTextFieldBackGroundColor) {
        _mainSearchBarTextFieldBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainSearchBarTextFieldBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainSearchBarTextFieldBackGroundColor = Y_RGBA(78, 121, 204, 0.4);
    }
    return _mainSearchBarTextFieldBackGroundColor;
}
- (UIColor *)mainSearchBarTextColor{
    if (!_mainSearchBarTextColor) {
        _mainSearchBarTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainSearchBarTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainSearchBarTextColor = [UIColor whiteColor];
    }
    return _mainSearchBarTextColor;
}

#pragma mark == Section Header Text
- (UIColor *)mainSectionHeaderTextColor{
    if (!_mainSectionHeaderTextColor) {
        _mainSectionHeaderTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _mainSectionHeaderTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainSectionHeaderTextColor = [UIColor whiteColor];
    }
    return _mainSectionHeaderTextColor;
}

#pragma mark === 社区趣事
- (UIColor *)mainInterestingNewsBackGroundColor{
    if (!_mainInterestingNewsBackGroundColor) {
        _mainInterestingNewsBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainInterestingNewsBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainInterestingNewsBackGroundColor = Y_RGBA(17, 41, 87, 1);
    }
    return _mainInterestingNewsBackGroundColor;
}
 
- (UIColor *)mainInterestingNewsTextColor{
    if (!_mainInterestingNewsTextColor) {
        _mainInterestingNewsTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _mainInterestingNewsTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainInterestingNewsTextColor = [UIColor whiteColor];
    }
    return _mainInterestingNewsTextColor;
}

- (UIColor *)mainInterestingNewsDetailTextColor{
    if (!_mainInterestingNewsDetailTextColor) {
        _mainInterestingNewsDetailTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _mainInterestingNewsDetailTextColor = Y_RGBA(170, 174, 185, 1);
    }
    if (self.type==ThemeType_Drak) {
        _mainInterestingNewsDetailTextColor = Y_RGBA(194, 215, 255, 1);
    }
    return _mainInterestingNewsDetailTextColor;
}

#pragma mark == main menu item

- (UIColor *)mainMenuCellFirstItemBackGroundColor{
    if (!_mainMenuCellFirstItemBackGroundColor) {
        _mainMenuCellFirstItemBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainMenuCellFirstItemBackGroundColor = Y_RGB(27, 64, 169);//(27, 64, 169 (13, 43, 131, 1)
    }
    if (self.type==ThemeType_Drak) {
        _mainMenuCellFirstItemBackGroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(Screen_W*0.25, 150) direction:IHGradientChangeDirectionUpwardDiagonalLine startColor:Color_Menu_Item_begin endColor:Color_Menu_Item_end];
    }
    return _mainMenuCellFirstItemBackGroundColor;
}
- (UIColor *)mainMenuCellOtherItemBackGroundColor{
    if (!_mainMenuCellOtherItemTextColor) {
        _mainMenuCellOtherItemTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainMenuCellOtherItemTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) { //a(26, 56, 114, 1)  ba(0, 38, 84, 1)
        _mainMenuCellOtherItemTextColor = Y_RGB(26, 56, 114);
    }
    return _mainMenuCellOtherItemTextColor;
}
//
- (UIColor *)mainMenuCellFirstItemTextColor{
    if (!_mainMenuCellFirstItemTextColor) {
        _mainMenuCellFirstItemTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainMenuCellFirstItemTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainMenuCellFirstItemTextColor = [UIColor whiteColor];
    }
    return _mainMenuCellFirstItemTextColor;
}
- (UIColor *)mainMenuCellOtherItemTextColor{
    if (!_mainMenuCellOtherItemTextColor) {
        _mainMenuCellOtherItemTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainMenuCellOtherItemTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainMenuCellOtherItemTextColor = [UIColor whiteColor];
    }
    return _mainMenuCellOtherItemTextColor;
}
#pragma mark == 紧急消息
- (UIColor *)mainUrgentCellBackGroundColor{
    if (!_mainUrgentCellBackGroundColor) {
        _mainUrgentCellBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainUrgentCellBackGroundColor =  [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainUrgentCellBackGroundColor = Y_RGB(17, 41, 87);//#112957 Y_RGB(17, 41, 87)
    }
    return _mainUrgentCellBackGroundColor;
}
- (UIColor *)mainUrgentCellTextColor{
    if (!_mainUrgentCellTextColor) {
        _mainUrgentCellTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainUrgentCellTextColor = Y_RGB(110, 114, 125);
    }
    if (self.type==ThemeType_Drak) {
        _mainUrgentCellTextColor = [UIColor whiteColor];
    }
    return _mainUrgentCellTextColor;
}
#pragma mark == 通讯录
- (UIColor *)mainAddressBookCellBackGroundColor{
    if (!_mainAddressBookCellBackGroundColor) {
        _mainAddressBookCellBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainAddressBookCellBackGroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _mainAddressBookCellBackGroundColor = Y_RGB(26, 56, 114);//rgba(26, 56, 114, 1) rgba(0, 38, 84, 1)
    }
    return _mainAddressBookCellBackGroundColor;
}
- (UIColor *)mainAddressBookCellTextColor{
    if (!_mainAddressBookCellTextColor) {
        _mainAddressBookCellTextColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _mainAddressBookCellTextColor = Y_RGB(43, 44, 47);
    }
    if (self.type==ThemeType_Drak) {
        _mainAddressBookCellTextColor = [UIColor whiteColor];
    }
    return _mainAddressBookCellTextColor;
}

#pragma mark == 访客
- (UIColor *)guestMainTextColor{
    if(!_guestMainTextColor){
        _guestMainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _guestMainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _guestMainTextColor = [UIColor whiteColor];
    }
    return _guestMainTextColor;
}
- (UIColor *)guestAccompanyNavViewMainTextColor{
    if(!_guestAccompanyNavViewMainTextColor){
        _guestAccompanyNavViewMainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _guestAccompanyNavViewMainTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_Drak) {
        _guestAccompanyNavViewMainTextColor = [UIColor whiteColor];
    }
    return _guestAccompanyNavViewMainTextColor;
}
- (UIColor *)guestDetailTextColor{
    if(!_guestDetailTextColor){
        _guestDetailTextColor = Y_RGBA(170, 174, 185, 1);
    }
    if (self.type==ThemeType_White) {
        _guestDetailTextColor = Y_RGBA(170, 174, 185, 1);
    }
    if (self.type==ThemeType_Drak) {
        _guestDetailTextColor = [UIColor whiteColor];
    }
    return _guestDetailTextColor;
}

- (UIColor *)guestAccompanyNavViewMainDetailTextColor{
    if(!_guestAccompanyNavViewMainDetailTextColor){
        _guestAccompanyNavViewMainDetailTextColor = [UIColor blackColor];
    }
    if (self.type==ThemeType_White) {
        _guestAccompanyNavViewMainDetailTextColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    }
    if (self.type==ThemeType_Drak) {
        _guestAccompanyNavViewMainDetailTextColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
    }
    return _guestAccompanyNavViewMainDetailTextColor;
}
#pragma mark == 菜单 更多 全部分类
- (UIColor *)meueMoreVcBackgroundColor{// 菜单 更多vc背景色
    if (!_meueMoreVcBackgroundColor) {
        _meueMoreVcBackgroundColor  = Y_RGBA(245, 245, 245, 1);
    }
    if (self.type==ThemeType_White) {
        _meueMoreVcBackgroundColor = Y_RGBA(245, 245, 245, 1);
    }
    if (self.type==ThemeType_Drak) {
        _meueMoreVcBackgroundColor = Y_RGBA(0, 15, 38, 1);
    }
    return _meueMoreVcBackgroundColor;
}
- (UIColor *)meueMoreContentItemBackgroundColor{// 菜单 更多vc item内容背景色
    if (!_meueMoreContentItemBackgroundColor) {
        _meueMoreContentItemBackgroundColor  = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _meueMoreContentItemBackgroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _meueMoreContentItemBackgroundColor = Y_RGBA(17, 41, 87, 1);
    }
    return _meueMoreContentItemBackgroundColor;
}

//来访 编辑界面
- (UIColor *)guestInfoRegisterVcBackgroundColor{
    if (!_guestInfoRegisterVcBackgroundColor) {
        _guestInfoRegisterVcBackgroundColor = Y_RGBA(240, 241, 246, 1);
    }
    if (self.type==ThemeType_White) {
        _guestInfoRegisterVcBackgroundColor = Y_RGBA(240, 241, 246, 1);
    }
    if (self.type==ThemeType_Drak) {
        _guestInfoRegisterVcBackgroundColor = Y_RGBA(0, 15, 38, 1);
    }
    return _guestInfoRegisterVcBackgroundColor;
}
- (UIColor *)guestInfoRegisterContentCellBackgroundColor{
    if (!_guestInfoRegisterContentCellBackgroundColor) {
        _guestInfoRegisterContentCellBackgroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_White) {
        _guestInfoRegisterContentCellBackgroundColor = [UIColor whiteColor];
    }
    if (self.type==ThemeType_Drak) {
        _guestInfoRegisterContentCellBackgroundColor =  Y_RGBA(17, 41, 87, 1);
    }
    return _guestInfoRegisterContentCellBackgroundColor;
}

//业主 城市社区等层级选择 界面
- (UIColor *)chooseUserCityAndOtherVcBackgroundColor{
    if (!_chooseUserCityAndOtherVcBackgroundColor) {
        _chooseUserCityAndOtherVcBackgroundColor = [UIColor whiteColor];;
    }
    if (self.type==ThemeType_White) {
        _chooseUserCityAndOtherVcBackgroundColor = [UIColor whiteColor];;
    }
    if (self.type==ThemeType_Drak) {
        _chooseUserCityAndOtherVcBackgroundColor = Y_RGBA(0, 15, 38, 1);
    }
    return _chooseUserCityAndOtherVcBackgroundColor;
}
 
@end
