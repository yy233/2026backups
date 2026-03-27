//
//  ZYCommunityFairComprehensiveSearchFiltratePopView.m
//  Community
//
//  Created by ZY on 2022/6/11.
//

#import "ZYCommunityFairComprehensiveSearchFiltratePopView.h"
#import "ZYCommunityFairComprehensiveSearchFiltratePopViewCell.h"
#import "ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell.h"

static CGFloat popViewDuration = 0.25;
static NSString * const ZYCommunityFairComprehensiveSearchFiltratePopViewCellID = @"ZYCommunityFairComprehensiveSearchFiltratePopViewCell";
static NSString * const ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellID = @"ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell";
#define kZYCommunityFairComprehensiveSearchFiltratePopViewCellHeight 40
#define kZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellHeight 85

@interface ZYCommunityFairComprehensiveSearchFiltratePopView () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (nonatomic, strong) NSMutableArray *titleArray;

// ---全部分类---
@property (nonatomic, assign) CGFloat textTagCollectionViewAllHeight;

@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic, strong) NSMutableArray *allTagArray;

@property (nonatomic, strong) NSMutableArray *allTagTempArray;

@property (nonatomic, assign) NSInteger allSelectedIndex;

@property (nonatomic, assign) CGFloat allTextTagCollectionViewHeight;

// ---商品成色---
@property (nonatomic, assign) CGFloat textTagCollectionViewShopHeight;

@property (nonatomic, strong) NSMutableArray *shopArray;

@property (nonatomic, strong) NSMutableArray *shopTagArray;

@property (nonatomic, strong) NSMutableArray *shopTagTempArray;

@property (nonatomic, assign) NSInteger shopSelectedIndex;

@property (nonatomic, assign) CGFloat shopTextTagCollectionViewHeight;

// ---发布时间---
@property (nonatomic, assign) CGFloat textTagCollectionViewTimeHeight;

@property (nonatomic, strong) NSMutableArray *timeArray;

@property (nonatomic, strong) NSMutableArray *timeTagArray;

@property (nonatomic, strong) NSMutableArray *timeTagTempArray;

@property (nonatomic, assign) NSInteger timeSelectedIndex;

@property (nonatomic, assign) CGFloat timeTextTagCollectionViewHeight;

// ---按距离---
@property (nonatomic, assign) CGFloat textTagCollectionViewDistanceHeight;

@property (nonatomic, strong) NSMutableArray *distanceArray;

@property (nonatomic, strong) NSMutableArray *distanceTagArray;

@property (nonatomic, strong) NSMutableArray *distanceTagTempArray;

@property (nonatomic, assign) NSInteger distanceSelectedIndex;

@property (nonatomic, assign) CGFloat distanceTextTagCollectionViewHeight;

// 标签相关配置
@property (nonatomic, strong) TTGTextTagStringContent *content;

@property (nonatomic, strong) TTGTextTagStringContent *selectedContent;

@property (nonatomic, strong) TTGTextTagStyle *style;

@property (nonatomic, strong) TTGTextTagStyle *selectedStyle;

@end

@implementation ZYCommunityFairComprehensiveSearchFiltratePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTap)]];
    [self.subContentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subContentViewTap)]];
    self.contentViewHeightConstraint.constant = 567 + button_bottom_height;
    self.bottomViewHeightConstraint.constant = 85 + button_bottom_height;
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, 567) radius:15 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.contentV.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.closeButton setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_close_pay"] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[ZYThemeManager shareManager].titleThemeColor forState:UIControlStateNormal];
    self.resetButton.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton addTarget:self action:@selector(resetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self customTableView];
    [self initData];
}

#pragma mark - 懒加载
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    
    return _titleArray;
}

- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    
    return _allArray;
}

- (NSMutableArray *)allTagArray {
    if (!_allTagArray) {
        _allTagArray = [NSMutableArray array];
    }
    
    return _allTagArray;
}

- (NSMutableArray *)allTagTempArray {
    if (!_allTagTempArray) {
        _allTagTempArray = [NSMutableArray array];
    }
    
    return _allTagTempArray;
}

- (NSMutableArray *)shopArray {
    if (!_shopArray) {
        _shopArray = [NSMutableArray array];
    }
    
    return _shopArray;
}

- (NSMutableArray *)shopTagArray {
    if (!_shopTagArray) {
        _shopTagArray = [NSMutableArray array];
    }
    
    return _shopTagArray;
}

- (NSMutableArray *)shopTagTempArray {
    if (!_shopTagTempArray) {
        _shopTagTempArray = [NSMutableArray array];
    }
    
    return _shopTagTempArray;
}

