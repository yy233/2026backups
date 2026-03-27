//
//  CommonCacheCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "CommonCacheCell.h"
#import "CaschesTool.h"
#import "SDImageCache.h"

@interface CommonCacheCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *subL;

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UIView *lineV1;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation CommonCacheCell
- (void)btnClicked{
    if ([self.subL.text isEqualToString:@"0MB"]) {
        Y_SVP_SHOW_ERR_MES(@"暂无需清理");
        return;
    }
    DLog(@"清除缓存action");
    WEAKSELF
    [[CaschesTool share]clearFileWithSuccessOrFairBlcok:^(BOOL success, NSError * _Nonnull err) {
        STRONGSELF
        if (success) {
            
            Y_SVP_SHOW_SUCCESS_MES(@"清除缓存成功");
            strongSelf.subL.text = @"0MB";
        }else{
            Y_SVP_SHOW_ERR_MES(err.description);
        }
    }];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        [self setSubText];
    }
    return self;
}
- (void)setSubText{
  
  float cashFloat =  [[CaschesTool share]getCashSizeWithDefinefilePath];
    NSString *showNUMStr = [NSString stringWithFormat:@"%.2fMB", cashFloat];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.subL.text = showNUMStr;
    });
//    if (cashFloat >= pow(10, 9)) { // size >= 1GB
//        self.subL.text = [NSString stringWithFormat:@"%.2fGB", cashFloat / pow(10, 9)];
//    } else if (cashFloat >= pow(10, 6)) { // 1GB > size >= 1MB
//        self.subL.text = [NSString stringWithFormat:@"%.2fMB", cashFloat / pow(10, 6)];
//    } else if (cashFloat >= pow(10, 3)) { // 1MB > size >= 1KB
//        self.subL.text = [NSString stringWithFormat:@"%.2fKB", cashFloat / pow(10, 3)];
//    } else { // 1KB > size
//        self.subL.text = [NSString stringWithFormat:@"%fB", cashFloat];
//    }
}

- (void)initView{
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.offset(15);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.bottom.mas_equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(55);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(20);
    }];
    
    [self.lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.btn.mas_left).offset(-10);
        make.width.offset(0.5);
        make.centerY.mas_equalTo(self.contentView);
        make.height.offset(11);
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.lineV1.mas_left).offset(-10);
    }];
    
    self.titleL.textColor = [ThemeManager shareManager].mainTextColor;
    self.subL.textColor = [ThemeManager shareManager].mainTextColor;
    self.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
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
        _subL.text = @"0MB";
        _subL.font = FontSize_Vip_Nomail(13);
        _subL.textColor = [Tool getColorWithHexString:@"#999999"];
        _subL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subL];
    }
    return _subL;
}


- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

- (UIView *)lineV1{
    if (!_lineV1) {
        _lineV1 = [[UIView alloc] init];
        _lineV1.backgroundColor = [Tool getColorWithHexString:@"#BBBBBB"];
        [self.contentView addSubview:_lineV1];
    }
    return _lineV1;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"立即清除" forState:UIControlStateNormal];
        [_btn setTitleColor:[Tool getColorWithHexString:@"#2672F9"] forState:UIControlStateNormal];
        _btn.titleLabel.font = FontSize_Vip_Nomail(13);
        [_btn setImage:[UIImage imageNamed:@"white_arrow"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag = 0;
        [self.contentView addSubview:_btn];
    }
    return _btn;
}

#pragma mark - 赋值

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleL.text = title;
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
