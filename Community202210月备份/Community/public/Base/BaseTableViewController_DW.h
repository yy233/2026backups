//
//  BaseTableViewController_DW.h
//  Community
//
//  Created by 余莹 on 2021/9/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController_DW : UITableViewController
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色 //主题色 深色不变 浅色主题时 nav为非白
- (void)pushVc:(id)vc;
- (void)popVC;

- (void)setupNavigationBarWhiteTextColorWithBackViewCustomColor:(UIColor *)customColor;
- (void)setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw;//主题色 深色不变 浅色主题时 nav为白色

- (void)reloadRowNum:(NSInteger)rowNum;
@end

NS_ASSUME_NONNULL_END
