//
//  InvoiceAssistantCell.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "InvoiceAssistantCell.h"

@interface InvoiceAssistantCell ()

@property(nonatomic, weak) UIView *mainV;

@property(nonatomic, weak) UILabel *titleL;

@property(nonatomic, weak) UILabel *subL;

@property(nonatomic, weak) UILabel *textL;


@end


@implementation InvoiceAssistantCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.mainV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.left.offset(15);
        make.top.offset(0);
    }];
    
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.mas_equalTo(self.mainV).offset(20);
        
    }];
    
    [self.subL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleL.mas_right).offset(5);
        make.centerY.mas_equalTo(self.titleL);
    }];
    
    [self.textL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(13);
        make.top.mas_equalTo(self.titleL.mas_bottom).offset(10);
        
    }];
}

#pragma mark - 懒加载

- (UIView *)mainV{
    if (!_mainV) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 7.5;
        view.clipsToBounds = YES;
        [self.contentView addSubview:view];
        _mainV = view;
    }
    return _mainV;
}


- (UILabel *)titleL{
    if (!_titleL) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"四川瑞欧尔环保科技有限公司";
        label.font = FontSize_Vip_Nomail(17);
        label.textColor = [Tool getColorWithHexString:@"#000000"];
        label.textAlignment = NSTextAlignmentLeft;
        [self.mainV addSubview:label];
        _titleL = label;
    }
    return _titleL;
}

- (UILabel *)subL{
    if (!_subL) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @" 默认 ";
        label.font = FontSize_Vip_Nomail(11);
        label.textColor = [Tool getColorWithHexString:@"#FF4D53"];
        label.textAlignment = NSTextAlignmentLeft;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = [Tool getColorWithHexString:@"#FF4D53"].CGColor;
        label.layer.cornerRadius = 2.5;
        label.clipsToBounds = YES;
        [self.mainV addSubview:label];
        _subL = label;
    }
    return _subL;
}

- (UILabel *)textL{
    if (!_textL) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"税号 91500209MA64J4064X";
        label.font = FontSize_Vip_Nomail(14);
        label.textColor = [Tool getColorWithHexString:@"#AAAAAA"];
        label.textAlignment = NSTextAlignmentLeft;
        [self.mainV addSubview:label];
        _textL = label;
    }
    return _textL;
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
