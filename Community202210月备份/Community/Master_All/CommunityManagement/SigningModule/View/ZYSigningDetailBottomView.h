//
//  ZYSigningDetailBottomView.h
//  Community
//
//  Created by ZY on 2021/8/18.
//

#import <UIKit/UIKit.h>
#import "ZYSigningDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSigningDetailBottomViewDelegate <NSObject>

// 发起签约
- (void)signingViewTapEvent;

// 拒绝申请
- (void)refuseButtonClickedEvent;

// 接受申请
- (void)acceptButtonnClickedEvent;

// 确认
- (void)againButtonClickedEventWithIndex:(NSInteger)index;

@end

@interface ZYSigningDetailBottomView : UIView

@property (nonatomic, strong) ZYSigningDetailDataModel *model;

@property (nonatomic, weak) id<ZYSigningDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
