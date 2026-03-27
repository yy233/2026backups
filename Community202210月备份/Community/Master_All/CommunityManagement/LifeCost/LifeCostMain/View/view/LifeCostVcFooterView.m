//
//  LifeCostVcFooterView.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import "LifeCostVcFooterView.h"
#define Color_subBtn    Y_RGBA(38, 114, 249, 1)
#define W_subBtnsAllW   ((Screen_W-32-30))
#define W_subBtn        ( W_subBtnsAllW/4 )
#define H_subBtn        30
#define Tag_subBtn      350

@interface LifeCostVcFooterView ()
@property (nonatomic,strong) UIView *backview;
 
@end

@implementation LifeCostVcFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backview];
        [self setUI];
        [self addSubBtn];
    }
    return self;
}
#pragma mark ===
- (void)subBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-Tag_subBtn;
    LifeCostVcFooter_Btn_Type type = LifeCostVcFooter_Btn_Type_Help;
    switch (index) {
        case 0:
            type = LifeCostVcFooter_Btn_Type_CostList;
            break;
        case  1:
            type = LifeCostVcFooter_Btn_Type_CostSet;
            break;
        case 2:
            type = LifeCostVcFooter_Btn_Type_CostCardIdManager;
            break;
        case 3:
            type = LifeCostVcFooter_Btn_Type_Help;
            break;
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(footerViewChooseBtnWith:)]) {
        [_delegate footerViewChooseBtnWith:type];
    }
}

- (void)setUI{
    [_backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backview.superview.mas_centerX);
        make.centerY.equalTo(_backview.superview.mas_centerY);
        make.height.equalTo(_backview.superview.mas_height).offset(-20);
         make.width.offset(W_subBtnsAllW);
    }];
}
//- (void)addSubBtn{
//    [self.backview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//旧数据去掉
//    NSArray *titleArr = [NSArray arrayWithObjects:@"缴费记录",@"缴费设置",@"户号管理",@"帮助中心", nil];
//    NSInteger count = titleArr.count;
//    for (int i = 0; i < count; i ++) {
//        UIButton *btn = [self baseBtn];
//        [btn setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
//        btn.frame = CGRectMake(i*(W_subBtn+10), 0, W_subBtn, H_subBtn);
//        btn.tag = Tag_subBtn +i;
//        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.backview addSubview:btn];
//        UIView *lineV = [[UIView alloc]init];
//        if (i<3) {
//            lineV.frame = CGRectMake((i+1)*(W_subBtn+5), 10, 1, 10);//30 10 10
//            lineV.backgroundColor = [UIColor lightGrayColor];
//            [self.backview addSubview:lineV];
//        }
//    }
//}
- (void)addSubBtn{
    [self.backview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//旧数据去掉
    NSArray *titleArr = [NSArray arrayWithObjects:@"缴费记录",@"缴费设置",@"户号管理",@"帮助中心", nil];
    NSInteger count = titleArr.count;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [self baseBtn];
        [btn setTitle:[NSString stringWithFormat:@"%@",titleArr[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*(W_subBtn), 0, W_subBtn, H_subBtn);
        btn.tag = Tag_subBtn +i;
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.backview addSubview:btn];
        UIView *lineV = [[UIView alloc]init];
        if (i<3) {
            lineV.frame = CGRectMake((i+1)*(W_subBtn-0.5), 10, 1, 10);
            lineV.backgroundColor = [UIColor lightGrayColor];
            [self.backview addSubview:lineV];
        }
    }
}
- (UIButton *)baseBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:Color_subBtn forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    return btn;
}

#pragma mark ====
- (UIView *)backview{
    if (!_backview) {
        _backview = [[UIView alloc]init];
    }
    return _backview;
}
@end

