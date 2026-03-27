//
//  ZYMyRepairShowDetailFollowUpInfoHeaderView.h
//  Community
//
//  Created by ZY on 2022/4/13.
//

#import <UIKit/UIKit.h>
#import "ZYMyRepairShowDetailFollowUpInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMyRepairShowDetailFollowUpInfoHeaderView : UIView

@property (nonatomic, strong) ZYMyRepairShowDetailFollowUpInfoModel *model;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@end

NS_ASSUME_NONNULL_END
