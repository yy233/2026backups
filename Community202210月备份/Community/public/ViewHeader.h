//
//  ViewHeader.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#ifndef ViewHeader_h
#define ViewHeader_h
#pragma mark == base
#import "BaseTableViewFooterView.h"
#import "ElectronicSignatureBaseFooterView.h"
#import "BasePopView.h"
#import "BasePopTableView.h"
#import "BaseTableViewCell.h"
#import "YBtnWithGesture.h"
#import "PopViewChangeHouse.h"//切换房屋
#import "LabelYu.h"
#import "ZYEmptyDataTableView.h"
#import "ZYEmptyDataCollectionView.h"
#import "GotoRealNameAuthenticationCardVcTool.h"//是否要去实名界面的相关方法
#import "SignShowOfGoToTheStoreToUpdateTheVersion.h"//提示app版本的更新
#import "PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView.h" //协议更新
#define  signShowOfGoToTheStoreToUpdateTheVersion_Tag  (7777)
#define  PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView_Tag  (8888)
#define  PrivacyAgreementUserAgreementHaveNewVersionWithShowDetailView_BaseTag  (8000)

//static CGFloat k_ChatViewBottomEmj_OneItem_W_H = 35;//(Screen_W-11)/10;//横向 每行 10个 带冗余间距
#define k_ChatViewBottomEmj_OneItem_W_H  ((Screen_W-11)/10)

#define Color_245Gray                                    Y_RGBA(245, 245, 245, 1)
#define Color_238GrayColor                               Y_RGBA(238, 238, 238, 1)
#define Color_138GrayColor                               Y_RGBA(138, 138, 138, 1)
#define Color_136GrayColor                               Y_RGBA(136, 136, 136, 1)
#define Color_153GrayColor                               Y_RGBA(153, 153, 153, 1)
#define Color_38BlueColor                                Y_RGBA(38, 114, 249, 1)
#define Color_51BlackColor                               Y_RGBA(51, 51, 51, 1)
#define Color_58BlueBlackColor                           Y_RGBA(58, 71, 109, 1)
#define Color_11BlueColor                                Y_ColorWith16FromRGB(0x112957)

#define Color_102Gray                                    Y_RGBA(102, 102, 102, 1)

#define kMinAspectRatio 0.8
#define kMaxAspectRatio 1.6

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

#pragma mark ===  view
#import "LoginView.h"
#import "RegistView.h"
#import "FirstPassWordSetView.h"
#import "ResetPasswordView.h"
#import "NewPassWordSetView.h"
#import "BindingPhoneView.h"
#import "InputCodeView.h"

#define Main_BackBtnImg_BlackColor              [UIImage imageNamed:@"mainBack_skip_fanhui_BlackColor"]
#define Main_BackBtnImg_wColor                  [UIImage imageNamed:@"mainBack_skip_fanhui_wColor"]

#define Main_OwnImg                             [UIImage imageNamed:@"My_headportrait"]
#define Main_PlaceholderImg_WeqH                [UIImage imageNamed:@"cc_placeholder"]
#pragma mark ===== main---1

#import "PopViewAddressBookDetaillPhoneList.h"//部门通讯录列表 
 
//--tableCell
#import "MainTableViewTopBannerCell.h"
#import "MainTableViewCenterMenuCell.h"
#import "MainTableViewCenterBannerCell.h"
#import "MainTableViewAddressBookCell.h"
#import "MainTableViewShoppingCell.h"
#import "MainTableViewInterestingNewsCell.h"
#import "MainTableViewRecommendedServiceWeatherCell.h"
#import "MainTableViewRecommendedServiceHourseEstateCell.h"
#import "MainTableViewConvenienceServiceCell.h"
#import "MainTableViewPersionAndMedicalTableViewCell.h"//医疗养老
#import "MainTableViewTopMenuCell.h"  //07后版本 菜单cell
#import "MainLateMyServiceCell.h" //我的服务 cell
#import "MainLateShengHuoGuangChangCell.h"// 生活广场 cell
#import "ZYCommunityManagementMainSpellGroupCell.h"// 拼团 cell

