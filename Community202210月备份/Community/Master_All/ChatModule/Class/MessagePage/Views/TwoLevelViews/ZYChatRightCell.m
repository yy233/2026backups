//
//  ZYChatRightCell.m
//  Community
//
//  Created by ZY on 2021/4/22.
//

#import "ZYChatRightCell.h"
//
#import "ChatManagerData.h"
//202206中旬表情
#import "ChatViewEmojiTool.h"

@interface ZYChatRightCell ()

@property (nonatomic,assign) ChatVc_Seesion_type thisChatVC_Seesion_type;
@property (nonatomic,strong) ChatFriendMessageModel *fmodel;
@property (nonatomic,strong) ChatGroupMessageModel *gmodel;
@end


@implementation ZYChatRightCell


//删除撤销
- (void)showOrHiddenCellDeletAndUndoBtnWithNilNumIsHidden:(BOOL)numBool{
    if (numBool) {//1 show
        self.deletThisMsgBtn.hidden = NO;
        self.undoThisMsgBtn.hidden = NO;
    }else{//0hidden
        self.deletThisMsgBtn.hidden = YES;
        self.undoThisMsgBtn.hidden = YES;
    }
}
- (void)setOwnDeletAndUndoUI{
    [_deletThisMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bubbleImageView.mas_left).offset(-5);
        make.width.offset(40);
        make.bottom.equalTo(_bubbleImageView.mas_centerY).offset(-1);
        make.top.lessThanOrEqualTo(_bubbleImageView.mas_centerY).offset(-20);
    }];
    [_undoThisMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.equalTo(_deletThisMsgBtn);
        make.top.equalTo(_deletThisMsgBtn.mas_bottom);
        make.bottom.lessThanOrEqualTo(_bubbleImageView.mas_centerY).offset(20);
    }];
}

/**
 //删除
 - (void)deletThisMsgBtnAction{
     if (_delegate && [_delegate respondsToSelector:@selector(cellDelegateWithTouchDeletFriendMsgWithMsgData:orGroupModel:)]) {
         if (self.chatVcType == ChatVC_GroupChat) {
             [_delegate cellDelegateWithTouchDeletFriendMsgWithMsgData:nil orGroupModel:self.gmodel];
         }else{
             [_delegate cellDelegateWithTouchDeletFriendMsgWithMsgData:self.fmodel orGroupModel:nil];
         }
     }
 }
 //撤回
 - (void)undoThisMsgBtnAction{
     if (_delegate && [_delegate respondsToSelector:@selector(cellDelegateWithTouchUndoFriendMsgWithMsgData:orGroupModel:)]) {
         if (self.chatVcType == ChatVC_GroupChat) {
             [_delegate cellDelegateWithTouchUndoFriendMsgWithMsgData:nil orGroupModel:self.gmodel];
         }else{
             [_delegate cellDelegateWithTouchUndoFriendMsgWithMsgData:self.fmodel orGroupModel:nil];
         }
     }
 }

 */

#pragma mark ==

- (void)fillMsgCellWithFriendMsgData:(ChatFriendMessageModel *)fmodel orGroupModel:(ChatGroupMessageModel *)gmodel{
    self.gmodel  = gmodel;
    self.fmodel = fmodel;
    if (isNotNil(gmodel)) {//群会话数据
        [self fillGroupMsgCellWithMsgData:gmodel];
        self.thisChatVC_Seesion_type = ChatVc_Seesion_type_Group;

        //已读未读
        self.readStateBtn.selected =  (gmodel.read_count <= 0 ? YES : NO);
    }
    if (isNotNil(fmodel)) {
        //好友会话数据
        [self fillFriendMsgCellWithMsgData:fmodel];
        self.thisChatVC_Seesion_type = ChatVc_Seesion_type_Friend;//非群
        //已读未读
        self.readStateBtn.selected =  (fmodel.read_count <= 0 ? YES : NO);
    }
}
- (void)fillGroupMsgCellWithMsgData:(ChatGroupMessageModel *)model{
    //时间
    NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    self.dateLabel.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    //内容——文本
    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
//        NSDictionary *con = [NSDictionary dictionaryWithDictionary:model.text];
        NSDictionary*con = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];
        NSString *textStr = [[con allKeys]containsObject:kWebSocketMsgTypeObj_Content] ? [con objectForKey:kWebSocketMsgTypeObj_Content] :@"";
        self.chatLabel.text = textStr;
    }
    [self resetLabelUI];
}

