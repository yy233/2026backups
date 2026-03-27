//
//  ZYAccessRecordTopHeaderView.h
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import <UIKit/UIKit.h>
#import "ZYAccessRecordVisitPermitModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYAccessRecordTopHeaderViewDelegate <NSObject>

- (void)switchButtonEvent;

@end

@interface ZYAccessRecordTopHeaderView : UIView

@property (nonatomic, strong) ZYAccessRecordVisitPermitModel *model;

@property (nonatomic, weak) id<ZYAccessRecordTopHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
