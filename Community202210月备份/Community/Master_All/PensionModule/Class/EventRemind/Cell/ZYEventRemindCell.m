//
//  ZYEventRemindCell.m
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import "ZYEventRemindCell.h"

@interface ZYEventRemindCell ()

@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *nameContentView;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) TTGTextTagCollectionView *textTagCollectionView;

@property (nonatomic, strong) NSMutableArray *markTagsArray;

@end

@implementation ZYEventRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    // 拉伸气泡
    UIImage *backImage = [UIImage imageNamed:@"yl_nr"];
    backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 10, 30) resizingMode:UIImageResizingModeStretch];
    self.contentImageView.image = backImage;
    
    [self.nameContentView addSubview:self.textTagCollectionView];
    [_textTagCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_textTagCollectionView.superview);
    }];
}

// 设置数据model
- (void)setModel:(ZYEventRemindModel *)model {
    _model = model;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", _model.warnHour, _model.warnMinute];
    self.contentLabel.text = _model.content;
    if (_model.pushStatus) {
        self.markImageView.image = [UIImage imageNamed:@"yl_shijianwc"];
    }else {
        self.markImageView.image = [UIImage imageNamed:@"yl_shijianmr"];
    }
    
    [self handleNameTagData];
}

// 处理名字标签数据
- (void)handleNameTagData {
    TTGTextTagStringContent *content = [[TTGTextTagStringContent alloc] init];
    content.textFont = [UIFont boldSystemFontOfSize:14];
    content.textColor = [UIColor whiteColor];
    TTGTextTagStyle *style = [[TTGTextTagStyle alloc] init];
    style.backgroundColor = [UIColor zy_colorWithHexString:@"#36C8C1"];
    style.shadowColor = [UIColor clearColor];
    style.borderWidth = 0;
    style.borderColor = [UIColor clearColor];
    style.cornerRadius = 15;
    style.extraSpace = CGSizeMake(20, 0);
    style.exactHeight = 25;
    if (self.markTagsArray.count > 0) {
        [self.markTagsArray removeAllObjects];
    }
    [self.textTagCollectionView removeAllTags];
    [_model.records enumerateObjectsUsingBlock:^(ZYEventRemindRecordsModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        TTGTextTagStringContent *stringContent = [content copy];
        stringContent.text = model.name;
        TTGTextTagStringContent *selectedStringContent = [content copy];
        selectedStringContent.text = model.name;
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = style;
        [self.markTagsArray addObject:tag];
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
        _textTagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 118, 30)];
        _textTagCollectionView.userInteractionEnabled = NO;
        _textTagCollectionView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
        _textTagCollectionView.showsVerticalScrollIndicator = NO;
        _textTagCollectionView.showsHorizontalScrollIndicator = NO;
        _textTagCollectionView.horizontalSpacing = 8;
        _textTagCollectionView.verticalSpacing = 8;
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
