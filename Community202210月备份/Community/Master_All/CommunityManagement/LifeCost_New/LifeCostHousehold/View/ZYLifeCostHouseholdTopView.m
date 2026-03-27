//
//  ZYLifeCostHouseholdTopView.m
//  Community
//
//  Created by ZY on 2022/1/6.
//

#import "ZYLifeCostHouseholdTopView.h"

@implementation ZYLifeCostHouseholdTopView

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
    [self addSubview:self.textTagCollectionView];
    [_textTagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textTagCollectionView.superview);
    }];
}

#pragma mark - 懒加载
- (TTGTextTagCollectionView *)textTagCollectionView {
    if (!_textTagCollectionView) {
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 32, 32)];
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.contentInset = UIEdgeInsetsMake(10, 32, 10, 32);
        _textTagCollectionView.horizontalSpacing = 15;
        _textTagCollectionView.verticalSpacing = 15;
    }
    
    return _textTagCollectionView;
}

@end