//文本消息数据

- (void)fillFriendMsgCellWithMsgData:(ChatFriendMessageModel *)model{
    //时间
    NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    self.dateLabel.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    //内容——文本
    if ([model.msg_type isEqualToString:kWebSocketMsgTypeObj_Text]) {
//        NSDictionary *con = [NSDictionary dictionaryWithDictionary:model.text];//旧版
        NSDictionary*con = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];
        NSString *textStr = [[con allKeys]containsObject:kWebSocketMsgTypeObj_Content] ? [con objectForKey:kWebSocketMsgTypeObj_Content] :@"";
//        self.chatLabel.text = textStr;
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
//    [self resetLabelUI];
    [self.iconImageView sd_setImageWithURL:[UrlWithString getURLWithStr:model.from_acc_headImg] placeholderImage:Main_OwnImg];

}
- (void)resetLabelUI{
    // 设置文字大小
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
    UIImage *backImage = [UIImage imageNamed:@"bubble_right"];
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
    UIImage *backImage = [UIImage imageNamed:@"bubble_right"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.image = backImage;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.readStateBtn newAnBtnWithTextStrNomal:@"已读" withTextStrSelected:@"未读"];
    [self.readStateBtn  newAnBtnWithTextColorNomal:Y_ColorWith16FromRGB(0xAAAEB9)  withTextColorSelected:Y_ColorWith16FromRGB(0x418CFB)];
    [self.readStateBtn newAnBtnWithFont: [UIFont systemFontOfSize:12.5] ];
    self.readStateBtn.userInteractionEnabled = NO;
    self.readStateBtn.selected = YES;//初始为未读状态
    
    
    //删除撤回 UI
    [self.chatView.superview addSubview:self.deletThisMsgBtn];
    [self.chatView.superview addSubview:self.undoThisMsgBtn];
    [self setOwnDeletAndUndoUI];
//    [self showOrHiddenCellDeletAndUndoBtnWithNilNumIsHidden:0];//初始不展示撤销删除
    //
    
    // 设置文字大小
    //self.chatLabel.text = @"强哥，那我就不可客气了！强哥够义气，今晚聚一聚！";
    self.chatLabel.text  = @"";
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
    UIImage *backImage = [UIImage imageNamed:@"bubble_right"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView.image = backImage;
    
    // 图片切圆角
    [self.iconImageView zy_cornerRadiusAdvance:self.iconImageView.bounds.size.width / 2 rectCornerType:UIRectCornerAllCorners];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    //

}

- (UILabel *)chatLabel {
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.font = [UIFont systemFontOfSize:15];
        _chatLabel.textColor = [UIColor whiteColor];
        _chatLabel.numberOfLines = 0;
    }
    
    return _chatLabel;
}
//删除撤销键
- (UIButton *)deletThisMsgBtn{
    if (!_deletThisMsgBtn) {
        _deletThisMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletThisMsgBtn newAnBtnWithTextStr:@"删除"];
        [_deletThisMsgBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_deletThisMsgBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_deletThisMsgBtn newAnBtnWithBackColor:Color_138GrayColor];
        [_deletThisMsgBtn addTarget:self action:@selector(deletThisMsgBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletThisMsgBtn;
}
- (UIButton *)undoThisMsgBtn{
    if (!_undoThisMsgBtn) {
        _undoThisMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_undoThisMsgBtn newAnBtnWithTextStr:@"撤回"];
        [_undoThisMsgBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_undoThisMsgBtn newAnBtnWithFont:[UIFont systemFontOfSize:12]];
        [_undoThisMsgBtn newAnBtnWithBackColor:Color_138GrayColor];
        [_undoThisMsgBtn addTarget:self action:@selector(undoThisMsgBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoThisMsgBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
