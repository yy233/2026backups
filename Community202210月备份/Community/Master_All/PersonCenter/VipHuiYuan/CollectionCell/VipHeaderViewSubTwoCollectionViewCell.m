//
//  VipHeaderViewSubTwoCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipHeaderViewSubTwoCollectionViewCell.h"

@implementation VipHeaderViewSubTwoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseLabelUI];
        [self upUI];
    }
    return self;
}
- (void)upUI{
    [self.centerL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
    }];
}
@end
