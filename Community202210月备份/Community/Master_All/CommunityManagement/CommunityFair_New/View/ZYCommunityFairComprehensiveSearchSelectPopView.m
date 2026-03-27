//
//  ZYCommunityFairComprehensiveSearchSelectPopView.m
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import "ZYCommunityFairComprehensiveSearchSelectPopView.h"
#import "ZYCommunityFairComprehensiveSearchSelectPopCell.h"

static CGFloat popViewDuration = 0.25;
static NSString * const ZYCommunityFairComprehensiveSearchSelectPopCellID = @"ZYCommunityFairComprehensiveSearchSelectPopCell";
#define kZYCommunityFairComprehensiveSearchSelectPopCellHeight 50

@interface ZYCommunityFairComprehensiveSearchSelectPopView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *subContentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZYCommunityFairComprehensiveSearchSelectPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.subContentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.topLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.bottomLineView.backgroundColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap)]];
    
    [self customTableView];
}

// 设置数据
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = _title;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairComprehensiveSearchSelectPopCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairComprehensiveSearchSelectPopCellID];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommunityFairComprehensiveSearchSelectPopCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairComprehensiveSearchSelectPopCellID forIndexPath:indexPath];
    cell.contentV.tag = 200 + indexPath.row;
    [cell.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap:)]];
    if (indexPath.row == self.dataArray.count - 1) {
        [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, kZYCommunityFairComprehensiveSearchSelectPopCellHeight) radius:15 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }else {
        [cell.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, kZYCommunityFairComprehensiveSearchSelectPopCellHeight) radius:0 corners:UIRectCornerBottomLeft|UIRectCornerBottomRight];
    }
    cell.contentLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYCommunityFairComprehensiveSearchSelectPopCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewContentViewEventWithIndex:)]) {
        [self.delegate popViewContentViewEventWithIndex:indexPath.row];
    }
}

#pragma mark - 处理点击事件
- (void)tableViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popTableViewEvent)]) {
        [self.delegate popTableViewEvent];
    }
}

- (void)contentViewTap:(UIGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(popViewContentViewEventWithIndex:)]) {
        [self.delegate popViewContentViewEventWithIndex:tap.view.tag - 200];
    }
}

#pragma mark - 显示视图
- (void)showCommunityFairComprehensiveSearchSelectPopViewWithSuperView:(UIView *)superView {
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 100 + status_height, kScreenW, kScreenH - (100 + status_height));
    [superView addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 1.0;
    }];
}

#pragma mark - 隐藏视图
- (void)hiddenCommunityFairComprehensiveSearchSelectPopView {
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

@end
