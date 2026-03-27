//
//  MainAllTypeInformationSubListVcTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/8/31.
//

#import "MainAllTypeInformationSubListVcTableViewCell.h"

@implementation MainAllTypeInformationSubListVcTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillDataWithModel:(MainImInfoSubMsgModel *)model{
    NSString *timeIntervalStr = [TextShowWithModelStr textShowWithModelStr:model.create_time];
    BOOL isThisDay = [ToolOfTimeChangeFormat checkIsThisDayWithTheDateStr:timeIntervalStr];
    self.timeL.text = ( isThisDay ? [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"HH:mm"] : [ToolOfTimeChangeFormat dateToString:timeIntervalStr Format:@"YYYY/MM/dd"]);
    //公众号类型 + 好友类型的文本数据
    NSString *messagelistWillShowDetailText = @"";
    if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg] || [model.msg_type  isEqualToString: kWebSocketMsgTypeObj_Text])  {
        NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
        messagelistWillShowDetailText = [[dic allKeys]containsObject: kWebSocketMsgTypeObj_Content] ? [dic objectForKey:kWebSocketMsgTypeObj_Content] : [dic objectForKey:@"desc"];
    }
    self.contentL.text = messagelistWillShowDetailText;
    
}
//init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        self.contentView.backgroundColor  = [UIColor clearColor];
        WEAKSELF
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
        [self.backView addSubview:self.timeL];
        [self.backView addSubview:self.contentL];
        [self setUI];
        self.backView.layer.cornerRadius = 10;
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }
    return self;
}
- (void)setUI{
    [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeL.superview).offset(10);
        make.left.equalTo(_timeL.superview).offset(10);
        make.right.equalTo(_timeL.superview).offset(-10);
        make.height.offset(20);
    }];
    [_contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeL.mas_bottom).offset(10);
        make.left.right.equalTo(_timeL);
        make.bottom.equalTo(_contentL.superview.mas_bottom).offset(-10);
    }];
}

- (UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.font = [UIFont systemFontOfSize:14.0];
        _timeL.textColor = [ThemeManager shareManager].mainTextColor;
        _timeL.textAlignment = NSTextAlignmentCenter;
    }
    return _timeL;
}
- (UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc]init];
        _contentL.font = [UIFont systemFontOfSize:14.0];
        _contentL.textColor = [ThemeManager shareManager].mainTextColor;
        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

@end
