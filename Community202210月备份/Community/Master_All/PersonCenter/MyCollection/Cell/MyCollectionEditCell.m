//
//  MyCollectionEditCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "MyCollectionEditCell.h"

@interface MyCollectionEditCell ()

@property(nonatomic, strong) UIButton *btn;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *subL;

@property(nonatomic, strong) UILabel *textL;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UILabel *scoreL;

@property(nonatomic, strong) UIImageView *scoreImageV1;
@property(nonatomic, strong) UIImageView *scoreImageV2;
@property(nonatomic, strong) UIImageView *scoreImageV3;
@property(nonatomic, strong) UIImageView *scoreImageV4;
@property(nonatomic, strong) UIImageView *scoreImageV5;

@property(nonatomic, strong) UIView *lineV;

@end

@implementation MyCollectionEditCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(27);
        make.centerY.mas_equalTo(self.contentView);
        make.width.offset(22);
        make.height.offset(22);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.btn.mas_right).offset(27);
        make.centerY.mas_equalTo(self.contentView);
        make.width.offset(62);
        make.height.offset(62);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV);
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.right.offset(-10);
    }];
    
    [self.scoreL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.width.offset(60);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
    }];

    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imageV.mas_right).offset(10);
        make.bottom.mas_equalTo(self.imageV);
    }];

    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(30);
        make.bottom.mas_equalTo(self.imageV);
    }];

    [self.scoreImageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreL.mas_right).offset(5);
        make.centerY.mas_equalTo(self.scoreL);
        make.width.offset(11);
        make.height.offset(10.5);
    }];

    [self.scoreImageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreImageV1.mas_right).offset(5);
        make.centerY.mas_equalTo(self.scoreL);
        make.width.offset(11);
        make.height.offset(10.5);
    }];

    [self.scoreImageV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreImageV2.mas_right).offset(5);
        make.centerY.mas_equalTo(self.scoreL);
        make.width.offset(11);
        make.height.offset(10.5);
    }];

    [self.scoreImageV4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreImageV3.mas_right).offset(5);
        make.centerY.mas_equalTo(self.scoreL);
        make.width.offset(11);
        make.height.offset(10.5);
    }];

    [self.scoreImageV5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scoreImageV4.mas_right).offset(5);
        make.centerY.mas_equalTo(self.scoreL);
        make.width.offset(11);
        make.height.offset(10.5);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.mas_equalTo(self.contentView);
        make.height.offset(0.5);
    }];
    
}

#pragma mark - 懒加载

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitleColor:[Tool getColorWithHexString:@"#202020"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"Lookup_Type_normal"] forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:@"Lookup_Type_choice"] forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag = 0;
        _btn.selected = NO;
        [self.contentView addSubview:_btn];
    }
    return _btn;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"尊宝披萨（龙湖店）";
        _titleL.font = FontSize_Vip_Nomail(15);
        _titleL.textColor = [Tool getColorWithHexString:@"#2B2C2F"];
        _titleL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc] init];
        _textL.text = @"起送￥15  配送￥0.5";
        _textL.font = FontSize_Vip_Nomail(11);
        _textL.textColor = [Tool getColorWithHexString:@"#AAAEB9"];
        _textL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textL];
    }
    return _textL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"30分钟 1.3km";
        _subL.font = FontSize_Vip_Nomail(11);
        _subL.textColor = [Tool getColorWithHexString:@"#AAAEB9"];
        _subL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_subL];
    }
    return _subL;
}

- (UILabel *)scoreL{
    if (!_scoreL) {
        _scoreL = [[UILabel alloc] init];
        _scoreL.text = @"3.7分";
        _scoreL.font = FontSize_Vip_Nomail(12);
        _scoreL.textColor = [Tool getColorWithHexString:@"#FF3234"];
        _scoreL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_scoreL];
    }
    return _scoreL;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
//        _imageV.backgroundColor = [UIColor orangeColor];
        _imageV.image = [UIImage imageNamed:@"Members_chart"];
        [self.contentView addSubview:_imageV];
    }
    return _imageV;
}

- (UIImageView *)scoreImageV1{
    if (!_scoreImageV1) {
        _scoreImageV1 = [[UIImageView alloc] init];
        _scoreImageV1.image = [UIImage imageNamed:@"Collection_real"];
        [self.contentView addSubview:_scoreImageV1];
    }
    return _scoreImageV1;
}

- (UIImageView *)scoreImageV2{
    if (!_scoreImageV2) {
        _scoreImageV2 = [[UIImageView alloc] init];
        _scoreImageV2.image = [UIImage imageNamed:@"Collection_real"];
        [self.contentView addSubview:_scoreImageV2];
    }
    return _scoreImageV2;
}

- (UIImageView *)scoreImageV3{
    if (!_scoreImageV3) {
        _scoreImageV3 = [[UIImageView alloc] init];
        _scoreImageV3.image = [UIImage imageNamed:@"Collection_Halfstar"];//Collection_Greystar空白星星
        [self.contentView addSubview:_scoreImageV3];
    }
    return _scoreImageV3;
}


- (UIImageView *)scoreImageV4{
    if (!_scoreImageV4) {
        _scoreImageV4 = [[UIImageView alloc] init];
        _scoreImageV4.image = [UIImage imageNamed:@"Collection_Greystar"];
        [self.contentView addSubview:_scoreImageV4];
    }
    return _scoreImageV4;
}

- (UIImageView *)scoreImageV5{
    if (!_scoreImageV5) {
        _scoreImageV5 = [[UIImageView alloc] init];
        _scoreImageV5.image = [UIImage imageNamed:@"Collection_Greystar"];
        [self.contentView addSubview:_scoreImageV5];
    }
    return _scoreImageV5;
}


- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_lineV];
    }
    return _lineV;
}

- (void)btnClicked: (UIButton *)sender{
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(cellSeletedWithModel:status:)]) {
        [self.delegate cellSeletedWithModel:self.model status:sender.selected];
    }
}


#pragma mark - 模型赋值

- (void)setModel:(MyCollectionModel *)model{
    _model = model;
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