- (NSMutableArray *)timeArray {
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    
    return _timeArray;
}

- (NSMutableArray *)timeTagArray {
    if (!_timeTagArray) {
        _timeTagArray = [NSMutableArray array];
    }
    
    return _timeTagArray;
}

- (NSMutableArray *)timeTagTempArray {
    if (!_timeTagTempArray) {
        _timeTagTempArray = [NSMutableArray array];
    }
    
    return _timeTagTempArray;
}

- (NSMutableArray *)distanceArray {
    if (!_distanceArray) {
        _distanceArray = [NSMutableArray array];
    }
    
    return _distanceArray;
}

- (NSMutableArray *)distanceTagArray {
    if (!_distanceTagArray) {
        _distanceTagArray = [NSMutableArray array];
    }
    
    return _distanceTagArray;
}

- (NSMutableArray *)distanceTagTempArray {
    if (!_distanceTagTempArray) {
        _distanceTagTempArray = [NSMutableArray array];
    }
    
    return _distanceTagTempArray;
}

- (TTGTextTagStringContent *)content {
    if (!_content) {
        _content = [[TTGTextTagStringContent alloc] init];
        _content.textFont = [UIFont systemFontOfSize:13];
        _content.textColor = [ZYThemeManager shareManager].titleThemeColor;
    }
    
    return _content;
}

- (TTGTextTagStringContent *)selectedContent {
    if (!_selectedContent) {
        _selectedContent = [[TTGTextTagStringContent alloc] init];
        _selectedContent.textFont = [UIFont systemFontOfSize:13];
        _selectedContent.textColor = [UIColor whiteColor];
    }
    
    return _selectedContent;
}

- (TTGTextTagStyle *)style {
    if (!_style) {
        _style = [[TTGTextTagStyle alloc] init];
        _style.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_Lf0f1f6;
        _style.shadowColor = [UIColor clearColor];
        _style.borderWidth = 0;
        _style.borderColor = [UIColor clearColor];
        _style.cornerRadius = 18;
        _style.extraSpace = CGSizeMake(30, 0);
        _style.exactHeight = 35;
        _style.maxWidth = 150;
    }
    
    return _style;
}

- (TTGTextTagStyle *)selectedStyle {
    if (!_selectedStyle) {
        _selectedStyle = [[TTGTextTagStyle alloc] init];
        _selectedStyle.backgroundColor = Y_RGBA(38, 114, 249, 1);
        _selectedStyle.shadowColor = [UIColor clearColor];
        _selectedStyle.borderWidth = 0;
        _selectedStyle.borderColor = [UIColor clearColor];
        _selectedStyle.cornerRadius = 18;
        _selectedStyle.extraSpace = CGSizeMake(30, 0);
        _selectedStyle.exactHeight = 35;
        _style.maxWidth = 150;
    }
    
    return _selectedStyle;
}

