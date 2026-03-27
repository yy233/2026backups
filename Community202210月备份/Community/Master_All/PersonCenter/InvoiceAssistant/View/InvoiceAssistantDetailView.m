//
//  InvoiceAssistantDetailView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/24.
//

#import "InvoiceAssistantDetailView.h"

@interface InvoiceAssistantDetailView ()

@property(nonatomic, strong) UIView *lineV;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, strong) UILabel *subL;

@property(nonatomic, strong) UILabel *remarkL;

@property(nonatomic, strong) UIImageView *imageV;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation InvoiceAssistantDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.offset(0.5);
    }];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.offset(-50);
        make.width.offset(195);
        make.height.offset(195);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageV.mas_top).offset(-60);
        make.centerX.mas_equalTo(self);
        
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.imageV.mas_top).offset(-33);
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(self.titleL);
    }];
    
    [self.remarkL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageV.mas_bottom).offset(27);
        make.centerX.mas_equalTo(self);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkL.mas_bottom).offset(35);
        make.centerX.mas_equalTo(self);
        make.width.offset(150);
        make.height.offset(45);
    }];
    
    
}

#pragma mark - 懒加载

- (UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = [Tool getColorWithHexString:@"#EEEEEE"];
        [self addSubview:_lineV];
    }
    return _lineV;
}

- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.text = @"公司名称：四川瑞欧尔环保科技有限公司";
        _titleL.font = FontSize_Vip_Nomail(14);
        _titleL.textColor = [Tool getColorWithHexString:@"#000000"];
        _titleL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleL];
    }
    return _titleL;
}

- (UILabel *)subL{
    if (!_subL) {
        _subL = [[UILabel alloc] init];
        _subL.text = @"公司税号：91500209MA64J4064X";
        _subL.font = FontSize_Vip_Nomail(14);
        _subL.textColor = [Tool getColorWithHexString:@"#000000"];
        _subL.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_subL];
    }
    return _subL;
}

- (UILabel *)remarkL{
    if (!_remarkL) {
        _remarkL = [[UILabel alloc] init];
        _remarkL.text = @"开票时出示给商家，快速提供抬头信息";
        _remarkL.font = FontSize_Vip_Nomail(14);
        _remarkL.textColor = [Tool getColorWithHexString:@"#999999"];
        _remarkL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_remarkL];
    }
    return _remarkL;
}

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        self.imageV.image = [UIImage generateQRCodeWithString:@"4654asdjfiajiodfaidfkadfkasdfdfiodfoidf68d" Size:195];
        [self addSubview:_imageV];
    }
    return _imageV;
}

- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitle:@"编辑" forState:UIControlStateNormal];
        [_btn setTitleColor:[Tool getColorWithHexString:@"#282828"] forState:UIControlStateNormal];
        _btn.layer.cornerRadius = 3.5;
        _btn.layer.borderWidth = 0.5;
        _btn.layer.borderColor = [Tool getColorWithHexString:@"#7D7D7D"].CGColor;
        _btn.clipsToBounds = YES;
        _btn.titleLabel.font = FontSize_Vip_Nomail(15);
        [_btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn.tag = 0;
        [self addSubview:_btn];
    }
    return _btn;
}

#pragma mark - 按钮点击

- (void)btnClicked: (UIButton *)sender{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
