//
//  ChatVcSubStyemInfoWithAddMemberTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/5/10.
//

#import "ChatVcSubStyemInfoTableViewCell.h"

@implementation ChatVcSubStyemInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillSystemNoticeCellWithDateStr:(NSString *)dateStr withGroupAddMemberWithWillShowStr:(NSString *)willShowStr{
    //时间
   NSString *timeS = [TextShowWithModelStr textShowWithModelStr:dateStr];
   self.dateL.text = [ToolOfTimeChangeFormat getDataStrWithStr:timeS];
    
    if (willShowStr.length>0) {
        self.showSystemInfoLabel.text = willShowStr;
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (self) {
        [self setBaseCellTypeLeftOrRightOrCenter:ChatThisCellShowLeftRightSystemOtherType_SystemCenter];
        [self.backView addSubview:self.showSystemInfoLabel];
        [self setSystemInfoCellUI];
      
    }
    return self;
}
- (void)setSystemInfoCellUI{
    [_showSystemInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_showSystemInfoLabel.superview).offset(30);
        make.left.equalTo(_showSystemInfoLabel.superview).offset(10);
        make.right.equalTo(_showSystemInfoLabel.superview).offset(-10);
        make.bottom.equalTo(_showSystemInfoLabel.superview);
        make.height.offset(30);
    }];
    
}
- (UILabel *)showSystemInfoLabel{
    if (!_showSystemInfoLabel) {
        _showSystemInfoLabel = [[UILabel alloc]init];
        _showSystemInfoLabel.numberOfLines = 2;
        _showSystemInfoLabel.font = [UIFont systemFontOfSize:14.0];
        _showSystemInfoLabel.textAlignment = NSTextAlignmentCenter;
        _showSystemInfoLabel.backgroundColor = [UIColor clearColor];
        _showSystemInfoLabel.textColor = Y_ColorWith16FromRGB(0x333333);
    }
    return _showSystemInfoLabel;
}
@end