#pragma mark - 加载数据
- (void)initData {
    [self.titleArray addObjectsFromArray:@[@"全部分类", @"商品成色", @"发布时间", @"按距离", @"价格范围（元）"]];
    
    [self.allArray addObjectsFromArray:@[@"服饰", @"玩具", @"运动装", @"男装", @"女装", @"数码"]];
    for (int i = 0; i < self.allArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.allArray[i];
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = self.allArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.allTagArray addObject:tag];
        [self.allTagTempArray addObject:tag];
    }
    
    [self.shopArray addObjectsFromArray:@[@"全新", @"几乎全新", @"轻微使用痕迹", @"明显使用痕迹"]];
    for (int i = 0; i < self.shopArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.shopArray[i];
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = self.shopArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.shopTagArray addObject:tag];
        [self.shopTagTempArray addObject:tag];
    }
    
    [self.timeArray addObjectsFromArray:@[@"1天内", @"7天内", @"30天内"]];
    for (int i = 0; i < self.timeArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.timeArray[i];
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = self.timeArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.timeTagArray addObject:tag];
        [self.timeTagTempArray addObject:tag];
    }
    
    [self.distanceArray addObjectsFromArray:@[@"1KM", @"5KM", @"10KM", @"同城", @"不限"]];
    for (int i = 0; i < self.shopArray.count; i++) {
        TTGTextTagStringContent *stringContent = [self.content copy];
        stringContent.text = self.distanceArray[i];
        TTGTextTagStringContent *selectedStringContent = [self.selectedContent copy];
        selectedStringContent.text = self.distanceArray[i];
        TTGTextTag *tag = [[TTGTextTag alloc] init];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = self.style;
        tag.selectedStyle = self.selectedStyle;
        [self.distanceTagArray addObject:tag];
        [self.distanceTagTempArray addObject:tag];
    }
    
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairComprehensiveSearchFiltratePopViewCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairComprehensiveSearchFiltratePopViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titleArray.count - 1) {
        ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellID forIndexPath:indexPath];
        cell.minTF.tag = 200;
        cell.minTF.delegate = self;
        cell.maxTF.tag = 300;
        cell.maxTF.delegate = self;
        
        return cell;
    }
    ZYCommunityFairComprehensiveSearchFiltratePopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairComprehensiveSearchFiltratePopViewCellID forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.textTagCollectionView.tag = 500 + indexPath.row;
    cell.textTagCollectionView.delegate = self;
    if (indexPath.row == 0) {
        if (self.allTagTempArray.count > 0) {
            [cell.textTagCollectionView addTags:self.allTagArray];
            self.allTextTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.allTagTempArray removeAllObjects];
        }
    }else if (indexPath.row == 1) {
        if (self.shopTagTempArray.count > 0) {
            [cell.textTagCollectionView addTags:self.shopTagArray];
            self.shopTextTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.shopTagTempArray removeAllObjects];
        }
    }else if (indexPath.row == 2) {
        if (self.timeTagTempArray.count > 0) {
            [cell.textTagCollectionView addTags:self.timeTagArray];
            self.timeTextTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.timeTagTempArray removeAllObjects];
        }
    }else if (indexPath.row == 3) {
        if (self.distanceTagTempArray.count > 0) {
            [cell.textTagCollectionView addTags:self.distanceTagArray];
            self.distanceTextTagCollectionViewHeight = cell.textTagCollectionView.contentSize.height;
            [self.distanceTagTempArray removeAllObjects];
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return kZYCommunityFairComprehensiveSearchFiltratePopViewCellHeight + self.allTextTagCollectionViewHeight;
    }else if (indexPath.row == 1) {
        
        return kZYCommunityFairComprehensiveSearchFiltratePopViewCellHeight + self.shopTextTagCollectionViewHeight;
    }else if (indexPath.row == 2) {
        
        return kZYCommunityFairComprehensiveSearchFiltratePopViewCellHeight + self.timeTextTagCollectionViewHeight;
    }else if (indexPath.row == 3) {
        
        return kZYCommunityFairComprehensiveSearchFiltratePopViewCellHeight + self.distanceTextTagCollectionViewHeight;
    }else {
        
        return kZYCommunityFairComprehensiveSearchFiltratePopViewPriceCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.tag == 200) {
        
    }else if (textField.tag == 300) {
        
    }
}

#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    if (textTagCollectionView.tag == 500) {
        ZYCommunityFairComprehensiveSearchFiltratePopViewCell *cell = (ZYCommunityFairComprehensiveSearchFiltratePopViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.allSelectedIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.allSelectedIndex = index;
    }else if (textTagCollectionView.tag == 501) {
        ZYCommunityFairComprehensiveSearchFiltratePopViewCell *cell = (ZYCommunityFairComprehensiveSearchFiltratePopViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.shopSelectedIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.shopSelectedIndex = index;
    }else if (textTagCollectionView.tag == 502) {
        ZYCommunityFairComprehensiveSearchFiltratePopViewCell *cell = (ZYCommunityFairComprehensiveSearchFiltratePopViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.timeSelectedIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.timeSelectedIndex = index;
    }else if (textTagCollectionView.tag == 503) {
        ZYCommunityFairComprehensiveSearchFiltratePopViewCell *cell = (ZYCommunityFairComprehensiveSearchFiltratePopViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.textTagCollectionView updateTagAtIndex:self.distanceSelectedIndex selected:NO];
        [cell.textTagCollectionView updateTagAtIndex:index selected:YES];
        self.distanceSelectedIndex = index;
    }
}

#pragma mark - 处理点击事件
- (void)closeButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeButtonEvent)]) {
        [self.delegate closeButtonEvent];
    }
}

- (void)resetButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetButtonEvent)]) {
        [self.delegate resetButtonEvent];
    }
}

- (void)okButtonClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(okButtonEvent)]) {
        [self.delegate okButtonEvent];
    }
}

- (void)popViewTap {
    [self hiddenCommunityFairComprehensiveSearchFiltratePopView];
}

- (void)subContentViewTap {
}

#pragma mark - 显示视图
- (void)showCommunityFairComprehensiveSearchFiltratePopView {
    UIWindow *window = [Tool toolGetKeyWindow];
    UIView *supView = window.rootViewController.view;
    if (!supView) {
        return;
    }
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [supView addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 1.0;
    }];
}

#pragma mark - 隐藏视图
- (void)hiddenCommunityFairComprehensiveSearchFiltratePopView {
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
