//
//  ChatPopView.h
//  TUIVoiceRoom
//
//  Created by 余莹 on 2023/6/14.
//

#import <UIKit/UIKit.h>
#import "VoiceOcFileUse_Header.h"
#import "VoiceOcTool.h"
#import "VoiceBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ChatPopViewDelegate <NSObject>

- (void)touchChatPopSubBiaoQingBtn:(NSString *)sendText;

@end


@interface ChatPopViewSubBottomView : UIView
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIView *inputBkView;
@property (nonatomic,strong) UITextView *inputTextView;
@end


@interface ChatPopView : VoiceBasePopView
@property (nonatomic,strong) UILabel *titL;
@property (nonatomic,strong) ChatPopViewSubBottomView *bottomView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) id <ChatPopViewDelegate> chatDelegate;
@end



NS_ASSUME_NONNULL_END
