//
//  InformationOrScanGoToWebVc.h
//  Community
//
//  Created by 余莹 on 2021/10/14.
// 家属 得到通知或二维码 跳转webview 做绑定操作（本界面需要带着 二维码中/informtion里面的键值 id信息电话信息）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InformationOrScanGoToWebVc : UIViewController
@property (nonatomic,strong)   WKWebView        *webView;
//绑定操作方需要提交的数据
/** 1021 不做每个键值(infoIdStr phoneStr)的拼接 只做url的全部赋过去
 */
//@property (nonatomic,strong) NSString *infoIdStr;
//@property (nonatomic,strong) NSString *phoneStr;
@property (nonatomic,strong) NSString *httpAllUseStr;
@end

NS_ASSUME_NONNULL_END
