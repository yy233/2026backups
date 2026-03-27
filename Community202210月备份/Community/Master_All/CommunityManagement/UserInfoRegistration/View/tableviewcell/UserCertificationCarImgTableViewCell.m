//
//  UserCertificationCarImgTableViewCell.m
//  Community
//
//  Created by 余莹 on 2020/11/23.
//

#import "UserCertificationCarImgTableViewCell.h"
@interface UserCertificationCarImgTableViewCell ()
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *lineView;

@end
@implementation UserCertificationCarImgTableViewCell

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
        [self.contentView addSubview:self.backView];
        [self.contentView addSubview:self.titleL];
        [self.contentView addSubview:self.bottomBtnWhenNotImgShow];
        [self.contentView addSubview:self.addImgBtn];
        [self.contentView addSubview:self.lineView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    _titleL.text = @"行驶证图片";
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleL.superview.mas_centerY);
        make.left.equalTo(_titleL.superview.mas_left).offset(16);
        make.height.offset(20);
    }];
    [_addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addImgBtn.superview.mas_centerY);
        make.right.equalTo(_addImgBtn.superview.mas_right).offset(-16);
        make.width.offset(65);
        make.height.offset(65);
    }];
    [_bottomBtnWhenNotImgShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_addImgBtn);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.bottom.equalTo(_lineView.superview);
        make.left.equalTo(_lineView.superview).offset(16);
        make.right.equalTo(_lineView.superview).offset(-16);
    }];
    
}
//
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
 
-(UIButton *)addImgBtn{
    if (!_addImgBtn) {
        _addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addImgBtn.backgroundColor = [UIColor clearColor];//
        [_addImgBtn addTarget:self.superview action:@selector(addImgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImgBtn;
}
//btnWithNotImg放在addimgbtn的底部 用于显示无数据时的view 不做事件
- (UIButton *)bottomBtnWhenNotImgShow{
    if (!_bottomBtnWhenNotImgShow) {
        _bottomBtnWhenNotImgShow = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtnWhenNotImgShow newAnBtnWithBackColor:Y_ColorWith16FromRGB(0xEEEEEE)];
        [_bottomBtnWhenNotImgShow newAnBtnWithTextColor:Y_ColorWith16FromRGB(0x999999)];
        [_bottomBtnWhenNotImgShow newAnBtnWithFont:[UIFont systemFontOfSize:11]];
        [_bottomBtnWhenNotImgShow newAnBtnWithTextStr:@"添加图片"];
        [_bottomBtnWhenNotImgShow newAnBtnWithImg:[UIImage imageNamed:@"Drivinglicense_Addpicture_night"]];
        [_bottomBtnWhenNotImgShow layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:5];
    }
    return _bottomBtnWhenNotImgShow;
}
 
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [ThemeManager shareManager].mainContentLineColor;
    }
    return _lineView;
}
@end
