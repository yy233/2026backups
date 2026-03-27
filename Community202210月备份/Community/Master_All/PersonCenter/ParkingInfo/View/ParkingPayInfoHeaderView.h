//
//  ParkingPayInfoHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^HeaderViewTouchUpIndexBlock)(NSInteger);

@interface ParkingPayInfoHeaderView : UIView
@property (nonatomic,copy) HeaderViewTouchUpIndexBlock touchUpBlock;
@end

NS_ASSUME_NONNULL_END
