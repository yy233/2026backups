//
//  ZYIssueActivityLocationHeaderView.h
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import <UIKit/UIKit.h>
#import "ZYPensionMainActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIssueActivityLocationHeaderViewDelegate <NSObject>

- (void)addFriendButtonEvent;

- (void)exchangeButtonEvent;

- (void)iconImageViewEvent;

@end

@interface ZYIssueActivityLocationHeaderView : UIView

@property (nonatomic, strong) ZYPensionMainActivityDataModel *model;
@property (nonatomic, assign) BOOL isFriendBool;

@property (nonatomic, strong) NSArray *activityArray;

@property (nonatomic, weak) id<ZYIssueActivityLocationHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
