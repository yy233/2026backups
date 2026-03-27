//
//  ZYContractingPartyInformationEditBottomView.m
//  Community
//
//  Created by ZY on 2021/9/23.
//

#import "ZYContractingPartyInformationEditBottomView.h"

@implementation ZYContractingPartyInformationEditBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGSize size = CGSizeMake(kScreenW - 72, 50);
    self.okButton.backgroundColor = [[ZYThemeManager shareManager] electronicBottomGradientColorWithSize:size];
}

@end
