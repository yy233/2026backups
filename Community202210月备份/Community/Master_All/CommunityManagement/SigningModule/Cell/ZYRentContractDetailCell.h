//
//  ZYRentContractDetailCell.h
//  Community
//
//  Created by ZY on 2021/8/21.
//

#import <UIKit/UIKit.h>
#import "ZYSigningDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYRentContractDetailCellDelegate <NSObject>

// 查看合同
- (void)nameContentViewTapEvent;

@end

@interface ZYRentContractDetailCell : UITableViewCell

@property (nonatomic, strong) ZYSigningDetailDataModel *model;

@property (nonatomic, weak) id<ZYRentContractDetailCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
