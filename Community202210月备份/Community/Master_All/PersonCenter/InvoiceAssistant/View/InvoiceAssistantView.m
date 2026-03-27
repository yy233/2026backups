//
//  InvoiceAssistantView.m
//  Community
//
//  Created by 刘久炼 on 2021/2/23.
//

#import "InvoiceAssistantView.h"
#import "InvoiceAssistantCell.h"



@interface InvoiceAssistantView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topV;

@property(nonatomic, weak) UIView *lineV;

@property(nonatomic, weak) UIButton *leftBtn;

@property(nonatomic, weak) UIButton *rightBtn;

@property(nonatomic, weak) UITableView *tableV;

@property(nonatomic, weak) UIButton *selectedBtn;

@property(nonatomic, weak) UIView *lineV1;

@property(nonatomic, weak) BaseTableViewFooterView *addView;


@end

static NSString *const cellID = @"InvoiceAssistantCell";

@implementation InvoiceAssistantView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.offset(50);
    }];
    
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.topV);
        make.height.offset(20);
        make.width.offset(0.5);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(self.topV);
        make.right.mas_equalTo(self.lineV.mas_left);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(self.topV);
        make.left.mas_equalTo(self.lineV.mas_right);
    }];
    
    [self.lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.leftBtn);
        make.bottom.mas_equalTo(self.leftBtn).offset(-10);
        make.width.offset(31);
        make.height.offset(3);
    }];
    
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-20);
        make.height.offset(45);
    }];
    
    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.topV.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.addView.mas_top);
    }];
}

#pragma mark - 懒加载

- (UIView *)topV{
    if (!_topV) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        _topV = view;
    }
    return _topV;
}

- (UIView *)lineV{
    if (!_lineV) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [Tool getColorWithHexString:@"#E5E5E5"];
        [self.topV addSubview:view];
        _lineV = view;
    }
    return _lineV;
}

- (UIView *)lineV1{
    if (!_lineV1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [Tool getColorWithHexString:@"#2672F9"];
        [self.topV addSubview:view];
        _lineV1 = view;
    }
    return _lineV1;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"发条抬头" forState:UIControlStateNormal];
        [btn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[Tool getColorWithHexString:@"#2672F9"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[Tool getColorWithHexString:@"#2672F9"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 0;
        btn.titleLabel.font = FontSize_Vip_Bold(17);
        btn.selected = YES;
        [self.topV addSubview:btn];
        _leftBtn = btn;
        _selectedBtn = btn;
    }
    return _leftBtn;
}


- (UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"我的发票" forState:UIControlStateNormal];
        [btn setTitleColor:[Tool getColorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[Tool getColorWithHexString:@"#2672F9"] forState:UIControlStateSelected];
        [btn setTitleColor:[Tool getColorWithHexString:@"#2672F9"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1;
        btn.titleLabel.font = FontSize_Vip_Bold(17);
        [self.topV addSubview:btn];
        _rightBtn = btn;
    }
    return _rightBtn;
}

- (BaseTableViewFooterView *)addView{
    if (!_addView) {
        BaseTableViewFooterView *addView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-30, 45)];
        [addView.footerBtn setTitle:@"添加抬头" forState:UIControlStateNormal];
        [addView.footerBtn setImage:[UIImage imageNamed:@"Orderreminder_addto"] forState:UIControlStateNormal];
        [addView.footerBtn setImage:[UIImage imageNamed:@"Orderreminder_addto"] forState:UIControlStateHighlighted];
        [addView.footerBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addView];
        _addView = addView;
    }
    return _addView;
}

- (UITableView *)tableV{
    if (!_tableV ){
        UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:tableV];
        tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableV.showsVerticalScrollIndicator = NO;
        if (@available(ios 11.0,*)) {
            // 针对 11.0 以上的iOS系统进行处理
            tableV.estimatedRowHeight = 0;
            tableV.estimatedSectionHeaderHeight = 5;
            tableV.estimatedSectionFooterHeight = 5;
            tableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [tableV registerClass:[InvoiceAssistantCell class] forCellReuseIdentifier:cellID];
        
        _tableV = tableV;
    }
    return _tableV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 13;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvoiceAssistantCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return 89;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(cellCliced)]) {
        [self.delegate cellCliced];
    }
}



- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    kWeakSelf(tableView)
    if (@available(iOS 11.0, *)) {
        UIContextualAction *action1 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            kStrongSelf(tableView)
            [tableView reloadData];
            completionHandler(YES);
        }];
        
        //action.image = [UIImage imageNamed:@"icon_delete"];//若仅设置此属性，会被系统渲染
        action1.backgroundColor = [Tool getColorWithHexString:@"#FF4D53"];
        UIContextualAction *action2 = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"设为默认" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            kStrongSelf(tableView)
            [tableView reloadData];
            completionHandler(YES);
        }];
        
        //action.image = [UIImage imageNamed:@"icon_delete"];//若仅设置此属性，会被系统渲染
        action2.backgroundColor = [Tool getColorWithHexString:@"#F9AC07"];
        
        return [UISwipeActionsConfiguration configurationWithActions:@[action1,action2]];
    }
    return nil;
}

#pragma mark - 懒加载

- (void)btnClicked: (UIButton *)sender{
    if (self.selectedBtn == sender) {
        return;
    }
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    self.selectedBtn = sender;
    [self.lineV1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.selectedBtn);
        make.bottom.mas_equalTo(self.selectedBtn).offset(-10);
        make.width.offset(31);
        make.height.offset(3);
    }];
}

- (void)addBtnClicked{
    if ([self.delegate respondsToSelector:@selector(addBtnClicked)]) {
        [self.delegate addBtnClicked];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
