//
//  IssueHouseAppointmentManagerHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import "IssueHouseAppointmentManagerHeaderView.h"

#define  Width_Sub_Btn  (Screen_W/5)


@interface IssueHouseAppointmentManagerHeaderView ()
@property (nonatomic,strong) NSMutableArray *titelArr;
@end

@implementation IssueHouseAppointmentManagerHeaderView

 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 60);
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:self.allBtn];
//        [self addSubview:self.willPayBtn];
//        [self addSubview:self.willUseBtn];
//        [self addSubview:self.willEvaluationBtn];
//        [self addSubview:self.endDealBtn];
//        self.backgroundColor = Color_245Gray;
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.titelArr = [[NSMutableArray alloc]initWithObjects:@"全部",@"待处理",@"待看房",@"已取消",@"已完成", nil];
    for (int i = 0; i < self.titelArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn newAnBtnWithTextColor:[UIColor blackColor]];
        [btn newAnBtnWithTextStr:self.titelArr[i]];
     
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
        if (i==0) {
            [btn newAnBtnWithFont:FontSize_Orders_Bold(14)];
            btn.selected = YES;
        }else{
            [btn newAnBtnWithFont:FontSize_Orders_Nomail(14)];
            btn.selected = NO;
        }
        //
        [btn setFrame:CGRectMake(Width_Sub_Btn*i, 0, Width_Sub_Btn, 60)];
        [self addSubview:btn];
    }
}
- (void)btnAction:(UIButton *)sender{
    NSInteger index = sender.tag-200;
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerViewChooseType:)]) {
        [_delegate headerViewChooseType:index];
    }
    [self upSubBtnUIWithBtn:sender];
}
- (void)upSubBtnUIWithBtn:(UIButton *)sender{
    
    if (sender.selected==YES) {
        return;
    }
    for (UIButton *btn in self.subviews) {
        if (btn.tag==sender.tag) {
            [btn newAnBtnWithFont:FontSize_Orders_Bold(14)];
            btn.selected=YES;
            //img
        }else{
            [btn newAnBtnWithFont:FontSize_Orders_Nomail(14)];
            btn.selected=NO;
            //img
        }
    }
}
@end
