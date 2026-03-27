//
//  MyOrderListVcHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderListVcHeaderViewDelegate <NSObject>
- (void)orderHeaderViewTouchUPWithListType:(MyOrderListCell_Type)type;
@end

@interface MyOrderListVcHeaderView : UIView
@property (nonatomic,weak) id <MyOrderListVcHeaderViewDelegate> delegate;
- (void)showListWithType:(MyOrderListCell_Type)showType;
@end

NS_ASSUME_NONNULL_END
