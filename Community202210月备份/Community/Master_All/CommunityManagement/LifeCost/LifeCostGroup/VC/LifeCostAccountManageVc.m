//
//  LifeCostAccountManage.m
//  Community
//
//  Created by 余莹 on 2021/1/13.
//  户号管理

#import "LifeCostAccountManageVc.h"
#import "LifeCostAccountGroupAddVc.h"
//
#import "LifeCostGroupViewModel.h"
#import "LifeCostAccountManageModel.h"

#import "LifeCostAccountManageTableViewCell.h"
#define LifeCostAccountManageTableViewCell_Identifier       @"LifeCostAccountManageTableViewCell.h"

#define H_Bottom_View   90
#define H_cell          60
#define H_sectionHeader 10
#define H_sectionFooter 1
@interface LifeCostAccountManageVc ()
@property (nonatomic,strong) BaseTableViewFooterView *footerAddView;


@end

@implementation LifeCostAccountManageVc

- (void)viewDidLoad {
    self.reDic = [[NSDictionary alloc]init];
    self.keyArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.title = @"户号管理";
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [self footerAddView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];//用于下页新增情况下的刷新
}
- (void)initData{
    WEAKSELF
    [LifeCostGroupViewModel getHuHaoManageWithGroupList:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.reDic = dic.mutableCopy;
            weakSelf.keyArr = [dic allKeys].mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==

- (void)footerAddNewGroupAction{//新增分组
    LifeCostAccountGroupAddVc *vc = [[LifeCostAccountGroupAddVc alloc]init];
    [self pushVc:vc];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section==0) {
////        NSLog(@"%@",self.keyArr[indexPath.row]);
//    }else{
//        NSLog(@" 自定义分组   ");
//    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keyArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *keyStr = [NSString stringWithFormat:@"%@",self.keyArr[section]];
    NSArray *arr = [[NSArray alloc]initWithArray:self.reDic[keyStr]];
    return arr.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return H_sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return H_sectionFooter;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H_cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        //keystr cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.indentationLevel =  2;
            cell.indentationWidth = 10;
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.keyArr[indexPath.section]];
        return cell;
    }else{
        //info cell
        LifeCostAccountManageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostAccountManageTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostAccountManageTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostAccountManageTableViewCell_Identifier];
        }
        NSString *keyStr = [NSString stringWithFormat:@"%@",self.keyArr[indexPath.section]];
        NSArray *arr = [[NSArray alloc]initWithArray:self.reDic[keyStr]];
       NSArray *sectionArr =  [LifeCostAccountManageModel mj_objectArrayWithKeyValuesArray:arr];
        LifeCostAccountManageModel *model = sectionArr[indexPath.row-1];
        cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.companyName];
        cell.detailTitleL.text = [NSString stringWithFormat:@"%ld %@",model.familyId,model.typeName];
        return cell;
    }
    
}
- (BaseTableViewFooterView *)footerAddView{
    if (!_footerAddView) {
        _footerAddView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, Screen_W, H_Bottom_View)];
        [_footerAddView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
        [_footerAddView.footerBtn setTitle:@"+新增分组" forState:UIControlStateNormal];
        _footerAddView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [_footerAddView.footerBtn addTarget:self action:@selector(footerAddNewGroupAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerAddView;
}
@end
