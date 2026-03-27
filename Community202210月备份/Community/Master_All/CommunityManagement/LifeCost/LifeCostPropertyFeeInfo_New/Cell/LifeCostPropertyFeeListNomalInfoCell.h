//
//  LifeCostPropertyFeeListNomalInfoCell.h
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *LifeCostPropertyFeeListNomalInfoCell_I = @"LifeCostPropertyFeeListNomalInfoCell";
static NSString *LifeCostPropertyFeeListChooseBtnAndInfoCell_I = @"LifeCostPropertyFeeListChooseBtnAndInfoCell";
static NSString *LifeCostPropertyFeeListCenterShowMonthInfoCell_I = @"LifeCostPropertyFeeListCenterShowMonthInfoCell";


@interface LifeCostPropertyFeeListNomalInfoCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *typeNameL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIImageView *rigntImgV;
@end


typedef void(^GouXuanBlock)(BOOL isSelected);

@interface LifeCostPropertyFeeListChooseBtnAndInfoCell : LifeCostPropertyFeeListNomalInfoCell

@property (nonatomic,strong) UIButton *leftChooseBtn;

@property (nonatomic,copy) GouXuanBlock gouXuanBlock;
@end



@interface LifeCostPropertyFeeListCenterShowMonthInfoCell : BaseTableViewCell 
@property (nonatomic,strong) UILabel *centerL;
@end

NS_ASSUME_NONNULL_END
