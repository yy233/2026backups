//
//  ZYSOSAddressBookCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookCell.h"

@interface ZYSOSAddressBookCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UIButton *telButton;

@property (nonatomic,strong) NSString *savePhoneStr;
@end

@implementation ZYSOSAddressBookCell
- (void)fillDataWithFamilyModel:(SosAddressBookFamilyModel *)model{
    self.nameLabel.text = [TextShowWithModelStr textShowWithModelStr:model.name];
    self.telLabel.text = [TextShowWithModelStr textShowWithModelStr:model.mobile];
    self.savePhoneStr = [TextShowWithModelStr textShowWithModelStr:model.mobile];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.telButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self.telButton addTarget:self action:@selector(telButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)telButtonClicked {
    if (_delegate && [_delegate respondsToSelector:@selector(telButtonEventWithPhoneStr:)]) {
        [_delegate telButtonEventWithPhoneStr: self.savePhoneStr];
    }
}

@end
