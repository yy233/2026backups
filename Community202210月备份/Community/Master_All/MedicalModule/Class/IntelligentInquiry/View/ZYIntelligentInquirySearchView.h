//
//  ZYIntelligentInquirySearchView.h
//  Community
//
//  Created by ZY on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYIntelligentInquirySearchViewDelegate <NSObject>

- (void)backButtonEvent;

- (void)searchButtonEvent;

//用按住状态 处理这段时期的 语音实时转换成文字
- (void)voiceButtonEventBegin;
- (void)voiceButtonEventEnd;

@end

@interface ZYIntelligentInquirySearchView : UIView

@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (nonatomic, weak) id<ZYIntelligentInquirySearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
