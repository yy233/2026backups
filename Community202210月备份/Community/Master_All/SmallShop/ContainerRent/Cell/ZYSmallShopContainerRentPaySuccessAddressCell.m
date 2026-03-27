//
//  ZYSmallShopContainerRentPaySuccessAddressCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPaySuccessAddressCell.h"

@interface ZYSmallShopContainerRentPaySuccessAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIButton *navigationButton;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation ZYSmallShopContainerRentPaySuccessAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.navigationButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.navigationButton addTarget:self action:@selector(navigationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.chatButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.chatButton addTarget:self action:@selector(chatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.telLabel.userInteractionEnabled = YES;
    [self.telLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telLabelTap)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentDetailModel *)model {
    _model = model;
    
    self.telLabel.text = _model.storePhone;
    self.addressLabel.text = _model.storeAddress;
}

#pragma mark - 处理点击事件
- (void)navigationButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationButtonEvent)]) {
        [self.delegate navigationButtonEvent];
    }
}

- (void)chatButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatButtonEvent)]) {
        [self.delegate chatButtonEvent];
    }
}

- (void)telLabelTap {
    if (self.model.storePhone.length > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.model.storePhone]] options:@{} completionHandler:nil];
        }else{
            //设备系统为IOS 10.0以下的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", self.model.storePhone]]];
        }
    }
}

@end
