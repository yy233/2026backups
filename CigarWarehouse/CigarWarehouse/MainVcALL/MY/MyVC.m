//
//  MyVC.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "MyVC.h"


@interface MyVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MyVC
#pragma mark ==== 退出
- (void)addNavItem{
//    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"退出"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(showEx)];
    UIBarButtonItem *rightMaxItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(showEx)];
    [self.navigationItem setRightBarButtonItems:@[rightMaxItem] animated:YES];
    
}
- (void)showEx{
    
    NSString *msg = [NSString stringWithFormat:@"%@?",@"退出"];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //数据清空 token
        
        [ShareUserInfo share].userInfo.token = @"";
        [[ShareUserInfo share] saveDefaultsLoginUserInfo:[ShareUserInfo share].userInfo];
        DLog(@"登出 [ShareUserInfo share].userInfo = %@",[[ShareUserInfo share].userInfo mj_keyValues]);
        //即将重载 处理window
        self.view.window.rootViewController  = [[LoginVC alloc]init];
        
    }];
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:alertCancel];
    [alertC addAction:alertA];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertC animated:YES completion:nil];
    });
}
 

#pragma mark ====
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavItem];
    [self initData];
    [self initView];

}
- (void)initData{
   NSString *vStr = [Tool softwareVersion];
    self.titleArr = [[NSMutableArray alloc]initWithObjects:@"出入库记录",@"绩效情况",[@"当前版本：" stringByAppendingString:vStr], nil];
}
- (void)initView{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0.1;
    } else {
        // Fallback on earlier versions
    }//设置这个组头顶部填充 = 0解决问题
}

#pragma mark ====
- (UITableView *)tableView{
       if(!_tableView){
           _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
           _tableView.delegate = self;
           _tableView.dataSource = self;
           _tableView.backgroundColor = [UIColor clearColor];
           _tableView.tableFooterView = [UIView new];
       }
       return _tableView;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
    
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell_myvc"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell_myvc"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 36, 0, 36);
        cell.backgroundColor = [CC_Red_Drak_A colorWithAlphaComponent:0.2];
   
    }
    if (indexPath.row == [tableView numberOfRowsInSection:0]-1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = self.titleArr[indexPath.row];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleArr[indexPath.row];
    }
    
    return cell;
  
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == [tableView numberOfRowsInSection:0]-1) {
    }else{
        Y_SVP_SHOW_INFO_MES(@"敬请期待");
    }
 

//    switch (indexPath.row) {
//        case 0:
//            break;
//        default:
//            break;
//    }
}
#pragma mark ===

@end
