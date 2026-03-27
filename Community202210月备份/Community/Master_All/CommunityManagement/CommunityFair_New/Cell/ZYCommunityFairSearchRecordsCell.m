//
//  ZYCommunityFairSearchRecordsCell.m
//  Community
//
//  Created by ZY on 2022/6/9.
//

#import "ZYCommunityFairSearchRecordsCell.h"

@interface ZYCommunityFairSearchRecordsCell ()

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@end

@implementation ZYCommunityFairSearchRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    [self.subContentV addSubview:self.textTagCollectionView];
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
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 32, 35)];
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.horizontalSpacing = 10;
        _textTagCollectionView.verticalSpacing = 10;
    }
    
    return _textTagCollectionView;
}

@end
