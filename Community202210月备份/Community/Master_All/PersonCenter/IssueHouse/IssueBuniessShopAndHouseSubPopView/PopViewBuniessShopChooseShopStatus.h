//
//  PopViewBuniessShopChooseShopStatus.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
// 状态   0空置中  1营业中

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopViewBuniessShopChooseShopStatus : BasePopTableView
@property (nonatomic,strong) NSString *headertitleStr;
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array withHeaderViewTitle:(NSString *)titleStr withNowShowRowNum:(NSInteger)showRowIndex;
@end

#pragma mark ==== cell
@interface PopViewSubShopStatusCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *centerShowBtn;

@end

NS_ASSUME_NONNULL_END
