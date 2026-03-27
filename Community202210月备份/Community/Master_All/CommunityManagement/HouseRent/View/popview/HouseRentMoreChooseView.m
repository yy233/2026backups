//
//  HouseRentMoreChooseView.m
//  Community
//
//  Created by 余莹 on 2021/1/4.
//

#import "HouseRentMoreChooseView.h"

@interface HouseRentMoreChooseView ()
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UIView *contentBackView;
@end
@implementation HouseRentMoreChooseView
 
- (void)setSourceDic:(NSDictionary *)sourceDic{
    _sourceDic = sourceDic;
    NSArray *arrKey = [sourceDic allKeys];
    NSLog(@"---- setSourceDic ------- %@",arrKey);
}

#pragma mark===
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.contentBackView];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [_contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contentBackView.superview).insets(UIEdgeInsetsMake(0, 50, 0, 0));
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _backView;
}

- (UIView *)contentBackView{
    if (!_contentBackView) {
        _contentBackView = [[UIView alloc]init];
        _contentBackView.backgroundColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor;
    }
    return _contentBackView;
}

@end
