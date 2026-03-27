//
//  ZYLifeCostHelpCenterMenuCell.m
//  Community
//
//  Created by ZY on 2022/1/4.
//

#import "ZYLifeCostHelpCenterMenuCell.h"

@interface ZYLifeCostHelpCenterMenuCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@end

@implementation ZYLifeCostHelpCenterMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentV addSubview:self.textTagCollectionView];
    [_textTagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textTagCollectionView.superview);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (TTGTextTagCollectionView *)textTagCollectionView {
    if (!_textTagCollectionView) {
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 32, 32)];
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.contentInset = UIEdgeInsetsMake(16, 16, 16, 16);
        _textTagCollectionView.horizontalSpacing = 10;
        _textTagCollectionView.verticalSpacing = 10;
    }
    
    return _textTagCollectionView;
}

@end
