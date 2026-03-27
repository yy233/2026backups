//
//  ZYRedCardListCell.m
//  Community
//
//  Created by ZY on 2021/6/8.
//

#import "ZYRedCardListCell.h"

@interface ZYRedCardListCell ()

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ZYRedCardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

// 设置数据model
- (void)setModel:(ZYRedCardListDataModel *)model {
    _model = model;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%@", _model.money];
    self.titleLabel.text = _model.shopName;
    if (_model.type == 1) {
        self.typeLabel.text = @"店铺";
    }else {
        self.typeLabel.text = @"通用";
    }
    self.dateLabel.text = [NSString stringWithFormat:@"%@到期", _model.validityTime];
    if (_model.statesUS == 0) {
        self.userInteractionEnabled = YES;
        [self.statusButton setTitle:@"去使用" forState:UIControlStateNormal];
        self.statusButton.backgroundColor = Y_RGBA(255, 55, 61, 1);
    }else {
        self.userInteractionEnabled = NO;
        [self.statusButton setTitle:@"已过期" forState:UIControlStateNormal];
        self.statusButton.backgroundColor = Y_RGBA(200, 200, 200, 1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
