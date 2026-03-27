//
//  LifeCostPayActionSuccessOrFailWebVC.h
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayActionSuccessOrFailWebVC : BaseViewController

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NSString *payActionPlaceOrderEndGetUrlStr;
@property (nonatomic,strong) NSString *orderNoStr;
@end

NS_ASSUME_NONNULL_END
