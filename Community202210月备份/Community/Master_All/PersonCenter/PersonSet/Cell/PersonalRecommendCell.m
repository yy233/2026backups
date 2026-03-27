//
//  PersonalRecommendCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "PersonalRecommendCell.h"

@interface PersonalRecommendCell ()

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UISwitch *btn;

@end

@implementation PersonalRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(8);
        make.right.mas_equalTo(self.btn.mas_left).offset(-55);
    }];
}

#pragma mark - 懒加载

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"个性化推荐设置";
        _titleL.font = FontSize_Vip_Nomail(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#333333"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];
        _textL.text = @"关闭按钮后，将无法根据您的兴趣爱好、日常购买习惯为您推荐店铺或商品";
        _textL.font = FontSize_Vip_Nomail(12);
        _textL.textColor = [Tool getColorWithHexString:@"#999999"];
        _textL.textAlignment = NSTextAlignmentLeft;
        _textL.numberOfLines = 0;
        [self.contentView addSubview:_textL];
    }
    return _textL;
}

- (UISwitch *)btn{
    if (!_btn) {
        _btn = [[UISwitch alloc] init];
        _btn.onTintColor = [Tool getColorWithHexString:@"#008FFC"];
        [self.contentView addSubview:_btn];
    }
    return _btn;
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
