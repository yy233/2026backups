//
//  BaseTableViewControllerNotNoticeWithUI.h
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewControllerNotNoticeWithUI : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)setupNavigationBarWithBackItemHaveTitleWithStr:(NSString *)titleStr;
- (void)setupNavigationBarWithBackItemNoTitle;
- (void)setupNavigationBarWhiteStyle;
- (void)setupNavigationBarTransparentStyle;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色
- (void)setupNavigationBarBlackStyle;
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomColor:(UIColor *)customColor;
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomBeginColor:(UIColor *)customBeginColor andBackViewCustomEndColor:(UIColor *)customEndColor andSize:(CGSize)custimSize;
- (void)setupNavigationBarTextColor:(UIColor *)titleTextColor andBarItemsColor:(UIColor *)itemsTintColor andBackViewCustomImg:(UIImage *)cImg;
- (void)setupsetupNavigationBarWithChatVcStyle;//聊天的nav渐变色
- (void)pushVc:(id)vc;
- (void)popVC;
@end

NS_ASSUME_NONNULL_END
