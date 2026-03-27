//
//  ChatVcSubBaseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/10.
//

#import "ChatVcSubBaseTableViewCell.h"

@implementation ChatVcSubBaseTableViewCell
//220324 给子类赋内容值时 重用
- (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel{
    NSLog(@"ChatVcSubBaseTableViewCell 内容填充ing");

    
 
}
//voice 分左右 (音频动态下的图片不一样)
 - (void)fillMsgCellContentInfoWithFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType withMsgModel:(id)msgModel withRightOrLeft:(ChatThisCellShowLeftRightSystemOtherType)showType{
     NSLog(@"ChatVcSubBaseTableViewCell 内容填充ing");
}

//220324 方向UI约束
- (void)fillBeginWithUILeftOrRightOrCenter:(ChatThisCellShowLeftRightSystemOtherType)showType{
    //显隐+UISet
    [self setBaseCellTypeLeftOrRightOrCenter:showType];
    switch (showType) {
        case ChatThisCellShowLeftRightSystemOtherType_Right:
            self.nickL.hidden = YES;
            self.readStateBtn.hidden = NO;
            break;
        case ChatThisCellShowLeftRightSystemOtherType_Left:
            self.nickL.hidden = NO;
            self.readStateBtn.hidden = YES;
            break;
        default:
            self.nickL.hidden = YES;
            self.readStateBtn.hidden = YES;
            break;
    }
 }
//全类型cell的基础公共数据fill
//220324
- (void)fillMsgCellBasePublicInfoWithThisMsgCellShowLeftRightSystemType:(ChatThisCellShowLeftRightSystemOtherType)showType
                                                    withThisMsgInfoType:(NSString *)msgInfoTypeStr
                                               withFriendGroupOtherType:(ChatVcSessionType_FriendGroupSystemOtehr)friendGroupSystemType
                                                           withMsgModel:(id)msgModel{
    
   
    //基础数据
    if (friendGroupSystemType == ChatVcSessionType_FriendGroupSystemOtehr_Friend || friendGroupSystemType ==ChatVcSessionType_FriendGroupSystemOtehr_Group) {

        ChatFriendMessageModel *model = ( ChatFriendMessageModel *)msgModel;
        //时间日期
        NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
        NSString *timeOkStr = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
        //已读未读
        BOOL readCountBtnSelectedBol =  (model.read_count <= 0 ? YES : NO);
         //昵称
        NSString *nickStr = [TextShowWithModelStr textShowWithModelStr:model.from_acc_name];
        //头像
        NSString *iconImgStr = [TextShowWithModelStr textShowWithModelStr:model.from_acc_headImg];
        //赋值
        [self fillMsgCellBaseInfoWithDateStr:timeOkStr withReadCountBtnSelected:readCountBtnSelectedBol withNickStr:nickStr withImgStr:iconImgStr];
    }
    WEAKSELF
    //voice类型 泡泡高度更改
    if ([ msgInfoTypeStr  isEqualToString:kWebSocketMsgTypeObj_Voice]) {
        [self.bubbleImageView_New mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.backView).multipliedBy(0.2);//是否更新宽度（img/location 0.5 voice 0.2）
            make.height.offset(50);//是否更新高度（img /location 100 : voice 50）
        }];
    }else{
        [self.bubbleImageView_New mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.backView).multipliedBy(0.5);//是否更新宽度（img/location 0.5 voice 0.2）
            make.height.offset(100);//是否更新高度（img /location 100 : voice 50）
        }];
    }
 
}
#pragma mark === msgBase
- (void)fillMsgCellBaseInfoWithDateStr:(NSString *)dataStr
          withReadCountBtnSelected:(BOOL)isSelected
                       withNickStr:(NSString *)nickStr
                        withImgStr:(NSString *)imgStr{
    //时间日期
    self.dateL.text = dataStr;
    //已读未读
    self.readStateBtn.selected = isSelected;
    //头像
    [self.iconImgV sd_setImageWithURL: [UrlWithString getURLWithStr: imgStr ] placeholderImage: Main_OwnImg];
    //昵称
    self.nickL.text = nickStr;
    
}
#pragma mark === msgBase _end

