//
//  LifeCostMyCostSectionHeaderTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LifeCostMyCostSectionHeaderTableViewCellShouFangBtnBlock)(void);
typedef void(^LifeCostMyCostSectionHeaderTableViewCellEditBtnBlock)(void);


@interface LifeCostMyCostSectionHeaderTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *souFangBtn;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,copy) LifeCostMyCostSectionHeaderTableViewCellShouFangBtnBlock souFangBtnBlock;
@property (nonatomic,copy) LifeCostMyCostSectionHeaderTableViewCellEditBtnBlock editBtnBlock;
- (void)fillBtnShowAddressStr:(NSString *)addressStr;
- (void)fillBtnShowSouFangBool:(BOOL)soufangBool;
@end

NS_ASSUME_NONNULL_END
