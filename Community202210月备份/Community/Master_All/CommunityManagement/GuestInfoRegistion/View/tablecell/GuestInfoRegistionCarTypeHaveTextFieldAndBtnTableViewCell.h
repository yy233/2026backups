//
//  GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import <UIKit/UIKit.h>
#import "UserCertificationTextTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^TouchTextFiledTopBtnActionBlock)(void);

@interface GuestInfoRegistionCarTypeHaveTextFieldAndBtnTableViewCell : UserCertificationTextTableViewCell
@property (nonatomic,strong) UIButton *chooseWithCarListShowOrHidenBtn;//上下键 控制 历史访客车辆列表数据展示

@property (nonatomic,copy) TouchTextFiledTopBtnActionBlock touchTextFiledTopBtnActionBlock;
@end

NS_ASSUME_NONNULL_END
