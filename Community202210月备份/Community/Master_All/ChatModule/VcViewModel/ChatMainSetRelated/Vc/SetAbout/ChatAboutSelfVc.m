//
//  ChatAboutSelfVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatAboutSelfVc.h"

@interface ChatAboutSelfVc ()
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *headerSubLabel;
@property (nonatomic,strong) NSMutableArray *titleArr;
@end

@implementation ChatAboutSelfVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
 
- (void)initView{
    UIColor *beginColor = Y_ColorWith16FromRGB(0x567BF3);
    UIColor *endColor = Y_ColorWith16FromRGB(0x3B8FFD);
    CGSize size = self.headerView.frame.size;
    self.headerView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
    //
    [self.headerView addSubview:self.imgV];
    [self.headerView addSubview:self.headerSubLabel];
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
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)initData{

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app大版本号
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build小版本号
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    self.headerSubLabel.text = [NSString stringWithFormat:@"版本号： v %@",app_Version];
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
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H *0.3)];
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
 

//
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"版本更新",@"服务条款",@"隐私政策",@"联系我们", nil];
    }
    return _titleArr;
}
@end