//--collectionCell
#import "MainCenterCollectionViewCell.h"
#import "MainCenterAddressBookCollectionViewCell.h"
#import "MainCenterShoppingCollectionViewCell.h"

//--main_view
#import "MainTableViewHeaderView.h" //搜素框的
#import "MainSectionHeaderViewTextLabel.h"//透明的仅仅label
#import "SectionHeaderViewWithTextLabel.h" //城市选择的 组header 字体颜色大小非主要级别
#import "SectionHeaderView.h" //组header 字体颜色主级别




//sub-v
#import "TopCityTableViewCell.h"
#import "CityChooseHeadView.h"
#import "ChooseBaseHeaderViewOfSearchBar.h"
#import "ChooseBaseHeaderViewOfRightAndSearchBar.h"
#import "SectionHeaderViewWithTextLabel.h"


//UserInfoRegistVC_sub
#import "UserInfoRegistVCTableViewCell.h"

//GuestInfoRegistionVC_sub
#import "GuestInfoRegistionTableViewCell.h"

//房屋报告修
#import "HouseRepairListVCHeaderView.h"
#import "HouseRepairListVcFooterView.h"
#import "HouseRepairDetailShowBaseTableViewCell.h"
#import "HouseRepairDetailInfoCellSubTextTableViewCell.h"
#define HouseRepairDetailInfoCellSubTextTableViewCell_Identifier             @"HouseRepairDetailInfoCellSubTextTableViewCell"
#define HouseRepairDetailInfoCellSubTextAndRightBtnTableViewCell_Identifier  @"HouseRepairDetailInfoCellSubTextAndRightBtnTableViewCell"


//投诉建议

//个人中心
//--商铺租赁——新增
#import "PopViewBuniessShopChooseFloor.h"
#import "PopViewBuniessShopChooseShopPublishTypes.h"
#import "PopViewBuniessShopChooseShopStatus.h"
#import "PopViewBuniessShopAndHouseChoosePayWay.h"

//vip会员
#import "VipBaseCollectionViewCell.h"
//订单
#import "MyOrderListVcCellDelegate.h"
#import "MyOrderListVcMaxDishesTableViewCell.h"
#import "MyOrderListVcDishesTableViewCell.h"

#define Tourists_LoginTokenStr @"00000tourist" // 游客
#pragma mark ===== BTN_TAG
#define REMOVE_SELF_BTN_TAG 209
//登录
#define LOGIN_BTN_TAG_CODE_GetCode 198 //验证码登录_验证码btn
#define LOGIN_BTN_TAG_CODE_LOGIN   199 //验证码登录_登录btn
#define LOGIN_BTN_TAG              200 //登录
#define LOGIN_SUBBTN_GO_REGIST_VC_BTN_TAG          201 //注册
#define LOGIN_SUBBTN_GO_USE_CODE_LOGIN_VC_BTN_TAG  202//短信验证码登录
#define FORGET_PASSWORD_TAG 203 //忘记密码

#define WXLOGIN_BTN_TAG 204
#define ZFBLOGIN_BTN_TAG 205
//#define QQLOGIN_BTN_TAG 206
#define APPLELOGIN_BTN_TAG 206
#define Privacypolicy_CHOOSE_BTN_TAG 207

//注册
#define REGIST_VerificationCode_BTN_TAG 210
#define REGIST_OK_BTN_TAG 211
#define REGIST_GOLOGINVC_BTN_TAG 212
#define REGIST_PRARVACY_BTN_TAG 213
//首次设密码
#define REGIST_SET_PASSWORD_FINISH_BTN_TAG 220


//重置密码
#define RESET_PASSWORD_NEXT_BTN_TAG 230
#define RESET_PASSWORD_CODE_BTN_TAG 231
//重置密码 --新密码
#define RESET_PASSWORD_FINISH_BTN_TAG 232
#define RESET_PASSWORD_CANCEL_BTN_TAG 233
#define RESET_PASSWORD_PRARVACY_BTN_TAG 234

#pragma mark ===== Main_View_TAG
#define MainScrollView_TAG 300
#define MainTableView_TAG 301

#define MainTopCycleScrollView_TAG 350
#define MainCenterAdvertScrollView_TAG 351

#define TAG_PopTableView_PhoneList 900 //通讯录

