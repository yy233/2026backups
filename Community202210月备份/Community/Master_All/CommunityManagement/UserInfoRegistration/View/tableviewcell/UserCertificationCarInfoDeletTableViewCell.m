//
//  UserCertificationCarInfoDeletTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/12.
//

#import "UserCertificationCarInfoDeletTableViewCell.h"

@implementation UserCertificationCarInfoDeletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

 
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.deletCarInfoBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_deletCarInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_deletCarInfoBtn.superview);
    }];
}
- (UIButton *)deletCarInfoBtn{
    if (!_deletCarInfoBtn) {
        _deletCarInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletCarInfoBtn newAnBtnWithBackColor: Color_11BlueColor ] ;
        [_deletCarInfoBtn newAnBtnWithTextColor:Y_ColorWith16FromRGB(0xC3D8FF)];
        [_deletCarInfoBtn newAnBtnWithFont:[UIFont systemFontOfSize:11]];
        [_deletCarInfoBtn newAnBtnWithTextStr:@"删除车辆"];
        [_deletCarInfoBtn newAnBtnWithImg:[UIImage imageNamed:@"vehicle_delete"]];
        [_deletCarInfoBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_deletCarInfoBtn addTarget:self action:@selector(deletCarInfoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletCarInfoBtn;
}
 
- (void)deletCarInfoBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(touchCarInfoDeletBtnWithCarSectionNum:)]) {
        [_delegate touchCarInfoDeletBtnWithCarSectionNum:self.carSectionNum];
    }
}
@end
