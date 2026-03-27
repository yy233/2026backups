//
//  ZYCommunityFairComprehensiveSearchView.h
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCommunityFairComprehensiveSearchViewDelegate <NSObject>

- (void)compositeButtonEvent;

- (void)regionButtonEvent;

- (void)filtrateButtonEvent;

@end

@interface ZYCommunityFairComprehensiveSearchView : UIView

@property (weak, nonatomic) IBOutlet UIButton *compositeButton;

@property (weak, nonatomic) IBOutlet UIButton *regionButton;

@property (weak, nonatomic) IBOutlet UIButton *filtrateButton;

@property (nonatomic, weak) id<ZYCommunityFairComprehensiveSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
