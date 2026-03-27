//
//  ZYAccessRecordMemberPopView.m
//  Community
//
//  Created by ZY on 2022/4/26.
//

#import "ZYAccessRecordMemberPopView.h"
#import "ZYAccessRecordMemberPopCell.h"

static CGFloat popViewDuration = 0.25;
#define kContentViewHeight (275+bottom_height)
static NSString * const ZYAccessRecordMemberPopCellID = @"ZYAccessRecordMemberPopCell";
#define kZYAccessRecordMemberPopCellHeight 40

@interface ZYAccessRecordMemberPopView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ZYAccessRecordMemberPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentViewHeightConstraint.constant = kContentViewHeight;
    self.contentViewBottomConstraint.constant = -kContentViewHeight;
    [self.contentV cornerRadiusWithBounds:CGRectMake(0, 0, kScreenW, kContentViewHeight) radius:20 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popViewTap)]];
    [self.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentVTap)]];
    
    [self customTableView];
}

// 加载数据
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYAccessRecordMemberPopCellID bundle:nil] forCellReuseIdentifier:ZYAccessRecordMemberPopCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYAccessRecordMemberPopCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYAccessRecordMemberPopCellID forIndexPath:indexPath];
    cell.contentV.tag = 200 + indexPath.row;
    [cell.contentV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap:)]];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYAccessRecordMemberPopCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

#pragma mark - 显示视图
- (void)showAccessRecordMemberPopView {
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
        self.contentViewBottomConstraint.constant = 0;
        [self layoutIfNeeded];
    }];
}

#pragma mark - 隐藏视图
- (void)hiddenAccessRecordMemberPopView {
    self.alpha = 1.0;
    [UIView animateWithDuration:popViewDuration animations:^{
        self.alpha = 0.0;
        self.contentViewBottomConstraint.constant = -kContentViewHeight;
        [self layoutIfNeeded];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(popViewDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - 处理点击事件
- (void)closeButtonClicked {
    [self hiddenAccessRecordMemberPopView];
}

- (void)popViewTap {
    [self hiddenAccessRecordMemberPopView];
}

- (void)contentVTap {
}

- (void)contentViewTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewEventWithIndex:)]) {
        [self.delegate contentViewEventWithIndex:tap.view.tag - 200];
    }
}

@end
