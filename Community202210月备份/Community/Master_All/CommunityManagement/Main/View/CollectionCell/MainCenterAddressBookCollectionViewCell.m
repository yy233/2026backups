//
//  MainCenterAddressBookCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/17.
//

#import "MainCenterAddressBookCollectionViewCell.h"
#define   PhoneImgBtn_BgeinColor  Y_RGBA(13, 98, 252, 1)
#define   PhoneImgBtn_EndColor    Y_RGBA(48, 189, 255, 1)
@interface MainCenterAddressBookCollectionViewCell ()

@end
@implementation MainCenterAddressBookCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backImgView];
        [self.contentView addSubview:self.headerImgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.phoneImgBtn];
        [self setUI];
        [self setTheme];
    }
    return self;
}
- (void)setTheme{
    _titleLabel.textColor = [ThemeManager shareManager].mainAddressBookCellTextColor;
    _backImgView.backgroundColor = [ThemeManager shareManager].mainAddressBookCellBackGroundColor;

}
-(void)prepareForReuse{
    [super prepareForReuse];
    _backImgView.image = nil;
    _headerImgView.image = nil;
    _titleLabel.text = nil;
    [self setTheme];
}
-(void)setModel:(MainCenterCollectionViewAddressBookCellModel *)model{
    [self setTheme];
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%@",model.department];
    [self setHeaderImg];
}
- (void)setHeaderImg{
    if ([_model.department containsString:@"物业"]) {
        _headerImgView.image = [UIImage imageNamed:@"Addressbook_PropertyDepartment"];
        return;
    }
    if ([_model.department containsString:@"保卫"]) {
        _headerImgView.image = [UIImage imageNamed:@"Addressbook_SecurityDepartment"];
        return;
    }
    if ([_model.department containsString:@"后勤"]) {
        _headerImgView.image = [UIImage imageNamed:@"Addressbook_LogisticsDepartment"];
        return;
    }
    _headerImgView.image = [UIImage imageNamed:@"Addressbook_LogisticsDepartment"];
}


- (void)setUI{
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgView.superview);
    }];

    [_headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImgView.superview.mas_left);
        make.bottom.equalTo(_headerImgView.superview.mas_bottom);
        make.right.equalTo(_headerImgView.superview.mas_right);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(10);
        make.right.equalTo(_titleLabel.superview.mas_right);
        make.height.offset(15);
    }];
    [_phoneImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.offset(32);
        make.height.offset(20);
    }];
}
- (UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc]init];
        _backImgView.contentMode = UIViewContentModeScaleAspectFit;
        _backImgView.layer.cornerRadius = 5;
        _backImgView.layer.masksToBounds = YES;
    }
    return _backImgView;
}
- (UIImageView *)headerImgView{
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc]init];
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.contentMode = UIViewContentModeBottom;
    }
    return _headerImgView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UIButton *)phoneImgBtn{
    if (!_phoneImgBtn) {
        _phoneImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneImgBtn.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(32, 20) direction:IHGradientChangeDirectionLevel startColor:PhoneImgBtn_BgeinColor endColor:PhoneImgBtn_EndColor];
        [_phoneImgBtn setImage:[UIImage imageNamed:@"Addressbook_Telephone_night"] forState:UIControlStateNormal];
        _phoneImgBtn.layer.cornerRadius = 10;
    }
    return _phoneImgBtn;
}
@end
