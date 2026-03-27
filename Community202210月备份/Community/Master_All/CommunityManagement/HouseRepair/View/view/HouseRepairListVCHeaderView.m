//
//  HouseRepairListVCHeaderView.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//
#define TitleBtn_W Screen_W/5
#define TitleBtn_H 40
#define TitleBtn_TAG  400
#define TitleBtn_Selected_Color Y_RGBA(38, 114, 249, 1)
#import "HouseRepairListVCHeaderView.h"
@interface HouseRepairListVCHeaderView ()
@property (nonatomic,strong) NSArray *titleArr;
@end

@implementation HouseRepairListVCHeaderView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    frame = CGRectMake(0, 0, Screen_W, 50);
    self = [super initWithFrame:frame];
    if (self) {
        [self addSub];
    }
    return self;
}
 
- (void)addSub{
    self.titleArr = [NSArray arrayWithObjects:@"全部",@"待处理",@"处理中",@"已完成",@"已驳回", nil];
    [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //基础信息
        [titleBtn setTitle:_titleArr[idx] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleBtn.frame = CGRectMake(TitleBtn_W*idx, 0, TitleBtn_W, TitleBtn_H);
        titleBtn.tag = TitleBtn_TAG + idx;
        [titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //文本颜色
        [titleBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:TitleBtn_Selected_Color forState:UIControlStateSelected];
        //下图颜色
        UIImage *nomalImg = [ImgSetSize setimageSize:[UIImage imageWithColor:[UIColor clearColor]] width:40 height:3];
        UIImage *selectedImg = [ImgSetSize setimageSize:[UIImage imageWithColor:TitleBtn_Selected_Color] width:40 height:3];
        [titleBtn setImage:nomalImg forState:UIControlStateNormal];
        [titleBtn setImage:selectedImg forState:UIControlStateSelected];
        //图上文下
        [titleBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleBottom imageTitleSpace:10];
 
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
    [self setAllBtnSelectedUI:sender];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseHouseRepairListType:)]) {
        [_delegate chooseHouseRepairListType:(sender.tag-TitleBtn_TAG)];
    }
}
- (void)setAllBtnSelectedUI:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        if (sender.tag != btn.tag) {
            btn.selected = NO;
        }
    }];
    NSLog(@"%@",sender.subviews);
}
 

- (void)chooseHouseRepairListType:(HouseRepair_List_DealType)type{
    
}
@end
