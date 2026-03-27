//
//  IssueHouseManagerVcHouseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/19.
//

#import "IssueHouseManagerVcHouseTableViewCell.h"

@implementation IssueHouseManagerVcHouseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(IssueBuniessShopManagerListUseModel *)model{
    _model = model;
     _titleL.text = [TextShowWithModelStr textShowWithModelStr:model.address];
    _mongyL.text = [NSString stringWithFormat:@"¥%02.f",model.monthMoney];
    _typeL.text = [TextShowWithModelStr textShowWithModelStr:model.statusString];// (model.shopTypeId==1) ? @"营业中" : @"空置中";
    _detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.summarize];// @"临街门面 押三付三";
    [_imgV sd_setImageWithURL:[UrlWithString getURLWithStr:model.shopShowImg]];
   
}

//
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 7.5;
        [self.backView addSubview:self.imgV];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.mongyL];
        [self.backView addSubview:self.centerSubsBackView];
        [self.backView addSubview:self.blueSubsBackView];
        [self.backView addSubview:self.editBtn];
        //
        [self.centerSubsBackView addSubview:self.typeL];
        [self.centerSubsBackView addSubview:self.detailTipL];
//        [self.centerSubsBackView addSubview:self.editBtn];
        //
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgV.superview).offset(10);
        make.top.equalTo(_imgV.superview).offset(10);
        make.bottom.equalTo(_imgV.superview).offset(-10);
        make.width.equalTo(_imgV.mas_height);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV);
        make.left.equalTo(_imgV.mas_right).offset(10);
        make.right.equalTo(_titleL.superview).offset(-30);
    }];
    [_mongyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.bottom.equalTo(_imgV);
    }];
    [_centerSubsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleL);
        make.top.equalTo(_titleL.mas_bottom);
        make.bottom.equalTo(_mongyL.mas_top);
    }];
    [_blueSubsBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_centerSubsBackView);
        make.top.equalTo(_centerSubsBackView.mas_bottom);
        make.height.offset(1);//子类使用
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.offset(25);
        make.centerY.equalTo(_titleL);
        make.right.equalTo(_editBtn.superview).offset(-7);
    }];
    [self centerViewSubUI];
}
- (void)centerViewSubUI{
    [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(_typeL.superview);
        make.width.offset(40);
        make.height.offset(20);
    }];
//    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.centerY.equalTo(_editBtn.superview);
//        make.width.offset(20);
//        make.height.offset(25);
//    }];
    [_detailTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_detailTipL.superview);
        make.left.equalTo(_typeL.mas_right).offset(10);
        make.right.equalTo(_editBtn.mas_left).offset(-10);
    }];
    
}
#pragma mark ==
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
        [_imgV zy_cornerRadiusAdvance:2 rectCornerType:UIRectCornerAllCorners];
    }
    return _imgV;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = [UIFont boldSystemFontOfSize:15];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
    }
    return _titleL;
}
- (UILabel *)mongyL{
    if (!_mongyL) {
        _mongyL = [[UILabel alloc]init];
        _mongyL.font = [UIFont boldSystemFontOfSize:15];
        _mongyL.textColor = [ThemeManager shareManager].mainTextColor;//COlor_Red255;
    }
    return _mongyL;
}
//
- (UIView *)centerSubsBackView{
    if (!_centerSubsBackView) {
        _centerSubsBackView = [[UIView alloc]init];
    }
    return _centerSubsBackView;
}
//
- (UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.text = @"整租";//@"整租" 类型名
        _typeL.textColor = Color_38BlueColor;
        _typeL.font = [UIFont systemFontOfSize:11];
        _typeL.backgroundColor = [Color_38BlueColor colorWithAlphaComponent:0.1];
        _typeL.layer.cornerRadius = 10;
        _typeL.layer.masksToBounds = YES;
        _typeL.textAlignment = NSTextAlignmentCenter;
    }
    return _typeL;
}
- (UILabel *)detailTipL{
    if (!_detailTipL) {
        _detailTipL = [[UILabel alloc]init];
        _detailTipL.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _detailTipL.font = [UIFont systemFontOfSize:12];
    }
    return _detailTipL;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"Renting_List_modify"]];
        //
    }
    return _editBtn;
}
//
- (UIView *)blueSubsBackView{
    if (!_blueSubsBackView) {
        _blueSubsBackView = [[UIView alloc]init];
    }
    return _blueSubsBackView;
}
@end
