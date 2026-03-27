//
//  ZYISIPhoneXAllTool.h
//  Community
//
//  Created by ZY on 2021/4/11.
//

#ifndef ZYISIPhoneXAllTool_h
#define ZYISIPhoneXAllTool_h

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

//// 判断是否是iPhone X XR Xs Max 11 11Pro 11ProMax 12mini 12 12Pro 12ProMax
//#define isIphoneX ((((kScreenW == 375) && (kScreenH == 812)) || ((kScreenW == 414) && (kScreenH == 896)) || ((kScreenW == 360) && (kScreenH == 780)) || ((kScreenW == 390) && (kScreenH == 844)) || ((kScreenW == 428) && (kScreenH == 926))) ? 1 : 0)
// 判断是否为iPhone X 系列
#define isIphoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})
// status bar
#define status_height (isIphoneX ? 44.f : 20.f)
// home indicator
#define bottom_height (isIphoneX ? 34.f : 0.f)
// iphone X XR Xs Max 底部
#define bar_bottom_height (isIphoneX ? 83.f : 49.f)
// button底部高度
#define button_bottom_height (isIphoneX ? 20.f : 0.f)

#endif /* ZYISIPhoneXAllTool_h */
