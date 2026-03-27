//
//  GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/27.
//

#import "GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell.h"

@interface GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell ()
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@end

@implementation GuestInfoRegistionCarTypeHaveChooseBtnTableViewCell

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
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.payTypeChooseBtn];
        [self setCarPayChooseCellUI];
 
    }
    return self;
}
- (void)setCarPayChooseCellUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.height.offset(20);
        make.width.offset(100);
    }];
    [_payTypeChooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.height.centerY.equalTo(_payTypeChooseBtn.superview);
        make.right.equalTo(_payTypeChooseBtn.superview).offset(-26);
    }];
    _titleL.text = @"是否代缴车费"; 
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
//        _backView.backgroundColor = [ThemeManager shareManager].mainContentBackgroundColor;
//        _backView.layer.cornerRadius = 5;//
//        _backView.layer.masksToBounds = YES;
    }
    return _backView;
    
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ThemeManager shareManager].mainTextColor;
        _titleL.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleL;
}
- (UIButton *)payTypeChooseBtn{
    if (!_payTypeChooseBtn) {
        _payTypeChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payTypeChooseBtn newAnBtnWithNomalImg:[UIImage imageNamed:@"category_default"] selectedImg:[UIImage imageNamed:@"category_Select"]];
//        [_payTypeChooseBtn addTarget:<#(nullable id)#> action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>]
    }
    return _payTypeChooseBtn;
}
@end
