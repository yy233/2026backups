//
//  YuEMingXiHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "YuEMingXiHeaderView.h"
#define  W_SubBtn   65
@implementation YuEMingXiHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubs];
    }
    return self;
}
- (void)addSubs{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *arrT = [[NSArray alloc]initWithObjects:@"全部",@"支出",@"收入", nil];
    for (int  i = 0 ; i <arrT.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(subBtnsAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
        [btn newAnBtnWithTextStr:arrT[i]];
        //
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        [btn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(15)];
        [btn newAnBtnWithTextColorNomal:[UIColor blackColor] withTextColorSelected:[UIColor whiteColor]];
        if (i==0) {
            btn.backgroundColor = Color_38BlueColor;
            btn.selected = YES;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
            btn.selected = NO;
        }
        btn.frame = CGRectMake(16+i*(W_SubBtn+10), 10, W_SubBtn, 30);
        [self addSubview:btn];
    }
}
- (void)subBtnsAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    for (UIButton *btn in self.subviews) {
        if (btn.tag == sender.tag) {
            btn.selected = YES;
            btn.backgroundColor = Color_38BlueColor;
        }else{
            btn.selected = NO;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
    if (_delegage &&  [_delegage respondsToSelector:@selector(headerViewTouchSubBtnWithType:)]) {
        [_delegage headerViewTouchSubBtnWithType:(sender.tag-200)];
    }
}
@end
