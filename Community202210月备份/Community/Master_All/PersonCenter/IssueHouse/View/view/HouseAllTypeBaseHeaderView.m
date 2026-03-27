//
//  HouseAllTypeBaseHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/1/19.
//

#import "HouseAllTypeBaseHeaderView.h"

@implementation HouseAllTypeBaseHeaderView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        [self addSubview:self.backImgv];
        [self addSubview:self.centerBtn];
        [self addSubview:self.cycleScrollView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    [_backImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgv.superview);
    }];
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backImgv.superview);
    }];
    [_centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(100);
        make.width.offset(100);
        make.centerX.equalTo(_centerBtn.superview.mas_centerX);
        make.centerY.equalTo(_centerBtn.superview.mas_centerY);
    }];
}
#pragma mark ===
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_centerBtn setTitle:@"上传照片" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _centerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_centerBtn setImage:[UIImage imageNamed:@"Basicinformation_Uploadphotos"] forState:UIControlStateNormal];
    }
    return _centerBtn;
}
- (UIImageView *)backImgv{
    if (!_backImgv) {
        _backImgv = [[UIImageView alloc]init];
        _backImgv.contentMode = UIViewContentModeScaleToFill;
        _backImgv.image = [UIImage imageNamed:@"Basicinformation_default"];
    }
    return _backImgv;
}

- (SDCycleScrollView *)cycleScrollView{ 
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor clearColor];
        _cycleScrollView.pageDotColor = [UIColor clearColor];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;//
        _cycleScrollView.hidden = YES;
        
    }
    return _cycleScrollView;
}
@end
