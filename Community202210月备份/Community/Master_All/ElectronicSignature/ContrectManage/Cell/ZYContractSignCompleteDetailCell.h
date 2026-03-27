//
//  ZYContractSignCompleteDetailCell.h
//  Community
//
//  Created by ZY on 2021/5/26.
//

#import <UIKit/UIKit.h>
#import "ZYContrectAllListModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYContractSignCompleteDetailCellDelegate <NSObject>

- (void)contractViewTapEvent;

@end


@interface ZYContractSignCompleteDetailCell : UITableViewCell

@property (nonatomic, strong) ZYContrectAllListDataListModel *model;

@property (nonatomic, weak) id<ZYContractSignCompleteDetailCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
