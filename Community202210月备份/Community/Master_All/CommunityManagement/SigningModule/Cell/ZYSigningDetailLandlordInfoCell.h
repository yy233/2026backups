//
//  ZYSigningDetailLandlordInfoCell.h
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import <UIKit/UIKit.h>
#import "ZYSigningDetailModel.h"

@protocol ZYSigningDetailLandlordInfoCellDelegate <NSObject>

- (void)telLabelEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYSigningDetailLandlordInfoCell : UITableViewCell

@property (nonatomic, strong) ZYSigningDetailDataModel *model;

@property (nonatomic, weak) id<ZYSigningDetailLandlordInfoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
