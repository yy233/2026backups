//
//  ZYSOSAddressBookAddHospitalCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookAddHospitalCell.h"

@interface ZYSOSAddressBookAddHospitalCell ()

@property (weak, nonatomic) IBOutlet UIButton *addHospitalButton;

@end

@implementation ZYSOSAddressBookAddHospitalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.addHospitalButton addTarget:self action:@selector(addHospitalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 处理点击事件
- (void)addHospitalButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addHospitalButtonEvent)]) {
        [self.delegate addHospitalButtonEvent];
    }
}

@end
