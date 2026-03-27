//
//  Y_BaseTableViewController.h
//  Socialize
//
//  Created by 余莹 on 2023/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Y_BaseTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)setupNavigationBarStyleWithColor;
- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;
- (void)setupNavigationBarblackTextColorWithBackViewCustomColor:(UIColor *)customColor;
/// 设置navigationBar为透明色
- (void)setupNavigationBarTransparentStyle;
- (void)pushVc:(id)vc;
- (void)popVC;

#pragma mark - 设置navigationBar为透明色_黑白两文本
- (void)setup_NavigationBar_TransparentBk_whiteText;
- (void)setup_NavigationBar_TransparentBk_blackText;

@end

NS_ASSUME_NONNULL_END
