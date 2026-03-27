//
//  PersonInfoNormalCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PersonInfoNormalCell.h"

@interface PersonInfoNormalCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *subL;

@property(nonatomic, strong) UIImageView *arrowImageV;

@property(nonatomic, strong) UIView *lineV;

@end

@implementation PersonInfoNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.offset(15);
    }];
    
    [self.arrowImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.offset(-15);
        make.width.offset(6);
        make.height.offset(11);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.bottom.mas_equalTo(self.contentView).offset(-15);
        make.height.offset(0.5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrowImageV.mas_left).offset(-7);
    }];
    
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.titleL.textColor = [ThemeManager shareManager].mainTextColor;
    self.subL.textColor = [ZYThemeManager shareManager].subTitleThemeColor_D949daa;
    self.lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    self.lineV.hidden = YES;//换成cell分割线不用view

    
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"";
        _titleL.font = FontSize_Vip_Nomail(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"";
        _subL.font = FontSize_Vip_Nomail(13);
        _subL.textColor = [Tool getColorWithHexString:@"#999999"];
        _subL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subL];
    }
    return _subL;
}


- (UIImageView *)arrowImageV{
    if (!_arrowImageV) {
        _arrowImageV = [[UIImageView alloc] init];
        _arrowImageV.image = [UIImage imageNamed:@"Settings_arrow"];
        [self.contentView addSubview:_arrowImageV];
    }
    return _arrowImageV;
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

#pragma mark - 赋值

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleL.text = title;
}

- (void)setSub:(NSString *)sub{
    _sub = sub;
    self.subL.text = sub;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
