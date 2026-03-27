//
//  ZYPensionMainTopSearchView.h
//  Community
//
//  Created by ZY on 2021/11/4.
//

#import <UIKit/UIKit.h>

@protocol ZYPensionMainTopSearchViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)searchViewEvent;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYPensionMainTopSearchView : UIView

@property (nonatomic, weak) id<ZYPensionMainTopSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
