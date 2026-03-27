//
//  CommonVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/27.
//

#import "CommonVC.h"

#import "PersonalRecommendVC.h"

#import "PersonInfoNormalCell.h"
#import "CommonCacheCell.h"

@interface CommonVC ()

@property(nonatomic, strong) NSMutableArray *titleArray;

@end

static NSString *const cacheCellID = @"CommonCacheCell";
static NSString *const normalCellID = @"PersonInfoNormalCell";

@implementation CommonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)initView{
    self.title = @"通用";
//    self.tableView.backgroundColor = Color_245Gray;
    [self.tableView registerClass:[PersonInfoNormalCell class] forCellReuseIdentifier:normalCellID];
    [self.tableView registerClass:[CommonCacheCell class] forCellReuseIdentifier:cacheCellID];
//    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
}
- (void)initData{
//    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"个性化推荐设置",nil];//0929只保留清缓存功能
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",nil];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        CommonCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cacheCellID];
        if (!cell) {
            cell = [[CommonCacheCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cacheCellID];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        return cell;
    }else{
        PersonInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
        if (!cell) {
            cell = [[PersonInfoNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellID];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }else if (indexPath.row == 1){//@"个性化推荐设置"
        PersonalRecommendVC *vc = [[PersonalRecommendVC alloc] init];
        [self pushVc:vc];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
