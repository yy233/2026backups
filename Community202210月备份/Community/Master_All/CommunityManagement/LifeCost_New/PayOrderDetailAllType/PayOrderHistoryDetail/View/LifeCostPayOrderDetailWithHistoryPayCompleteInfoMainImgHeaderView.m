//
//  LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainHeaderView.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView.h"

@implementation LifeCostPayOrderDetailWithHistoryPayCompleteInfoMainImgHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imgV.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    if ([ThemeManager shareManager].type == ThemeType_White) {
        _imgV.image = [UIImage imageNamed:@"OrderDetailHeaderV"];
    }else{
        _imgV.image = [UIImage imageNamed:@"OrderDetailHeaderV_DrakType"];
    }
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
 
    }
    return _imgV;
}
@end
