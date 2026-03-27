//
//  WeatherCityChooseCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "WeatherCityChooseCell.h"

@interface WeatherCityChooseCell ()

@property(nonatomic, strong) UIView *lineV;

@end

@implementation WeatherCityChooseCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textLabel.mas_left);
        make.right.offset(0);
        make.height.offset(0.5);
        make.bottom.offset(0);
    }];
}

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#C5C9D4"];
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
