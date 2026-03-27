//
//  MyEditHouseSubUserConfirmVc.m
//  Community
//
//  Created by 余莹 on 2021/9/24.
//

#import "MyEditHouseSubUserConfirmVc.h"
#import "MyHouseData.h"
#import "MyEditHouseVc.h"

#import "MyHouseAddSubPersonTableViewCell.h"
#define MyHouseAddSubPersonTableViewCellTextFeild_Identifier @"MyHouseAddSubPersonTableViewCellTextFeild"

@interface MyEditHouseSubUserConfirmVc () <MyHouseAddSubPersonTableViewCellTextFeildDelegate>
@property (nonatomic,strong) NSMutableArray *cellTitleArr;
@property (nonatomic,strong) LabelYu *headerLabel;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MyEditHouseSubUserConfirmVc
 
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerLabel;
    self.tableView.tableFooterView = self.footerView;
    self.title = @"确认业主信息";
    [self initData];
}
 
- (void)initData{
    self.cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"手机", nil];
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"",  nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.cellTitleArr.count;
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyHouseAddSubPersonTableViewCellTextFeild *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
    if (!cell) {
        cell = [[MyHouseAddSubPersonTableViewCellTextFeild alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
        cell.delegate = self;
    }
    cell.titleL.text = self.cellTitleArr[indexPath.row];
    cell.textField.text = self.dataSourceArr[indexPath.row];
    cell.textField.tag = indexPath.row+200;
    return cell;
}
#pragma mark ===

- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)textStr{
    NSInteger index = tag-200;
    [self.dataSourceArr replaceObjectAtIndex:index withObject:textStr];

}

#pragma mark ==
- (LabelYu *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 35)];
        _headerLabel.text = @"温馨提示：请输入业主在物业留存的信息";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = [UIFont systemFontOfSize:11];
        _headerLabel.textInsets  = UIEdgeInsetsMake(2.f, 15.f, 2.f, 15.f); // 设置左内边距(上、左、下、右)

    }
    _headerLabel.backgroundColor = Y_RGBA(15, 100, 253, 0.3);
    _headerLabel.textColor = [ThemeManager shareManager].mainTextColor;
    return _headerLabel;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"提交信息"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerView;
}
- (void)footerBtnAction{
    [self.view endEditing:YES];
    //
    NSString *nameStr = [NSString stringWithFormat:@"%@",self.dataSourceArr.firstObject];
    NSString *phonetr = [NSString stringWithFormat:@"%@",self.dataSourceArr.lastObject];

    if ( isNil(nameStr)  || isNil(phonetr) || nameStr.length<=0 || phonetr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入业主在物业留存的信息！");
        return;
    }

    NSMutableDictionary *addHouseAllInfo = [[NSMutableDictionary alloc]init];
    [addHouseAllInfo setValue:@(self.nowChooseCommunityId) forKey:@"communityId"];
    [addHouseAllInfo setValue:@(self.nowChooseHouseId) forKey:@"houseId"];
    [addHouseAllInfo setValue:nameStr forKey:@"name"];
    [addHouseAllInfo setValue:phonetr forKey:@"mobile"];

    [MyHouseData addMyHouseWithHouseInfoDic:addHouseAllInfo withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MyEditHouseVc class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
             });
        }
    }];
}


  
@end
