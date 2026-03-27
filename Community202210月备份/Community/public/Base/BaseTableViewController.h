//
//  BaseTableViewController.h
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

- (void)setupNavigationBarWhiteStyle ;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色 //主题色 深色不变 浅色主题时 nav为非白
- (void)pushVc:(id)vc;
- (void)popVC;

- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;
- (void)setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw;//主题色 深色不变 浅色主题时 nav为白色

- (void)reloadRowNum:(NSInteger)rowNum;

- (void)vcSelfBackgroundColorOfThemeColorVcBack;//不需要主题颜色的重写即可
@end

NS_ASSUME_NONNULL_END