#pragma mark === msg
- (void)fillMsgCellWithFriendMsgData:(nullable ChatFriendMessageModel *)fmodel orGroupModel:(nullable ChatGroupMessageModel *)gmodel{
    self.gmodel  = gmodel;
    self.fmodel = fmodel;
    if (isNotNil(gmodel)) {//群会话数据
        [self fillGroupMsgCellWithMsgData:gmodel];
        
    }
    if (isNotNil(fmodel)) {
        //好友会话数据
        [self fillFriendMsgCellWithMsgData:fmodel];
    }
}
- (void)fillFriendMsgCellWithMsgData:(ChatFriendMessageModel *)model{
     //时间
    NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    self.dateL.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    
}
- (void)fillGroupMsgCellWithMsgData:(ChatGroupMessageModel *)model{
     //时间
    NSString *timeS = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    self.dateL.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setBaseCellTypeLeftOrRightOrCenter:(ChatThisCellShowLeftRightSystemOtherType)chatBaseCellType_RightOrLeft{
    if (chatBaseCellType_RightOrLeft == ChatThisCellShowLeftRightSystemOtherType_Right) {
        [self rightUI];
    }
    if (chatBaseCellType_RightOrLeft == ChatThisCellShowLeftRightSystemOtherType_Left) {
        [self leftUI];
    }
    if (chatBaseCellType_RightOrLeft == ChatThisCellShowLeftRightSystemOtherType_SystemCenter) {
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self.gmodel = [[ChatGroupMessageModel alloc]init];
    self.fmodel = [[ChatGroupMessageModel alloc]init];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor clearColor];
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(10, 16, 10, 16));
        }];
        [self.backView addSubview:self.dateL];
        [self.backView addSubview:self.iconImgV];//头像
        [self.backView addSubview:self.nickL];//昵称(left才显示)
        [self.backView addSubview:self.readStateBtn];//220324已读未读（right才显示）
        [self.backView addSubview:self.bubbleImageView_New];
        [self.backView addSubview:self.contentView_New];
        [self setChatBaseCellUI];
    }
    return self;
}
- (void)setChatBaseCellUI{
    [_dateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_dateL.superview);
        make.height.offset(20);
    }];
}

#pragma mark ==  leftUI
- (void)leftUI{
     
    [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateL.mas_bottom);
        make.left.equalTo(_iconImgV.superview);
        make.height.width.offset(42);
    }];

    [self lefNickReadStateOtherBaseUI];
    [self leftbubbleUI];

    [self leftOtherUI];
}
- (void)lefNickReadStateOtherBaseUI{
    //左边昵称 显示
    [_nickL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImgV.mas_top);
        make.width.equalTo(_nickL.superview).offset(-100);//img42 10
        make.left.equalTo(_iconImgV.mas_right).offset(10);
        make.height.offset(20);
     }];
    //已读未读 不显示
    [_readStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0.1);
        make.height.offset(0.1);
        make.right.equalTo(_iconImgV.mas_left).offset(-10);//右头像的left 还要left20;
        make.bottom.equalTo(_readStateBtn.superview).offset(-5);//底部位置
    }];
}
- (void)leftbubbleUI{
    WEAKSELF
    [_bubbleImageView_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nickL.mas_bottom).offset(5);//顶部nickL为top开始
        make.left.equalTo(weakSelf.backView).offset(50);
        make.bottom.equalTo(weakSelf.backView);
        make.width.equalTo(weakSelf.backView).multipliedBy(0.5);//是否更新宽度（img/location 0.5 voice 0.2）
        make.height.offset(100);//是否更新高度（img /location 100 : voice 50）
    }];
    // 拉伸气泡
    UIImage *backImage = [UIImage imageNamed:@"bubble_left"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView_New.image = backImage;
    [_contentView_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bubbleImageView_New).offset(5);
//        make.left.equalTo(_bubbleImageView_New).offset(5);
//        make.width.equalTo(_bubbleImageView_New).offset(-10);
        make.left.equalTo(_bubbleImageView_New).offset(10);//left 尖角留5冗余
        make.width.equalTo(_bubbleImageView_New).offset(-15);
        make.bottom.equalTo(_bubbleImageView_New).offset(-5);
        make.height.equalTo(_bubbleImageView_New).offset(-10);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTap)];
    _contentView_New.userInteractionEnabled = YES;
    [_contentView_New addGestureRecognizer:tap];
}
- (void)leftOtherUI{
    
}
#pragma mark ==  rightUI
- (void)rightUI{

    [_iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateL.mas_bottom);
        make.right.equalTo(_iconImgV.superview);
        make.height.width.offset(40);
    }];
    [self rightNickReadStateOtherBaseUI];
    [self rightBubbleUI];
    [self rightOtherUI];
}
- (void)rightNickReadStateOtherBaseUI{
    //右边昵称 不显示 约束更改
    [_nickL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImgV.mas_top);
        make.width.equalTo(_nickL.superview).offset(-100);//img42 10
        make.left.equalTo(_iconImgV.mas_right).offset(10);
        make.height.offset(0.1);
    }];
    //已读未读
    [_readStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(30);
        make.height.offset(20);
        make.right.equalTo(_iconImgV.mas_left).offset(-10);//右头像的left 还要left20;
        make.bottom.equalTo(_readStateBtn.superview).offset(-5);//底部位置
    }];
}
- (void)rightBubbleUI{
    WEAKSELF
    //内容部分
    [_bubbleImageView_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.backView).offset(30);
        make.right.equalTo(weakSelf.backView).offset(-50);
        make.bottom.equalTo(weakSelf.readStateBtn.mas_top).offset(-5);//底部位置在已读未读状态的上边
        make.width.equalTo(weakSelf.backView).multipliedBy(0.5);//是否更新宽度（img/location 0.5 voice 0.2）
        make.height.offset(100);//是否更新高度（img /location 100 : voice 50）
        
    }];
    UIImage *backImage = [UIImage imageNamed:@"bubble_right"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.bubbleImageView_New.image = backImage;

    [_contentView_New mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bubbleImageView_New).offset(5);
//        make.right.equalTo(_bubbleImageView_New).offset(-5);
//        make.width.equalTo(_bubbleImageView_New).offset(-10);
        make.right.equalTo(_bubbleImageView_New).offset(-10);//right 尖角留5冗余
        make.width.equalTo(_bubbleImageView_New).offset(-15);
        make.bottom.equalTo(_bubbleImageView_New).offset(-5);
        make.height.equalTo(_bubbleImageView_New).offset(-10);
    }];
    //图片放大手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgViewTap)];
    _contentView_New.userInteractionEnabled = YES;
    [_contentView_New addGestureRecognizer:tap];
}
- (void)rightOtherUI{
    
}
- (void)imgViewTap{
//img类型作大图显示的重用
}

