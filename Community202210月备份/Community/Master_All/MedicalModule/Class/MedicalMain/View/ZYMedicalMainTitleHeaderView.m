//
//  ZYMedicalMainTitleHeaderView.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainTitleHeaderView.h"

@implementation ZYMedicalMainTitleHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.moreButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:2];
}

@end
