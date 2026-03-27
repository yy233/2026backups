//
//  ZYOtherIssueActivityTopView.h
//  Community
//
//  Created by ZY on 2021/11/16.
//

#import <UIKit/UIKit.h>
#import "ZYPensionMainActivityModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYOtherIssueActivityTopViewDelegate <NSObject>

- (void)addFriendButtonEvent;

- (void)exchangeButtonEvent;

@end

@interface ZYOtherIssueActivityTopView : UIView

@property (nonatomic, strong) ZYPensionMainActivityDataModel *model;

@property (nonatomic, weak) id<ZYOtherIssueActivityTopViewDelegate> delegate;

@property (nonatomic, assign) BOOL isFriendBool;

@end

NS_ASSUME_NONNULL_END
