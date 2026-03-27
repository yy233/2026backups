//
//  ChatVcSubVoiceTypeTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import "ChatVcSubBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *ChatVcSubVoiceTypeTableViewCell_I   = @"ChatVcSubVoiceTypeTableViewCell";
static NSString *ChatVcSubVoiceTypeTableViewCell_Left_I   = @"ChatVcSubVoiceTypeTableViewCell_left";
static NSString *ChatVcSubVoiceTypeTableViewCell_Right_I   = @"ChatVcSubVoiceTypeTableViewCell_right";

@interface ChatVcSubVoiceTypeTableViewCell : ChatVcSubBaseTableViewCell

@property (nonatomic,strong) UIImageView *voiceImgV;//喇叭img
@property (nonatomic,strong) UIButton *voicePlayBtn;//播放

- (void)cellSubImgWithVoiceIsPlay:(BOOL)isBeginPlay;//停止播放用的 给外部调
@end

NS_ASSUME_NONNULL_END
