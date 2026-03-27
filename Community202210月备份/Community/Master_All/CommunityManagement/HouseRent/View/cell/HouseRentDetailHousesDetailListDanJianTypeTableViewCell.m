//
//  HouseRentDetailHousesDetailListDanJianTypeTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/10/16.
// 单间类型 房屋介绍数据 繁复UI

#import "HouseRentDetailHousesDetailListDanJianTypeTableViewCell.h"

@interface HouseRentDetailHousesDetailListDanJianTypeTableViewCell ()

@property (nonatomic,strong) UIView *oneDetailListOnlyRightShwoBackView;
@property (nonatomic,strong) UIView *twoDetailListOnlyRightShwoBackView;
//
@property (nonatomic,strong) UIView *oneShowBtnBackV;
@property (nonatomic,strong) UIView *twoShowBtnBackV;
@property (nonatomic,strong) UIButton *oneShowBtn;
@property (nonatomic,strong) UIButton *twoShowBtn;
//
@property (nonatomic,strong) UIView *oneShowListBackV;
@property (nonatomic,strong) UIView *twoShowListBackV;


@end
@implementation HouseRentDetailHousesDetailListDanJianTypeTableViewCell

- (void)notZhengZuDetailListBackViewAddSubBtn{
    //用于子类重写 self.detailListBackView 定top位置
    
    [self.contentView addSubview:self.oneDetailListOnlyRightShwoBackView];
    [self.contentView addSubview:self.twoDetailListOnlyRightShwoBackView];
    //
    [self.oneDetailListOnlyRightShwoBackView addSubview:self.oneShowBtnBackV];
    [self.twoDetailListOnlyRightShwoBackView addSubview:self.twoShowBtnBackV];
    [self.oneShowBtnBackV addSubview:self.oneShowBtn];
    [self.twoShowBtnBackV addSubview:self.twoShowBtn];
    
    //
    [self.oneDetailListOnlyRightShwoBackView addSubview:self.oneShowListBackV];
    [self.twoDetailListOnlyRightShwoBackView addSubview:self.twoShowListBackV];
    //
    [self setNotZhengZuListUI];
    
    NSArray *oneArr = [self.model.commonFacilitiesCode allKeys];
    [self subViewAddOneTagArr:oneArr];
    NSArray *twoArr = [self.model.roomFacilitiesCode allKeys];
    [self subViewAddTwoTagArr:twoArr];
    //
    self.detailListBackView.hidden = YES;
}
- (void)setNotZhengZuListUI{
    WEAKSELF
    [_oneDetailListOnlyRightShwoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.houseIntroduceLabel.mas_bottom);
        make.left.equalTo(_oneDetailListOnlyRightShwoBackView.superview.mas_left).offset(16);
        make.right.equalTo(_oneDetailListOnlyRightShwoBackView.superview.mas_right).offset(-16);
        make.height.offset(40);
    }];
    [_twoDetailListOnlyRightShwoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_oneDetailListOnlyRightShwoBackView);
        make.top.equalTo(_oneDetailListOnlyRightShwoBackView.mas_bottom);
        make.bottom.equalTo(weakSelf.contentView.mas_bottom);
        make.height.offset(40);
    }];
    //
    CGFloat showBtnW = (Screen_W-40)/4;
    [_oneShowBtnBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_oneShowBtnBackV.superview);
        make.width.offset(showBtnW);
    }];
    [_twoShowBtnBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_twoShowBtnBackV.superview);
        make.width.offset(showBtnW);
    }];
    [_oneShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.width.equalTo(_oneShowBtn.superview);
    }];
    [_twoShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.width.equalTo(_twoShowBtn.superview);
    }];
    //
    [_oneShowListBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oneShowBtnBackV.mas_right);
        make.right.bottom.equalTo(_oneShowListBackV.superview);
        make.top.equalTo(_oneShowListBackV.superview).offset(5);
    }];
    [_twoShowListBackV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_twoShowBtnBackV.mas_right);
        make.right.bottom.equalTo(_twoShowListBackV.superview);
        make.top.equalTo(_twoShowListBackV.superview).offset(5);
    }];
}

#pragma mark ===

- (void)subViewAddOneTagArr:(NSArray *)showArr{ 
    CGFloat listViewH = [self.model getNotZhengZuIntroduceHeightOneTagsHeight];
    [_oneDetailListOnlyRightShwoBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(listViewH);
    }];
    float btn_W = (Screen_W-32)/4;
    float btn_h = 20;
    float btn_jiancha = 10;//高度
    [self.oneShowListBackV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 1; i < showArr.count+1; i ++) {
        UIButton *btn = [self baseBtnWithText:[TextShowWithModelStr textShowWithModelStr:showArr[i-1]]];
        //btn.frame = CGRectMake(((i-1)%4)*btn_W ,(i-1)/4*(btn_h+btn_jiancha), btn_W,btn_h);
        btn.frame = CGRectMake(((i-1)%3)*btn_W ,(i-1)/3*(btn_h+btn_jiancha), btn_W,btn_h);
        [self.oneShowListBackV addSubview:btn];
    }
    /**
     for (int i = 0; i <_oneDetailListOnlyRightShwoBackView.subviews.count; i++) {
         if ([_oneDetailListOnlyRightShwoBackView.subviews[i] isKindOfClass:[UIButton class]]) {//设施图文
             //不做处理
         }else{
             //list父v oneShowListBackV
             UIView *listFasterView = (UIView *)_oneDetailListOnlyRightShwoBackView.subviews[i];
             [listFasterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
             
         }
     }
     */
    
}