#pragma mark ===== Main_View_SUB_TAG
#define Main_SUB_CityChoose_TopCityItem_TAG 400

static NSString * _Nullable kLifeCost_Placeholder_ImgName = @"morenjiaofei_icon";
static NSString * _Nullable kLifeCost_Placeholder_NotBackColor_ImgName = @"lift_notBackColor_moren_Bigicon"; //@"lift_notBackColor_moren_icon";

 
#pragma mark ====
#define Please_enter_phone_number @"请输入手机号"
#define Please_enter_password_number @"请输入密码"
#define Please_enter_code_number @"请输入验证码"
#define PASSWORD_ERR_IS_DIFFERENT_STR @"两次密码不匹配"
#define PASSWORD_ERR_FORMAT_STR @"错误的密码格式"
#define Str_Girl     @"女"
#define Str_Boy      @"男"
#define Str_Gender_Nomal    @"保密"

#pragma mark === color

//家属关系的颜色
#define Color_Gender_boy_backV  Y_RGBA(207, 224, 255, 1)
#define Color_Gender_girl_backV  Y_RGBA(255, 218, 218, 1)
#define Color_Gender_boy_text  Y_RGBA(18, 102, 253, 1);
#define Color_Gender_girl_text  Y_RGBA(249, 105, 105, 1);
 
 
#define Color_Blue   Y_ColorWith16FromRGB(0x255fff)//主要颜色——蓝色
#define Color_Orange Y_ColorWith16FromRGB(0xff8a2b)//辅助色——橘色?绿色
#define Color_Green  Y_ColorWith16FromRGB(0x16d6b7)//配色——绿色
#define Color_Red    Y_ColorWith16FromRGB(0xff0033)//配色——红色
 
#define Text_Color_Primary_Back         Y_ColorWith16FromRGB(0x2b2c2f)//主要颜色——黑色文本
#define Text_Color_Auxiliary_Gray       Y_ColorWith16FromRGB(0x6e727d)//辅助色——灰色副文本
#define Text_Color_Auxiliary_LightGray  Y_ColorWith16FromRGB(0xaaaeb9)//配色——浅灰色——默认文字
#define Line_Color_LightGray            Y_ColorWith16FromRGB(0xc5c9d4)//配色——浅浅灰色——分割线
#define Color_Line_LigntGray              Y_ColorWith16FromRGB(0xF0F1F6)
#define BackGround_Color_LightGray       Y_ColorWith16FromRGB(0xf0f1f6)//配色——浅浅浅灰色——背景色

#pragma mark === color
#define LoginBtnBeginColor [UIColor colorWithRed:60/255.0 green:156/255.0 blue:255/255.0 alpha:1.0]
#define LoginBtnEndColor [UIColor colorWithRed:37/255.0 green:95/255.0 blue:255/255.0 alpha:1.0]
#define LoginViewBtnGradientColor(width,height) [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:LoginBtnBeginColor endColor:LoginBtnEndColor]

#define Y_Gradient_Color(width,height,_BeginColor,_EndColor) [UIColor bm_colorGradientChangeWithSize:CGSizeMake(width, height) direction:IHGradientChangeDirectionLevel startColor:_BeginColor endColor:_EndColor]

#define Color_TextFieldBottomLine Y_RGB(111, 124, 144) //登录模块的线 Y_RGB(235, 235, 235)
#define Color_MainVC_BackGround Y_RGB(245, 245, 245)


#pragma mark =====
/** 屏幕宽高*/
#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

/** 状态栏高度 */
#define KStatusBarHeight ((IPHONE_X) ? 44 : 20)

/** 导航栏高度 */
#define KNavBarHeight ((IPHONE_X) ? 88 : 64)

/** 标签栏高度 */
#define KTabBarHeight ((IPHONE_X) ? 83 : 49)

/** 底部横条高度 */
#define KIndicatorHeight ((IPHONE_X) ? 34 : 0)

/** iPhoneX判断 */
#define KIphoneX (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size))

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


// RGB颜色
#define Y_ColorWith16FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Y_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Y_RGB(r,g,b)  Y_RGBA(r,g,b,1.0f)

 
#endif /* ViewHeader_h */
