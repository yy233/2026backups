//
//  TabBarController.h
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TabBarSubVc_Num_Commounity,
//    TabBarSubVc_Num_Shop,
    TabBarSubVc_Num_Qianzhang,
    TabBarSubVc_Num_Mine,
} TabBarSubVc_Num;

//商城暂时隐藏

@interface TabBarController : UITabBarController
@property (nonatomic,assign) NSInteger oldSelectIndex;//记录当前点击到的index
- (void)tabbarChangImgWhenTypechanged;//主题色更改时调用 暂未在外部调用
@end

NS_ASSUME_NONNULL_END
