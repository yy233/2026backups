//
//  LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailWithHistoryPayCompleteInfoTopView : UIView
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UIView *shadowView;
@property (nonatomic,strong) UILabel *moneySignL;
@property (nonatomic,strong) UILabel *moneyNumL;
- (void)fillTopViewDataWithImgUrlStr:(NSString *)imgUrlStr withMoneyNumStr:(NSString *)moneyNumStr;
@end

NS_ASSUME_NONNULL_END
