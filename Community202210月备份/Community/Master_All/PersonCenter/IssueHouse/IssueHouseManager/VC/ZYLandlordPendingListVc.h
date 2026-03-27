//
//  ZYLandlordPendingListVc.h
//  Community
//
//  Created by ZY on 2021/9/10.
//  房东待处理列表

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLandlordPendingListVc : ZYBaseViewController

@property (nonatomic, assign) NSInteger assetType;

@property (nonatomic, copy) NSString *assetId;

@property (nonatomic, assign) NSInteger contractStatus;

@end

NS_ASSUME_NONNULL_END
