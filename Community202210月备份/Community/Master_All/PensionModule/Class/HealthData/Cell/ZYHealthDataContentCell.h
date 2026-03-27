//
//  ZYHealthDataContentCell.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>
#import "ZYHealthDataContentModel.h"
#import "BaseHealthHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYHealthDataContentCell : UITableViewCell

@property (nonatomic, strong) ZYHealthDataContentModel *model;
- (void)changeCellHealthStatusWithType:(HealthShow_Type)type;
- (void)setCellShowNum:(NSNumber *)numb;

@end

NS_ASSUME_NONNULL_END
