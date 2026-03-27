//
//  ZYLandlordPendingListCell.m
//  Community
//
//  Created by ZY on 2021/9/10.
//

#import "ZYLandlordPendingListCell.h"

@interface ZYLandlordPendingListCell ()

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *houseImageView;

@property (weak, nonatomic) IBOutlet UILabel *houseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIView *markContentView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (nonatomic, strong) TTGTextTagCollectionView *textTagCollectionView;

@property (nonatomic, strong) NSMutableArray *markTagsArray;

@end

@implementation ZYLandlordPendingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.nameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.houseNameLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.descLabel.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    
    [self.iconImageView zy_cornerRadiusAdvance:16 rectCornerType:UIRectCornerAllCorners];
    [self.houseImageView zy_cornerRadiusAdvance:2.5 rectCornerType:UIRectCornerAllCorners];
    
    [self.markContentView addSubview:self.textTagCollectionView];
    [_textTagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textTagCollectionView.superview);
    }];
}

// 设置数据model
- (void)setModel:(ZYLandlordPendingListDataModel *)model {
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatarUrl] placeholderImage:[UIImage imageNamed:@"My_headportrait"]];
    self.nameLabel.text = _model.realName;
    [self.houseImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"Products_default"]];
    self.houseNameLabel.text = _model.title;
    self.descLabel.text = [NSString stringWithFormat:@"%@，朝%@", _model.houseType, _model.directionId];
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@", [NSNumber numberWithDouble:_model.price]];
    
    TTGTextTagStringContent *content = [[TTGTextTagStringContent alloc] init];
    content.textFont = [UIFont systemFontOfSize:11];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        content.textColor = [UIColor zy_colorWithHexString:@"#2672F9"];
    }else {
        content.textColor = [UIColor whiteColor];
    }
    TTGTextTagStyle *style = [[TTGTextTagStyle alloc] init];
    style.backgroundColor = [UIColor clearColor];
    style.shadowColor = [UIColor clearColor];
    style.borderWidth = 0.5;
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        style.borderColor = [UIColor zy_colorWithHexString:@"#247CFA"];
    }else {
        style.borderColor = [UIColor zy_colorWithHexString:@"#C5C9D4"];
    }
    style.cornerRadius = 3;
    style.extraSpace = CGSizeMake(8, 0);
    style.exactHeight = 16;
    
    if (self.markTagsArray.count > 0) {
        [self.markTagsArray removeAllObjects];
    }
    [self.textTagCollectionView removeAllTags];
//    for (NSString *key in _model.houseAdvantageCode.allKeys) {
//        TTGTextTagStringContent *stringContent = [content copy];
//        stringContent.text = key;
//        TTGTextTagStringContent *selectedStringContent = [content copy];
//        selectedStringContent.text = key;
//        TTGTextTag *tag = [[TTGTextTag alloc] init];
//        tag.content = stringContent;
//        tag.selectedContent = selectedStringContent;
//        tag.style = style;
//        [self.markTagsArray addObject:tag];
//    }
    [_model.houseAdvantageCode.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 3) {
            TTGTextTagStringContent *stringContent = [content copy];
            stringContent.text = key;
            TTGTextTagStringContent *selectedStringContent = [content copy];
            selectedStringContent.text = key;
            TTGTextTag *tag = [[TTGTextTag alloc] init];
            tag.content = stringContent;
            tag.selectedContent = selectedStringContent;
            tag.style = style;
            [self.markTagsArray addObject:tag];
        }
    }];
    [self.textTagCollectionView addTags:self.markTagsArray];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (TTGTextTagCollectionView *)textTagCollectionView {
    if (!_textTagCollectionView) {
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 216, 19)];
        _textTagCollectionView.scrollView.bounces = NO;
        _textTagCollectionView.scrollView.scrollEnabled = NO;
        _textTagCollectionView.userInteractionEnabled = NO;
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.horizontalSpacing = 4;
        _textTagCollectionView.verticalSpacing = 4;
    }
    
    return _textTagCollectionView;
}

- (NSMutableArray *)markTagsArray {
    if (!_markTagsArray) {
        _markTagsArray = [NSMutableArray array];
    }
    
    return _markTagsArray;
}

@end
