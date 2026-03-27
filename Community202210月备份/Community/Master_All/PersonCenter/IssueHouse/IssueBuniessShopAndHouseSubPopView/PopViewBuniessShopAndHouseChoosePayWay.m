//
//  PopViewBuniessShopChoosePayWay.m
//  Community
//
//  Created by 余莹 on 2021/1/21.
//

#import "PopViewBuniessShopAndHouseChoosePayWay.h"
#import "CarTypeChooseBtn.h"

//
#define SubBtn_ViewMaxW (Screen_W-32)/4
#define SubBtn_ViewMaxH 40
#define SubBtn_W  80
#define SubBtn_H  30

//
#define SubBtn_Tag 500

@interface PopViewBuniessShopAndHouseChoosePayWay ()
@property (nonatomic,strong) NSMutableArray *payWayArr;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *okBtn;
@property (nonatomic,strong) UIView *subItemBackView;
@property (nonatomic,strong) PopViewBuniessShopAndHouseChoosePayWayModel *model;
@end
@implementation PopViewBuniessShopAndHouseChoosePayWay

#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubAllView];
        [self setUI];
    }
    return self;
}
- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr{
    _payWayArr = [NSMutableArray arrayWithArray:[PopViewBuniessShopAndHouseChoosePayWayModel mj_objectArrayWithKeyValuesArray:dataSourceArr]];
    [self.subItemBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setRelationItem];
}

#pragma mark == btn action
- (void)subBtnAction:(CarTypeChooseBtn *)sender{

    if (sender.selected==YES) {
        return;
    }
    [self changSubBtnUI:sender];
    self.model = _payWayArr[sender.tag-SubBtn_Tag];
    NSLog(@"subBtnAction---%@",self.model.houseConstName);
//    [self dismissThePopView];
}
- (void)changSubBtnUI:(CarTypeChooseBtn *)sender{
    sender.selected = !sender.selected;
    for (int i = 0 ; i < self.subItemBackView.subviews.count; i++) {
        if ([self.subItemBackView.subviews[i] isKindOfClass:[CarTypeChooseBtn class]]) {
            CarTypeChooseBtn *btn = (CarTypeChooseBtn*)self.subItemBackView.subviews[i];
            if (btn.selected==YES && btn.tag != sender.tag) {
                btn.selected = NO;
            }
        }
    }
}
#pragma mark ==  btn item UI
- (void)setRelationItem{
    for (int i = 0; i<_payWayArr.count; i++) {
        PopViewBuniessShopAndHouseChoosePayWayModel  *model = _payWayArr[i];
        CGRect fram = CGRectMake(SubBtn_ViewMaxW*((i)%4) +5 , SubBtn_ViewMaxH*floor((i)/4.0), SubBtn_W, SubBtn_H);
        CarTypeChooseBtn *btn = [[CarTypeChooseBtn alloc]initWithFrame:fram];
        [btn setBackgroundImage:[UIImage imageWithColor:Y_RGBA(245, 245, 245, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:Base_SubView_Use_BlueColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.borderWidth = 0.1;
        //
        btn.tag = i+SubBtn_Tag;
        [btn setTitle:[TextShowWithModelStr textShowWithModelStr:model.houseConstName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.subItemBackView addSubview:btn];
    }
}

#pragma mark == UI
- (void)addSubAllView{
    self.subMainBackView.layer.cornerRadius = 1;
    [self.subMainBackView addSubview:self.titleLabel];
    [self.subMainBackView addSubview:self.subItemBackView];
    [self.subMainBackView addSubview:self.cancelBtn];
    [self.subMainBackView addSubview:self.okBtn];
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(10);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-16);
        make.height.offset(30);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.left.equalTo(_titleLabel.mas_left);
        make.height.offset(40);
        make.width.offset(50);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_centerY);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.offset(40);
        make.width.offset(50);
    }];
    
    [_subItemBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_subItemBackView.superview).insets(UIEdgeInsetsMake(50, 16, 30, 16));//t == 10+30+10
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"请选择押付方式";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIView *)subItemBackView{
    if (!_subItemBackView) {
        _subItemBackView = [[UIView alloc]init];
    }
    return _subItemBackView;
}
// top 1
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
     }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:Base_SubView_Use_BlueColor forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

#pragma mark ==
- (void)cancelBtnAction{
    [self dismissThePopView];
}
- (void)okBtnAction{
    if (_payWayDelegate && [_payWayDelegate respondsToSelector:@selector(popViewChoosePayWayModel:)]) {
        [_payWayDelegate popViewChoosePayWayModel:self.model];
    }
    [self dismissThePopView];
}



#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
    self.subMainViewHeight  = Screen_H*0.3;
}

@end
