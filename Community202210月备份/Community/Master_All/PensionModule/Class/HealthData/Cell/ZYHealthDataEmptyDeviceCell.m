//
//  ZYHealthDataEmptyDeviceCell.m
//  Community
//
//  Created by ZY on 2021/11/8.
//

#import "ZYHealthDataEmptyDeviceCell.h"

@interface ZYHealthDataEmptyDeviceCell ()

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@end

@implementation ZYHealthDataEmptyDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buyButton.layer.borderWidth = 0.5;
    self.buyButton.layer.borderColor = Y_RGBA(83, 156, 252, 1).CGColor;
    self.buyButton.layer.cornerRadius = 2.5;
    self.buyButton.layer.masksToBounds = YES;
    [self.buyButton addTarget:self action:@selector(buyButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)buyButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyButtonEvent)]) {
        [self.delegate buyButtonEvent];
    }
}

@end
