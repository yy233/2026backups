//
//  ChatBottomViewSubVoicePopView.h
//  Community
//
//  Created by 余莹 on 2021/5/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    LongPressActionType_Begin,
    LongPressActionType_End,
    LongPressActionType_Cancel,
    LongPressActionType_Other
} LongPressActionType;

@protocol ChatBottomViewSubVoicePopViewDelegate <NSObject>

- (void)subPopViewVoiceBtnLongPressActionType:(LongPressActionType)longPressActionType;

@end


@interface ChatBottomViewSubVoicePopView : BasePopView

@property (nonatomic,weak) id <ChatBottomViewSubVoicePopViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
