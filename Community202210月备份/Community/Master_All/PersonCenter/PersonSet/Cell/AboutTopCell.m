//
//  AboutTopCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "AboutTopCell.h"

@interface AboutTopCell ()

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UIView *lineV;

@end

@implementation AboutTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        [self initData];
    }
    return self;
}

- (void)initView{
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.offset(40);
        make.width.offset(60);
        make.height.offset(60);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(16);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.bottom.mas_equalTo(self.contentView).offset(-15);;
        make.height.offset(0.5);
        make.bottom.equalTo(_lineV.superview).offset(-1);
    }];
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.titleL.textColor = [ThemeManager shareManager].mainTextColor;
    self.lineV.backgroundColor = [ThemeManager shareManager].themeLineColor;
    self.lineV.hidden = YES;//换成cell分割线不用view
    
    
}
- (void)initData{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app大版本号
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build小版本号
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    _titleL.text = [NSString stringWithFormat:@"version %@",app_Version];
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"version 1.0.0";
        _titleL.font = FontSize_Vip_Nomail(12);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"app-icon01"];
        _imageV.contentMode = UIViewContentModeScaleAspectFill;
        _imageV.layer.cornerRadius = 15;
        _imageV.clipsToBounds = YES;
        [self.contentView addSubview:_imageV];
      

    }
    return _imageV;
}


- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
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