#pragma mark ==
- (UILabel *)dateL{
    if (!_dateL) {
        _dateL = [[UILabel alloc]init];
        _dateL.textAlignment = NSTextAlignmentCenter;
        _dateL.textColor = Y_ColorWith16FromRGB(0xAAAEB9);
        _dateL.font = [UIFont systemFontOfSize:12.5];
    }
    return _dateL;
}
- (UIImageView *)iconImgV{
    if (!_iconImgV) {
        _iconImgV = [[UIImageView alloc]init];
        _iconImgV.contentMode = UIViewContentModeScaleAspectFill;
//        _iconImgV.layer.cornerRadius = 21;
//        _iconImgV.layer.masksToBounds = YES;
        [_iconImgV zy_cornerRadiusAdvance:21 rectCornerType:UIRectCornerAllCorners];
        
    }
    return _iconImgV;
}
- (UILabel *)nickL{
    if (!_nickL) {
        _nickL = [[UILabel alloc]init];
        _nickL.font = [UIFont systemFontOfSize:13];
        _nickL.textColor = Y_ColorWith16FromRGB(0xAAAEB9);
    }
    return _nickL;
}
- (UIButton *)readStateBtn{
    if (!_readStateBtn) {
        _readStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readStateBtn newAnBtnWithTextStrNomal:@"已读" withTextStrSelected:@"未读"];
        [_readStateBtn newAnBtnWithTextColorNomal:Y_ColorWith16FromRGB(0xAAAEB9)  withTextColorSelected:Y_ColorWith16FromRGB(0x418CFB)];
        [_readStateBtn newAnBtnWithFont: [UIFont systemFontOfSize:13] ];
        _readStateBtn.userInteractionEnabled = NO;
        _readStateBtn.selected = YES;//初始为未读状态
    }
    return _readStateBtn;
}

- (UIImageView *)contentView_New{//内容位置
    if (!_contentView_New) {
        _contentView_New = [[UIImageView alloc]init];
        _contentView_New.contentMode = UIViewContentModeScaleAspectFit;// UIViewContentModeRight UIViewContentModeLeft
        _contentView_New.layer.masksToBounds = YES;
    }
    return _contentView_New;
}
- (UIImageView *)bubbleImageView_New{//内容背景拉伸气泡
    if (!_bubbleImageView_New) {
        _bubbleImageView_New = [[UIImageView alloc]init];
    }
    return _bubbleImageView_New;
}
@end
