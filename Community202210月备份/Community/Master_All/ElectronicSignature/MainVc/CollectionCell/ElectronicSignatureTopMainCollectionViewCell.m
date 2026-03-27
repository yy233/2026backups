//
//  ElectronicSignatureTopMainCollectionViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureTopMainCollectionViewCell.h"

@implementation ElectronicSignatureTopMainCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self.backV addSubview:self.detailL];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleL);
        make.top.equalTo(self.titleL.mas_bottom);
        make.height.offset(20);
    }];
    self.titleL.textColor = [UIColor blackColor];
    self.detailL.textColor = Y_RGBA(136, 136, 136, 1);
    self.titleL.font = [UIFont systemFontOfSize:14];
    self.detailL.font = [UIFont systemFontOfSize:12];
}
//
- (UILabel *)detailL{
    if (!_detailL) {
        _detailL = [[UILabel alloc]init];
        _detailL.textAlignment = NSTextAlignmentCenter;
    }
    return _detailL;
}
@end
