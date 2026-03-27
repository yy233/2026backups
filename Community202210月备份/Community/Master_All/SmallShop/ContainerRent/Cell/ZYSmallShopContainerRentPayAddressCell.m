//
//  ZYSmallShopContainerRentPayAddressCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPayAddressCell.h"

@interface ZYSmallShopContainerRentPayAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end

@implementation ZYSmallShopContainerRentPayAddressCell

- (void)fillNewAddressStr:(NSString *)addressStr andPhoneStr:(NSString *)phoneStr{
    self.addressLabel.text = addressStr;
    self.telLabel.text = phoneStr;

    [self setNeedsLayout];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.editButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:6];
    [self.editButton addTarget:self action:@selector(editButtonCLicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)editButtonCLicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonEvent)]) {
        [self.delegate editButtonEvent];
    }
}

@end
