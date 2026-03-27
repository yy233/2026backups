//
//  IssueHouseManagerVcHouseTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import <UIKit/UIKit.h>
#import "IssueBuniessShopManagerListUseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IssueHouseManagerVcHouseTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *mongyL;
@property (nonatomic,strong) UIView *centerSubsBackView;
@property (nonatomic,strong) UIView *blueSubsBackView;//用于占位 暂时1 子类另作处理
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *detailTipL;
@property (nonatomic,strong) UIButton *editBtn;

@property (nonatomic,strong) IssueBuniessShopManagerListUseModel *model;
@end

NS_ASSUME_NONNULL_END
