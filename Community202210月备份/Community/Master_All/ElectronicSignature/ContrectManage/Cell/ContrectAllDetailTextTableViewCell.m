//
//  ContrectAllDetailTextTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/28.
//

#import "ContrectAllDetailTextTableViewCell.h"

@interface ContrectAllDetailTextTableViewCell ()

@end

@implementation ContrectAllDetailTextTableViewCell

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
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.detailTitleL];
        [self.backView addSubview:self.lineView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 0));
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.bottom.left.equalTo(_backView);
        make.width.offset(110);
    }];
    [_detailTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.bottom.equalTo(_backView);
        make.left.equalTo(_titleL.mas_right);
        make.right.equalTo(_backView.mas_right);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(_lineView.superview);
        make.right.equalTo(_lineView.superview).offset(-16);
        make.height.offset(0.5);
    }];
}
#pragma markl ==
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = [ZYThemeManager shareManager].titleThemeColor;
        _titleL.font = FontSize_ElectronicSignature_Nomail(15);
     }
    return _titleL;
}
- (UILabel *)detailTitleL{
    if (!_detailTitleL) {
        _detailTitleL = [[UILabel alloc]init];
        _detailTitleL.textColor =  [ZYThemeManager shareManager].titleThemeColor;
        _detailTitleL.font = FontSize_ElectronicSignature_Nomail(15);
     }
    return _detailTitleL;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    }
    
    return _lineView;
}

@end