- (void)subViewAddTwoTagArr:(NSArray *)showArr{
    CGFloat listViewH = [self.model getNotZhengZuIntroduceHeightTwoTagsHeight];
    [_twoDetailListOnlyRightShwoBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(listViewH);
    }];
    [self.twoShowListBackV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float btn_W = (Screen_W-32)/4;
    float btn_h = 20;
    float btn_jiancha = 10;//高度
    for (int i = 1; i < showArr.count+1; i ++) {
        UIButton *btn = [self baseBtnWithText:[TextShowWithModelStr textShowWithModelStr:showArr[i-1]]];
//        btn.frame = CGRectMake(((i-1)%4)*btn_W ,(i-1)/4*(btn_h+btn_jiancha), btn_W,btn_h);
        btn.frame = CGRectMake(((i-1)%3)*btn_W ,(i-1)/3*(btn_h+btn_jiancha), btn_W,btn_h);
        [self.twoShowListBackV addSubview:btn];
    }
    
    /**
     for (int i = 0; i <_twoDetailListOnlyRightShwoBackView.subviews.count; i++) {
         if ([_twoDetailListOnlyRightShwoBackView.subviews[i] isKindOfClass:[UIButton class]]) {
             //不做处理
         }else{
             //list父v twoShowListBackV
             UIView *listFasterView = (UIView *)_twoDetailListOnlyRightShwoBackView.subviews[i];
             [listFasterView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
         }
     }*/
}
- (void)detailListBackViewAddSubBtn:(NSArray *)showArr{
    float btn_W = (Screen_W-32)/4;
    float btn_h = 20;
    float btn_jiancha = 10;//高度
    for (int i = 1; i < showArr.count+1; i ++) {
        UIButton *btn = [self baseBtnWithText:[TextShowWithModelStr textShowWithModelStr:showArr[i-1]]];
        if (i%3==1) {//下一行
            CGFloat y = 0;
        }else{//本行
            CGFloat y = 0;
        }
        btn.frame = CGRectMake(((i-1)%4)*btn_W ,(i-1)/4*(btn_h+btn_jiancha), btn_W,btn_h);
        [self.twoDetailListOnlyRightShwoBackView addSubview:btn];
    }
}
#pragma mark ===


- (UIView *)oneDetailListOnlyRightShwoBackView{
    if (!_oneDetailListOnlyRightShwoBackView) {
        _oneDetailListOnlyRightShwoBackView = [[UIView alloc]init];
    }
    return _oneDetailListOnlyRightShwoBackView;
}

- (UIView *)twoDetailListOnlyRightShwoBackView{
    if (!_twoDetailListOnlyRightShwoBackView) {
        _twoDetailListOnlyRightShwoBackView = [[UIView alloc]init];
    }
    return _twoDetailListOnlyRightShwoBackView;
}

#pragma mark ===

- (UIView *)oneShowListBackV{
    if (!_oneShowListBackV) {
        _oneShowListBackV = [[UIView alloc]init];
    }
    return _oneShowListBackV;
}
- (UIView *)twoShowListBackV{
    if (!_twoShowListBackV) {
        _twoShowListBackV = [[UIView alloc]init];
    }
    return _twoShowListBackV;
}

#pragma mark ===

- (UIView *)oneShowBtnBackV{
    if (!_oneShowBtnBackV) {
        _oneShowBtnBackV = [[UIView alloc]init];
    }
    return _oneShowBtnBackV;
}
- (UIView *)twoShowBtnBackV{
    if (!_twoShowBtnBackV) {
        _twoShowBtnBackV = [[UIView alloc]init];
    }
    return _twoShowBtnBackV;
}
/**
 houseRent_public_icon_WhiteColor
 houseRentPublicIcon

 bedroom
 houseRentPublicIcon_house
 */

- (UIButton *)oneShowBtn{
    if (!_oneShowBtn) {
        _oneShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneShowBtn newAnBtnWithTextStr:@"公共设施"];
        [_oneShowBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_oneShowBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_oneShowBtn newAnBtnWithImg:[UIImage imageNamed:@"houseRentPublicIcon"]];
        }else{
            [_oneShowBtn newAnBtnWithImg:[UIImage imageNamed:@"houseRent_public_icon_WhiteColor"]];
        }
        [_oneShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    }
    return _oneShowBtn;
}
- (UIButton *)twoShowBtn{
    if (!_twoShowBtn) {
        _twoShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twoShowBtn newAnBtnWithTextStr:@"房间设施"];
        [_twoShowBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_twoShowBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_twoShowBtn newAnBtnWithImg:[UIImage imageNamed:@"houseRentPublicIcon_house"]];
        }else{
            [_twoShowBtn newAnBtnWithImg:[UIImage imageNamed:@"bedroom"]];
        }
        [_twoShowBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:3];
    }
    return _twoShowBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
