//
//  ChatAccountSecurityTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatAccountSecurityTableVc.h"
#import "EquipmentManagementTableVc.h"

@interface ChatAccountSecurityTableVc ()
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *headerSubLabel;
@property (nonatomic,strong) UILabel *headerSubDetailLabel;
@property (nonatomic,strong) NSMutableArray *titleArr;

@end

@implementation ChatAccountSecurityTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
    [self isSecuity];
}
- (void)initView{

    [self.headerView addSubview:self.imgV];
    [self.headerView addSubview:self.headerSubLabel];
    [self.headerView addSubview:self.headerSubDetailLabel];
    //
    [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(_imgV.superview);
        make.width.height.offset(128);
    }];
    //
    [_headerSubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgV.mas_bottom).offset(5);
        make.centerX.left.right.equalTo(_headerSubLabel.superview);
    }];
    [_headerSubDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerSubLabel.mas_bottom).offset(5);
        make.centerX.left.right.equalTo(_headerSubLabel.superview);
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)initData{
 //不安全
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notSecuity];
    });
}
//安全
- (void)isSecuity{
    //nav
    [self setupsetupNavigationBarWithChatVcStyle];
    
    //header
    self.imgV.image = [UIImage imageNamed:@"chat_secuity"];
    self.headerSubLabel.text = @"帐号目前很安全";
    self.headerSubDetailLabel.text = @"上次检测日期：2020.12.18  15:30";

    UIColor *beginColor = Y_ColorWith16FromRGB(0x567BF3);
    UIColor *endColor = Y_ColorWith16FromRGB(0x3B8FFD);
    CGSize size = self.headerView.frame.size;
    DLog(@" isSecuity --  %@",NSStringFromCGSize(size));
    self.headerView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
}
//不安全
- (void)notSecuity{
    //nav
    UIColor *beginColor = Y_ColorWith16FromRGB(0xFF9656);
    UIColor *endColor = Y_ColorWith16FromRGB(0xFF731E);
    CGSize size = CGSizeMake(Screen_W, KNavBarHeight);
    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomBeginColor:beginColor  andBackViewCustomEndColor:endColor andSize:size];
    
    //header
    self.imgV.image = [UIImage imageNamed:@"chat_secuity_no"];
    self.headerSubLabel.text = @"帐号存在风险";
    self.headerSubDetailLabel.text = @"上次检测日期：2020.12.18  15:33";
    DLog(@" isSecuity --  %@",NSStringFromCGSize(size));
    self.headerView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]init];
    backBtn.title = self.titleArr[indexPath.row];
    [self.navigationItem setBackBarButtonItem:backBtn];
    DLog(@"%@",backBtn.title);
    switch (indexPath.row) {
        case 0:
        {
            
            
        }
            break;
         
        case 1:
        {
            EquipmentManagementTableVc *vc = [[EquipmentManagementTableVc alloc]init];
            [self pushVc:vc];
        }
            break;
        case 2:
        {
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font  = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}
 
#pragma mark = headerView
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H *0.4)];
    }
    return _headerView;
}
- (UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
    }
    return _imgV;
}
- (UILabel *)headerSubLabel{
    if (!_headerSubLabel) {
        _headerSubLabel = [[UILabel alloc]init];
        _headerSubLabel.textAlignment = NSTextAlignmentCenter;
        _headerSubLabel.textColor = [UIColor whiteColor];
        _headerSubLabel.font = [UIFont systemFontOfSize:16];
    }
    return _headerSubLabel;
}
- (UILabel *)headerSubDetailLabel{
    if (!_headerSubDetailLabel) {
        _headerSubDetailLabel = [[UILabel alloc]init];
        _headerSubDetailLabel.textAlignment = NSTextAlignmentCenter;
        _headerSubDetailLabel.textColor = [UIColor whiteColor];
        _headerSubDetailLabel.font = [UIFont systemFontOfSize:10];
    }
    return _headerSubDetailLabel;
}

//
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"修改密码",@"登录设备管理",@"手势密码", nil];
    }
    return _titleArr;
}
@end
