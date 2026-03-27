//
//  ZYCommunityFairComprehensiveSearchView.m
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import "ZYCommunityFairComprehensiveSearchView.h"

@interface ZYCommunityFairComprehensiveSearchView ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ZYCommunityFairComprehensiveSearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    [self cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, 45) radius:15 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.filtrateButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    self.lineView.backgroundColor = [ZYThemeManager shareManager].borderThemeColor;
    [self.compositeButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.regionButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.filtrateButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:6];
    [self.compositeButton addTarget:self action:@selector(compositeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.regionButton addTarget:self action:@selector(regionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.filtrateButton addTarget:self action:@selector(filtrateButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 处理点击事件
// 综合选择
- (void)compositeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(compositeButtonEvent)]) {
        [self.delegate compositeButtonEvent];
    }
}

// 区域选择
- (void)regionButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(regionButtonEvent)]) {
        [self.delegate regionButtonEvent];
    }
}

// 筛选
- (void)filtrateButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(filtrateButtonEvent)]) {
        [self.delegate filtrateButtonEvent];
    }
}

@end
