//
//  ZYRentContractDetailBottomView.h
//  Community
//
//  Created by ZY on 2021/8/21.
//

#import <UIKit/UIKit.h>
#import "ZYSigningDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYRentContractDetailBottomViewDelegate <NSObject>

// 区块链司法存证
- (void)depositCertificateButtonClickedEvent;

// 下载合同
- (void)downloadContractButtonClickedEvent;

// 状态按钮回调
- (void)statusButtonEventWithIndex:(NSInteger)index;

@end

@interface ZYRentContractDetailBottomView : UIView

@property (nonatomic, strong) ZYSigningDetailDataModel *model;

@property (nonatomic, weak) id<ZYRentContractDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
