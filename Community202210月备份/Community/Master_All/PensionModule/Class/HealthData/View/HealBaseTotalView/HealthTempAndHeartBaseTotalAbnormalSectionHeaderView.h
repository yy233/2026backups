//
//  HealthTempAbnormalSectionHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchThisSectionHeaderViewSubBtnBlock)(void);

@interface HealthTempAndHeartBaseTotalAbnormalSectionHeaderView : UIView
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *lineV;

@property (nonatomic,copy) TouchThisSectionHeaderViewSubBtnBlock touchSubBtnBlcok;
@end

NS_ASSUME_NONNULL_END
