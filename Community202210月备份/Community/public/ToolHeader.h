//
//  ToolHeader.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#ifndef ToolHeader_h
#define ToolHeader_h
#pragma mark ===

#ifdef __OBJC__
 
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+MJExtension.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"//sd
#import "UIButton+WebCache.h" //sd
#import "IQKeyboardManager.h"
#import "SDCycleScrollView.h"
#import "SGAdvertScrollView.h"
#import "YYModel.h"
#import "YYCache.h"
#import "YYText.h"
#import "UIImageView+CornerRadius.h"
#import "UITableView+FDTemplateLayoutCell.h"
//#import "YYCategories.h"
#import "NSObject+YYModel.h"
#import "SMSCodeInputView.h"
#import "TMMuiLazyScrollView.h"
#import "BRPickerView.h"
#import "ScanHelper.h"
#import "TZImagePickerController.h"
#import "GKPhotoBrowser.h"
#import "CustomPopOverView.h"
//筛选1类 弃用
#import "GHDropMenu/GHDropMenuHeader.h"
#import "GHDropMenuHeader.h"
#import "GHDropMenu.h"
#import "GHDropMenuModel.h"
//筛选2类
#import "WMZDropDownMenu.h"
#import "WMZDropDwonMenuConfig.h"
//语音录音播放和转换三方
#import "LGAudioKit.h"
#import "CreatQrCodeImgTool.h"
//折线图
#import "PNChart.h"
#import "AAChartKit.h"
//图标集合视图
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

// 在发布版导入处理数组越界和字典crash处理库
#ifndef DEBUG
#import "SafeObject.h"
#endif
// 在发布版导入处理nil对象发送消息crash处理库
#ifdef DEBUG
#define NULLSAFE_ENABLED 0
#endif

#pragma mark ==== Tools
#import "Tool.h"
#import "VersionInfoTool.h"
#import "ToolOfTimeChangeFormat.h"
#import "TextShowWithModelStr.h"
#import "ValidateUtil.h"
#import "NSObject+Utils.h"
#import "UIImage+Color.h"
#import "UIColor+Gradient.h"
#import "UIButton+ChangeHitInsets.h"
#import "UIView+SubView.h"
#import "UITextField+CleanBtnImg.h"
#import "UITextField+PlaceholderNewColor.h"
#import "UIButton+RefreshLocation.h"
#import "UIButton+ButtonEdgeInset.h" 
#import "ImageGetWithString.h"
#import "StrEncodeAndDecodeWithChangeChinese.h" //图片时用到的转字符
#import "UrlWithString.h"
#import "ImgSetSize.h"
#import "UIView+RounderCorner.h"
#import "EBDropdownListView.h"
#import "UIButton+NewAnBtn.h"
#import "AESUtil.h"
#import "ZYSignatureEncryptionTool.h"
#import "ZYRealNameAuthenticationTool.h"
#import "SVProgressHUD+CustomHUD.h"
#import "ZYImageCompressTool.h"
#import "ZYDeviceInfoTool.h"
#import "ZYKeychainTool.h"
#import "ZYIPAdressTool.h"
#import "ZYLocationInfoTool.h"
#import "XHDate.h"
#import "ZYTextValidationTool.h"
#import "NSString+ReplceStr.h"
#import "VersionShowOrHiddenTool.h"
#import "UIView+ZYCornerRadius.h"
#import "ZYProgressHUDTool.h"
#import "UIColor+ZYHexString.h"
#import "AlertManager.h"
#import "ImagePickerManager.h"
#import "ZYCaschesTool.h"
#import "ZYAmountCapitalTool.h"
#import "ZYValidInputTextTool.h"
#import "SaveScreenViewImgToLocalTool.h" //保存到本地相册
#import "YYWebImage.h"
#import "ZYWeekStringTool.h"
#import "ZYFormatStringTool.h"
#import "ZYHidePartTool.h"
#import "ZYAuthorizationManager.h"
#import "ZYSmallShopImageUrlSegmentationTool.h"
#import "ZYDecimalNumberTool.h"
#import "ZYWebUrlToDictTool.h"

//chat 聊天
#import "ChatTypeHeader.h"
#import "ChatVcUseBaseHeader.h"


#pragma mark === thirdsdk
#import "WXApi.h"


#import <AlipaySDK/AlipaySDK.h>

 
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>


#endif
#endif /* ToolHeader_h */
