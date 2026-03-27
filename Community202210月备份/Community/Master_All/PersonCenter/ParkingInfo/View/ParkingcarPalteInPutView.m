//
//  ParkingcarPalteInPutView.m
//  Community
//
//  Created by 余莹 on 2021/9/27.
//

#import "ParkingcarPalteInPutView.h"
#define sublabel_tag   500

@interface ParkingcarPalteInPutView ()

@property (nonatomic,strong) UITextField *clearTextF;
@property (nonatomic,strong) UIView *backView;
//
@property (nonatomic,assign) NSInteger subLabelNumBer;
@property (nonatomic,strong) UIButton *topBtn;
@end

@implementation ParkingcarPalteInPutView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.clearTextF];//记录输入最后的值
        [self addSubview:self.backView];//众label的背景
        [self addSubview:self.topBtn];//顶部透明按钮 做输入触发
        [self setUI];
    }
    return self;
}
 
- (void)setUI{
    //
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_backView.superview);
    }];
    [self addSubLab];
}
- (void)addSubLab{
    [self.backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //
    for (int i = 0;  i< self.subLabelNumBer; i ++) {
        UILabel *subL = [self subLabel];
        subL.tag = sublabel_tag+i;
        [self.backView addSubview:subL];
    }
}
- (UILabel *)subLabel{
    UILabel *subL = [[UILabel alloc]init];
    return subL;
}

#pragma mark ==
- (UIButton *)topBtn{
    if (!_topBtn) {
        _topBtn = [[UIButton alloc]init];
    }
    return _topBtn;
}
//默认4个
- (NSInteger)subLabelNumBer{
    if ((!_subLabelNumBer) || (_subLabelNumBer == 0)) {
        _subLabelNumBer = 4;
    }
    return _subLabelNumBer;
}

#pragma mark ==
- (void)setLabelNum:(NSInteger)num{
    //更新数量限制
    self.subLabelNumBer = num;
    [self addSubLab];
}
@end
