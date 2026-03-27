//
//  HouseRentViewHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/29.
//

#import "HouseRentHeaderView.h"
#define TitleBtn_TAG 300
#define TitleBtn_W Screen_W*0.5
#define TitleBtn_H 40
#define TitleBtn_Selected_Color Y_RGBA(38, 114, 249, 1)

@interface HouseRentHeaderView ()
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *bottomLineView;
@end

@implementation HouseRentHeaderView
- (void)setNowBtnSelectedWithType:(MainCellRecommendedServiceHourse_Rent_Type)type{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = type +TitleBtn_TAG;
    [self setOtherBtnSelectedUI:btn];
}
- (instancetype)initWithFrame:(CGRect)frame{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubBtnWithTextNomalColor:[ThemeManager shareManager].mainTextColor ishistroy:NO];
        [self addSubview:self.lineView];
        [self addSubview:self.bottomLineView];
        self.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;//内容底色 浅色为纯白  深色type=则和vc深蓝色相同
    }
    return self;
}
- (void)addSubBtnWithTextNomalColor:(UIColor *)textNomalColor ishistroy:(BOOL)isHistroy{
    self.titleArr = [NSMutableArray arrayWithObjects:@"商铺",@"租房", nil];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //基础信息
        [titleBtn setTitle:_titleArr[idx] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        if (isHistroy) {
            titleBtn.frame = CGRectMake(TitleBtn_W*idx, 0, TitleBtn_W, 50);//等高
        }else{
            titleBtn.frame = CGRectMake(TitleBtn_W*idx, 0, TitleBtn_W, TitleBtn_H);
        }
        titleBtn.tag = TitleBtn_TAG + idx;//商铺0 租房1
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //文本颜色
        [titleBtn setTitleColor:textNomalColor forState:UIControlStateNormal];//
        [titleBtn setTitleColor:TitleBtn_Selected_Color forState:UIControlStateSelected];
        //下图颜色
        if (isHistroy) {
            float w = TitleBtn_W;
//            UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:(w-20) height:3];
//            UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:TitleBtn_Selected_Color] width:(w-20) height:3];
            UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:40 height:3];
            UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:TitleBtn_Selected_Color] width:40 height:3];
            [titleBtn setImage:nomalImg forState:UIControlStateNormal];
            [titleBtn setImage:selectedImg forState:UIControlStateSelected];
            //图上文下
            [titleBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:5];
        }else{
            UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:40 height:3];
            UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:TitleBtn_Selected_Color] width:40 height:3];
            [titleBtn setImage:nomalImg forState:UIControlStateNormal];
            [titleBtn setImage:selectedImg forState:UIControlStateSelected];
            //图上文下
            [titleBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
        }
       
        titleBtn.userInteractionEnabled = YES;
        if (idx==0) {
            titleBtn.selected = YES;
        }else{
            titleBtn.selected = NO;
        }
        [self addSubview:titleBtn];
    }];
}
#pragma mark ==
- (void)titleBtnAction:(UIButton *)sender{
    if (sender.selected==YES) {
        return;
    }
    sender.selected = YES;
    [self setOtherBtnSelectedUI:sender];
    if (_delegate && [_delegate respondsToSelector:@selector(houseRentHeaderViewChooseTypeSubBtnTouchChooseType:)]) {
        [_delegate houseRentHeaderViewChooseTypeSubBtnTouchChooseType:(sender.tag-TitleBtn_TAG)];
    }
}
- (void)setOtherBtnSelectedUI:(UIButton *)sender{
    [self.subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (sender.tag != btn.tag) {
                btn.selected = NO;
            }else{
                btn.selected = YES;
            }
        }
    }];
}
 
#pragma mark ===
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(Screen_W*0.5, TitleBtn_H*0.25, 1, TitleBtn_H*0.5)];
        _lineView.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
    }
    return _lineView;
}
- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1,Screen_W , 1)];
        _bottomLineView.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];
    }
    return _bottomLineView;
}

- (void)changeTextColorWithBlack{
    [self addSubBtnWithTextNomalColor:[UIColor blackColor] ishistroy:YES];
    [self addSubview:self.lineView];
    [self addSubview:self.bottomLineView];
    self.lineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.bottomLineView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

@end
