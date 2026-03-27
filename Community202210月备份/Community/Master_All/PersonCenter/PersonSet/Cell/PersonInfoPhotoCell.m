//
//  PersonInfoPhotoCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PersonInfoPhotoCell.h"

@interface PersonInfoPhotoCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UIImageView *arrowImageV;

@property(nonatomic, strong) UIView *lineV;



@end

@implementation PersonInfoPhotoCell

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
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.arrowImageV.mas_left).offset(-7);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    [self.imageV zy_cornerRadiusRoundingRect];
    self.titleL.textColor = [ThemeManager shareManager].mainTextColor;
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.lineV.hidden = YES;
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

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageV];
    }
    return _imageV;
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
    _title =title;
    self.titleL.text = title;
}

- (void)setImg:(NSString *)img{
    _img = img;
    if (img.length<=0) {
        self.imageV.image = [UIImage imageNamed:@"My_headportrait"];
    }else{
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    }
   
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
