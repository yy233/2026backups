//
//  ZYIntelligentInquiryTopView.h
//  Community
//
//  Created by ZY on 2021/12/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIntelligentInquiryTopViewDelegate <NSObject>

- (void)backButtonEvent;

@end

@interface ZYIntelligentInquiryTopView : UIView

@property (nonatomic, weak) id<ZYIntelligentInquiryTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
