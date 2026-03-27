//
//  MyOrderListVcHeaderView.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVcHeaderView.h"
#define  Width_Sub_Btn  (Screen_W/5)

@interface MyOrderListVcHeaderView ()
@property (nonatomic,strong) NSMutableArray *titelArr;
@end

@implementation MyOrderListVcHeaderView
- (void)showListWithType:(MyOrderListCell_Type)showType{
    NSInteger tagIndex = 0;
    switch (showType) {
        case MyOrderListCell_Type_All:
            tagIndex = 0;
            break;
        case MyOrderListCell_Type_WillPay:
            tagIndex = 1;
            break;
        case MyOrderListCell_Type_WillUse:
            tagIndex = 2;
            break;
        case MyOrderListCell_Type_WillEvaluation:
            tagIndex = 3; //MyOrderListCell_Type_EndDeal
            break;
        default:
            tagIndex = 4;
            break;
    }
    [self upSubBtnUIWithBtnTag:(tagIndex+200)];
}
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
        self.backgroundColor = Color_245Gray;
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.titelArr = [[NSMutableArray alloc]initWithObjects:@"全部",@"待付款",@"待使用",@"待评价",@"退款/售后", nil];
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
//    MyOrderListCell_Type_All=1,
//    MyOrderListCell_Type_WillPay=2,
//    MyOrderListCell_Type_PayEnd =3,//3"已付款"
//    MyOrderListCell_Type_WillUse=4,// 4"待使用"
//    MyOrderListCell_Type_WillEvaluation=5,//"待评价5"
//    MyOrderListCell_Type_EndDeal=5,//"待评价5"==已完成5
//    MyOrderListCell_Type_EvaluationEnd =6,//已经评价
//    MyOrderListCell_Type_ReturnCom=7,//退款/售后
    MyOrderListCell_Type typeNum = 0;
//    switch (index) {
//        case 0:
//            typeNum = MyOrderListCell_Type_All;
//            break;
//        case 1:
//            typeNum = MyOrderListCell_Type_WillPay;
//            break;
//        case 2:
//            typeNum = MyOrderListCell_Type_WillUse;
//            break;
//        case 3:
//            typeNum = MyOrderListCell_Type_WillEvaluation;
//            break;
//        case 4:
//            typeNum = MyOrderListCell_Type_EndDeal;
//            break;
//        case 5:
//            typeNum = MyOrderListCell_Type_IsCancel;
//            break;
//
//        default:
//            break;
//    }
    
    switch (index) {
        case 0:
            typeNum = MyOrderListCell_Type_All;
            break;
        case 1:
            typeNum = MyOrderListCell_Type_WillPay;
            break;
        case 2:
            typeNum = MyOrderListCell_Type_WillUse;
            break;
        case 3:
            typeNum = MyOrderListCell_Type_WillEvaluation; //MyOrderListCell_Type_EndDeal
            break;
        case 4:
            typeNum = MyOrderListCell_Type_ReturnCom ;
            break;
        default:

            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(orderHeaderViewTouchUPWithListType:)]) {
        [_delegate orderHeaderViewTouchUPWithListType:typeNum];
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
- (void)upSubBtnUIWithBtnTag:(NSInteger)btnTag{
    
    for (UIButton *btn in self.subviews) {
        if (btn.tag==btnTag) {
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
