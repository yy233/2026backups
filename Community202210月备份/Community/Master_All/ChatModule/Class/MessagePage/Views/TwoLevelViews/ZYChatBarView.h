//
//  ZYChatBarView.h
//  Community
//
//  Created by ZY on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYChatBarView : UIView

// 录音
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

// 添加
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//背景色view
@property (weak, nonatomic) IBOutlet UIView *grayBackView;

// 表情
@property (weak, nonatomic) IBOutlet UIButton *funButton;

// 输入框
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

NS_ASSUME_NONNULL_END
