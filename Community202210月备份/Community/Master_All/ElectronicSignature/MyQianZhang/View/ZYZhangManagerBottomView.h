//
//  ZYZhangManagerBottomView.h
//  Community
//
//  Created by ZY on 2021/10/28.
//

#import <UIKit/UIKit.h>

@protocol ZYZhangManagerBottomViewDelegate <NSObject>

- (void)uploadButtonEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYZhangManagerBottomView : UIView

@property (nonatomic, weak) id<ZYZhangManagerBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
