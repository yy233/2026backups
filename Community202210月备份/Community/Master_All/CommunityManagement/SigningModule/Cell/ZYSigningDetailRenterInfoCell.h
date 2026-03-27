//
//  ZYSigningDetailRenterInfoCell.h
//  Community
//
//  Created by ZY on 2021/8/19.
//

#import <UIKit/UIKit.h>
#import "ZYSigningDetailModel.h"

@protocol ZYSigningDetailRenterInfoCellDelegate <NSObject>

- (void)landlordTelLabelEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYSigningDetailRenterInfoCell : UITableViewCell

@property (nonatomic, strong) ZYSigningDetailDataModel *model;

@property (nonatomic, weak) id<ZYSigningDetailRenterInfoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
