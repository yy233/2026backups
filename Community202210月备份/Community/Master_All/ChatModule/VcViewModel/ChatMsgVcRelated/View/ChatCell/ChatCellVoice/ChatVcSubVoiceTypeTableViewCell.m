//
//  ChatVcSubVoiceTypeTableViewCell.m
//  Community
//
//  Created by 余莹 on 2022/3/24.
//

#import "ChatVcSubVoiceTypeTableViewCell.h"

@interface ChatVcSubVoiceTypeTableViewCell ()
@property (nonatomic,assign) ChatVcSessionType_FriendGroupSystemOtehr chatVcType;
@property (nonatomic,assign) ChatThisCellShowLeftRightSystemOtherType showRightLeftType;
@property (nonatomic,strong) id saveThisMsgModel;

@property (nonatomic,strong) NSString *saveVoiceUrlStr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger timerNum;
@end

@implementation ChatVcSubVoiceTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)leftOtherUI{
    WEAKSELF
    [self.backView addSubview:self.voiceImgV];
    [self.backView addSubview:self.voicePlayBtn];
    _voiceImgV.tag =  ChatThisCellShowLeftRightSystemOtherType_Left + 900;
    _voiceImgV.image = [UIImage imageNamed:@"voice_Left_3"];
    
    [_voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bubbleImageView_New).offset(10);
        make.left.equalTo(weakSelf.bubbleImageView_New).offset(5);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-10);
        make.bottom.equalTo(weakSelf.bubbleImageView_New).offset(-5);
        make.height.equalTo(weakSelf.bubbleImageView_New).offset(-20);
    }];
    [_voicePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_voiceImgV);
    }];
}
- (void)rightOtherUI{
    WEAKSELF
    [self.backView addSubview:self.voiceImgV];
    [self.backView addSubview:self.voicePlayBtn];
    _voiceImgV.tag =  ChatThisCellShowLeftRightSystemOtherType_Right + 900;
    _voiceImgV.image = [UIImage imageNamed:@"voice_Right_3"];
    //
    [_voiceImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bubbleImageView_New).offset(10);
        make.right.equalTo(weakSelf.bubbleImageView_New).offset(-5);
        make.width.equalTo(weakSelf.bubbleImageView_New).offset(-10);
        make.bottom.equalTo(weakSelf.bubbleImageView_New).offset(-5);
        make.height.equalTo(weakSelf.bubbleImageView_New).offset(-20);
    }];
    [_voicePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_voiceImgV);
    }];
}

- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel withRightOrLeft:(ChatThisCellShowLeftRightSystemOtherType)showType{
    
    self.chatVcType = friendGroupSystemType;
    self.saveThisMsgModel = msgModel;
    self.showRightLeftType = showType;
    /**
     if (friendGroupSystemType == ChatVcSessionType_FriendGroupSystemOtehr_Friend || friendGroupSystemType ==ChatVcSessionType_FriendGroupSystemOtehr_Group) {
         ChatFriendMessageModel *model = ( ChatFriendMessageModel *)msgModel;
         //1025新版数据
         NSDictionary *dataDic = [Tool dictionaryWithJsonString:[TextShowWithModelStr textShowWithModelStr:model.data]];//新版
     }
     */
 
}


//播放语音
- (void)voicePlayBtnAction{
    if (isNil(self.chatVcSubCellsDeletage)) {
        return;
    }
    if ( [self.chatVcSubCellsDeletage   respondsToSelector:@selector(cellDelegateWithTouchVoicePlayActionFriendMsgWithMsgData:orGroupModel:)]) {
        
        //
        if (self.chatVcType  == ChatVcSessionType_FriendGroupSystemOtehr_Friend ) {
            ChatFriendMessageModel *model = ( ChatFriendMessageModel *)self.saveThisMsgModel;
            [self.chatVcSubCellsDeletage  cellDelegateWithTouchVoicePlayActionFriendMsgWithMsgData:model orGroupModel:nil];

        }else if (self.chatVcType == ChatVcSessionType_FriendGroupSystemOtehr_Group) {
            ChatGroupMessageModel *model = ( ChatGroupMessageModel *)self.saveThisMsgModel;
            [self.chatVcSubCellsDeletage  cellDelegateWithTouchVoicePlayActionFriendMsgWithMsgData:nil orGroupModel:model];
        }else{
            
        }
        //
        [self cellSubImgWithVoiceIsPlay:YES];//img动画
    }
   
}
#pragma mark == 播放时img处理
//播放时img处理
- (void)cellSubImgWithVoiceIsPlay:(BOOL)isBeginPlay{
   if (isBeginPlay) {
       //下载播放
       [[NSRunLoop mainRunLoop] addTimer:self.timer  forMode:NSRunLoopCommonModes];
       [self.timer  fire];
   }else{
       //结束播放的UI动态
       //
       [self.timer invalidate];
       self.timer = nil;
       //UI
       
       NSString *rightOrLeftName = @"";
       if (self.showRightLeftType == ChatThisCellShowLeftRightSystemOtherType_Right) {
           rightOrLeftName = @"voice_Right_3";
       }else{
           rightOrLeftName = @"voice_Left_3";
       }
       dispatch_async(dispatch_get_main_queue(), ^{
           self.voiceImgV.image = [UIImage imageNamed:rightOrLeftName];
       });
   }

}
- (void)updateImage {
//0.5s的图片切换
   int no = 0;
   if (self.timerNum>=3) {
       self.timerNum = 0;
   }else if(self.timerNum>=2 && self.timerNum<3){
       self.timerNum += 1;
       no = 3;
   }else if(self.timerNum>=1 && self.timerNum<2){
       self.timerNum +=1;
       no = 2;
   }else if(self.timerNum<=1){
       self.timerNum +=1;
       no = 1;
   }
    NSString *rightOrLeftName = @"";
    
    //if (self.showRightLeftType == ChatThisCellShowLeftRightSystemOtherType_Right) {//图片会获取错 
    if (  _voiceImgV.tag - 900 == ChatThisCellShowLeftRightSystemOtherType_Right) {//可用
    
        rightOrLeftName = @"voice_Right_";
    }else{
        rightOrLeftName = @"voice_Left_";
    }
   self.voiceImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%d",rightOrLeftName,no]];
}

#pragma mark ==
- (UIButton *)voicePlayBtn{
   if (!_voicePlayBtn) {
       _voicePlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       [_voicePlayBtn addTarget:self action:@selector(voicePlayBtnAction) forControlEvents:UIControlEventTouchUpInside];
   }
   return _voicePlayBtn;
}
- (UIImageView *)voiceImgV{
   if (!_voiceImgV) {
       _voiceImgV = [[UIImageView alloc]init];
       _voiceImgV.contentMode = UIViewContentModeScaleAspectFit;// UIViewContentModeRight UIViewContentModeLeft
       _voiceImgV.layer.masksToBounds = YES;
   }
   return _voiceImgV;
}
- (NSTimer *)timer{
   if (!_timer) {
       _timer  = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
   }
   return _timer;
}
@end
