//
//  ZYChatLeftCell.m
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import "ZYChatLeftCell.h"
//
#import "ChatManagerData.h"
//202206中旬表情
#import "ChatViewEmojiTool.h"

@implementation ZYChatLeftCell

- (void)fillFriendMsgCellWithMsgData:(ChatFriendMessageModel *)model{
    //时间
    NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    self.dateLabel.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    self.nickLabel.text = [TextShowWithModelStr textShowWithModelStr:model.from_acc_name];
    //内容——文本
    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
//        NSDictionary *con = [NSDictionary dictionaryWithDictionary:model.text];
        NSDictionary*con = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];
        NSString *textStr = [[con allKeys]containsObject:kWebSocketMsgTypeObj_Content] ? [con objectForKey:kWebSocketMsgTypeObj_Content] :@"";
        
        if (!([textStr containsString:k_emj_tip_start] && [textStr containsString:k_emj_tip_end])) {
            self.chatLabel.text = textStr;
            [self resetLabelUI];
        }else{
            WEAKSELF
            [ChatViewEmojiTool getEmjIndexArrWithStr:textStr withBlock:^(NSMutableAttributedString * _Nonnull okAttributedString) {
                weakSelf.chatLabel.attributedText = okAttributedString;
                [self resetLabelUIWithAttributedText];
            }];
        }
        
    }
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.from_acc_headImg] placeholderImage:Main_OwnImg];
    
    
}
- (void)resetLabelUI{
    CGSize labelSize = [self.chatLabel.text boundingRectWithSize: CGSizeMake(kScreenW - 152 - 10, MAXFLOAT)
                                                    options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                 attributes: @{NSFontAttributeName:self.chatLabel.font}
                                                    context: nil].size;
    self.chatLabel.frame = CGRectMake(12, 10, labelSize.width, labelSize.height);
    [_chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_chatLabel.superview).insets(UIEdgeInsetsMake(10, 12, 10, 12));
    }];
    self.chatViewLeftConstraint.constant = kScreenW - labelSize.width - 68 - 24 - 10;
    // 拉伸气泡
    UIImage *backImage = [UIImage imageNamed:@"bubble_left"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.image = backImage;
}
- (void)resetLabelUIWithAttributedText{
//    CGSize labelSize = [self.chatLabel.attributedText boundingRectWithSize: CGSizeMake(kScreenW - 152 - 10, MAXFLOAT)
//                                                    options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
//                                                 attributes: @{NSFontAttributeName:self.chatLabel.font}
//                                                    context: nil].size;
    CGSize labelSize = [self.chatLabel.attributedText boundingRectWithSize: CGSizeMake(kScreenW - 152 - 10, MAXFLOAT)
                                                    options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                    context: nil].size;
    
    
    self.chatLabel.frame = CGRectMake(12, 10, labelSize.width, labelSize.height);
    [_chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_chatLabel.superview).insets(UIEdgeInsetsMake(10, 12, 10, 12));
    }];
    self.chatViewLeftConstraint.constant = kScreenW - labelSize.width - 68 - 24 - 10;
    // 拉伸气泡
    UIImage *backImage = [UIImage imageNamed:@"bubble_left"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.image = backImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 设置文字大小
    self.chatLabel.text = @"当然了，所有东西随便你挑选了，不用担心钱的问题，你高兴就好，到时候直接清空购物车。";
    CGSize labelSize = [self.chatLabel.text boundingRectWithSize: CGSizeMake(kScreenW - 152 - 10, MAXFLOAT)
                                                    options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                 attributes: @{NSFontAttributeName:self.chatLabel.font}
                                                    context: nil].size;
    self.chatLabel.frame = CGRectMake(12, 10, labelSize.width, labelSize.height);
    [self.chatView addSubview:self.chatLabel];
    [_chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_chatLabel.superview).insets(UIEdgeInsetsMake(10, 12, 10, 12));
    }];
    self.chatViewLeftConstraint.constant = kScreenW - labelSize.width - 68 - 24 - 10;
    
    // 拉伸气泡
    UIImage *backImage = [UIImage imageNamed:@"bubble_left"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.image = backImage;
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (UILabel *)chatLabel {
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.font = [UIFont systemFontOfSize:15];
        _chatLabel.textColor = Y_RGBA(51, 51, 51, 1);
        _chatLabel.numberOfLines = 0;
    }
    
    return _chatLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
