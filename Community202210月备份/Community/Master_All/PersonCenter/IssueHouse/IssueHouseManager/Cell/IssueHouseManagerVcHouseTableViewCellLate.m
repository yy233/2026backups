//
//  IssueHouseManagerVcHouseTableViewCellLate.m
//  Community
//
//  Created by 余莹 on 2021/8/24.
//

#import "IssueHouseManagerVcHouseTableViewCellLate.h"

@implementation IssueHouseManagerVcHouseTableViewCellLate

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)fillData{
//    _qianYueStatuImgV.hidden;
//    self.editBtn.hidden;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [self.backView addSubview:self.qianYueStatuImgV];
        [self setNewUI];
        self.qianYueStatuImgV.hidden = YES;//暂时不使用类型图片
    }
    return self;
}
- (void)setNewUI{
    WEAKSELF
    //
    [_qianYueStatuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.centerSubsBackView).offset(10);
        make.width.height.offset(55);
        make.right.equalTo(_qianYueStatuImgV.superview).offset(-7);
    }];
}
- (UIImageView *)qianYueStatuImgV{
    if (!_qianYueStatuImgV) {
        _qianYueStatuImgV = [[UIImageView alloc]init];
        _qianYueStatuImgV.backgroundColor = [UIColor lightGrayColor];
    }
    return _qianYueStatuImgV;
}
@end
