//
//  ZYHealthDataDeviceCell.h
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DisConnectedActionBlock)(void);

@interface ZYHealthDataDeviceCell : UITableViewCell
@property (nonatomic,strong) UIButton *disConBtn;//断开连接按钮
@property (nonatomic,copy) DisConnectedActionBlock disConActionBlock;
- (void)nowDevNameSet:(NSString *)devNameStr;
@end

NS_ASSUME_NONNULL_END
