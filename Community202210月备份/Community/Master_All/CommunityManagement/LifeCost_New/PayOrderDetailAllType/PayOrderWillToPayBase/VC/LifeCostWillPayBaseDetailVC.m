//
//  LifeCostWillPayBaseDetailVC.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostWillPayBaseDetailVC.h"
#import "LifeCostPayHistoryOrderListVC.h"
@interface LifeCostWillPayBaseDetailVC () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LifeCostWillPayBaseDetailVC
//[self.tableView setScrollEnabled:NO];//无效 用zero
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        scrollView.contentOffset = CGPointZero;
    }
}
 
    
- (NSMutableArray *)oneSectionTitleArr{
    if (!_oneSectionTitleArr) {
        _oneSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    }
    return _oneSectionTitleArr;
}
- (NSMutableArray *)onwSectionDataArr{
    if (!_onwSectionDataArr) {
        _onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    }
    return _onwSectionDataArr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单详情";
    [self initView];
    [self initData];
    
}
- (void)initData{
    _oneSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费单位",@"户号/户名",@"地址",@"账期", nil];
    _onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    
    [self.tableView reloadData];
}
#pragma mark ==
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    if ([ThemeManager shareManager].type == ThemeType_White) {
        [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Nav_BrightBlueColor];
    }else{
        [self changeNavBackColorWithDDndWIsGW];
    }
}
- (void)initView{
    self.view.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;//不可滑动
    [self setUI];
    [self addNavRightBtn];
}

- (void)setUI{
 
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(H_TopView);
    }];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_footerView.superview);
        make.height.offset(90);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableView.superview).offset(16);
        make.right.equalTo(_tableView.superview).offset(-16);
        make.top.equalTo(_topView.mas_bottom).offset(-30);
        make.bottom.equalTo(_footerView.mas_top);
    }];

}

#pragma mark === navBtn
- (void)addNavRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"缴费记录" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction{
    DLog(@"缴费记录");
    LifeCostPayHistoryOrderListVC *vc = [[LifeCostPayHistoryOrderListVC alloc]init];
//    vc.nowPayTypeList = self.myNewPayTypeArr;//全部类型列表传入 用作类型筛选项
    [self pushVc:vc];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 175;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderSubTextCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderSubTextCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    cell.textLabel.text =  @"";
    cell.detailTextLabel.text = @"";

    return cell;
}
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIColor *cellBackGroundFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 5.0f;//圆角
        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 0.0, 0);//外距离
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = cellBackGroundFillColor.CGColor;
        layer.strokeColor= cellBackGroundFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//            [layer addSublayer:lineLayer];//去掉分割线
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

 
- (LifeCostWillPayBaseDetailMainTopView *)topView{
    if (!_topView) {
        _topView = [[LifeCostWillPayBaseDetailMainTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_TopView)];
    }
    return _topView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"立即缴费"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
- (void)footerBtnAction{
    DLog(@"立即缴费");
}
@end
