//
//  ZYIntelligentInquirySearchBottomView.h
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIntelligentInquirySearchBottomViewDelegate <NSObject>

- (void)bottomViewEvent;

@end

@interface ZYIntelligentInquirySearchBottomView : UIView

@property (nonatomic, weak) id<ZYIntelligentInquirySearchBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
