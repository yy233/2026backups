//
//  LifeCostAccountManageTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/3/23.
//

#import "LifeCostAccountManageTableViewCell.h"

@implementation LifeCostAccountManageTableViewCell

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
        self.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.indentationLevel =  2;
        self.indentationWidth = 10;
        self.separatorInset = UIEdgeInsetsMake(0, 26, 0, 26);
        /**
         @property (nonatomic,strong) UILabel *titleL;
         @property (nonatomic,strong) UILabel *detailTitleL;
         @property (nonatomic,strong) UIButton *editBtn;
         @property (nonatomic,strong) UIButton *deletBtn;
         
         */
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.detailTitleL];
        [self.contentView addSubview:self.editBtn];
        [self.contentView addSubview:self.deletBtn];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_deletBtn.superview).offset(-26);
        make.centerY.equalTo(_deletBtn.superview);
        make.width.height.offset(25);
    }];
    [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_deletBtn.mas_right).offset(-30);
        make.centerY.equalTo(_deletBtn.superview);
        make.width.height.offset(25);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.superview).offset(5);
        make.left.equalTo(_titleL.superview).offset(50);
        make.right.equalTo(_editBtn.mas_left);
        make.height.offset(20);
    }];
    [_detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleL.mas_bottom).offset(3);
        make.left.equalTo(_titleL);
        make.right.equalTo(_titleL);
        make.height.offset(20);
    }];
}
//
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont systemFontOfSize:16];
    }
    return _titleL;
}
- (UILabel *)detailTitleL{
    if (!_detailTitleL) {
        _detailTitleL = [[UILabel alloc]init];
        _detailTitleL.textColor = Y_ColorWith16FromRGB(0xC5C9D4);
        _detailTitleL.font = [UIFont systemFontOfSize:13];
    }
    return _detailTitleL;
}
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn newAnBtnWithImg:[UIImage imageNamed:@"Accountnumbermanagement_Editor_night"]];
    }
    return _editBtn;
}
- (UIButton *)deletBtn{
    if (!_deletBtn) {
        _deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deletBtn newAnBtnWithImg:[UIImage imageNamed:@"Accountnumbermanagement_Delete_night"]];
    }
    return _deletBtn;
}
@end
