//
//  ZYCommunityFairSearchRecordsTopView.h
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairSearchRecordsTopViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)searchButtonEvent;

@end

@interface ZYCommunityFairSearchRecordsTopView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYCommunityFairSearchRecordsTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
