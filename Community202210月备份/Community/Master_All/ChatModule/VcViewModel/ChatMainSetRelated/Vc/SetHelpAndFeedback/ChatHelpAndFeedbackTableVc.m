//
//  ChatHelpTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatHelpAndFeedbackTableVc.h"

@interface ChatHelpAndFeedbackTableVc ()
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *headerLabel;
@property (nonatomic,strong) UIButton *headersubBtn;
@property (nonatomic,strong) NSMutableArray *titleArr;

@end

@implementation ChatHelpAndFeedbackTableVc
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
- (void)initView{
    [self.headerView addSubview:self.headersubBtn];
    [self.headerView addSubview:self.headerLabel];
    [_headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerLabel.superview).offset(16);
        make.centerY.equalTo(_headerLabel.superview);
        make.width.offset(70);
        make.height.offset(20);
    }];
    [_headersubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headersubBtn.superview).offset(-16);
        make.centerY.equalTo(_headersubBtn.superview);
        make.width.offset(80);
        make.height.offset(30);
    }];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
    
}
- (void)headersubBtnAction:(UIButton *)sender{
    DLog(@"立即反馈");
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
 
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍",@"聊天APP的使用方法介绍", nil];
    }
    return _titleArr;
}

#pragma mark ==
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
    }
    return _headerView;
}
- (UIButton *)headersubBtn{
    if (!_headersubBtn) {
        _headersubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headersubBtn newAnBtnWithTextStr:@"立即反馈"];//w80 h30
        [_headersubBtn newAnBtnWithLayerCorNerNum:15 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
        [_headersubBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        UIColor *color =  [UIColor y_colorGradientChangeWithSize:CGSizeMake(80, 30) direction:IHGradientChangeDirectionLevel startColor:Y_ColorWith16FromRGB(0x3D8EFC) endColor:Y_ColorWith16FromRGB(0x2558FF)];
        [_headersubBtn newAnBtnWithBackColor:color];
        [_headersubBtn addTarget:self action:@selector(headersubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headersubBtn;
}
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel  = [[UILabel alloc]init];
        _headerLabel.font = [UIFont boldSystemFontOfSize:16];
        _headerLabel.text = @"问题反馈";
        _headerLabel.textColor = Y_ColorWith16FromRGB(0x333333);
    }
    return _headerLabel;
}
@end
