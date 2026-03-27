//
//  LifeCostPaymentListVcHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LifeCostPaymentListVcHeaderViewDelegate <NSObject>
- (void)touchOneChoosePayTypeBtn;
- (void)touchOneChooseTimeBtn;
@end

@interface LifeCostPaymentListVcHeaderView : UIView

@property (nonatomic,weak) id <LifeCostPaymentListVcHeaderViewDelegate>  delegate;
- (void)fillNewShowChoosePayTypeStr:(NSString *)payTypeStr;
- (void)fillNewShowChooseTimeStr:(NSString *)timeStr;
 
@end

NS_ASSUME_NONNULL_END
