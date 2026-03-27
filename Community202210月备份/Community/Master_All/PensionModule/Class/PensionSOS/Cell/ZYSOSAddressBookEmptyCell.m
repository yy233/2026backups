//
//  ZYSOSAddressBookEmptyCell.m
//  Community
//
//  Created by ZY on 2021/11/17.
//

#import "ZYSOSAddressBookEmptyCell.h"

@interface ZYSOSAddressBookEmptyCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelWidthConstraint;


@property (weak, nonatomic) IBOutlet UIView *numView;

@end

@implementation ZYSOSAddressBookEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentLabelWidthConstraint.constant = kScreenW - 76;
    [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:CGSizeZero];
    self.numView.backgroundColor = [UIColor y_colorGradientChangeWithSize:CGSizeMake(20, 20) direction:IHGradientChangeDirectionLevel startColor:[UIColor zy_colorWithHexString:@"#FF8A8A"] endColor:[UIColor zy_colorWithHexString:@"#FF2323"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
