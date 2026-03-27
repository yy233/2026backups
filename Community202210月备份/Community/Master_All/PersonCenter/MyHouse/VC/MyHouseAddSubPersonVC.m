//
//  MyHouseAddSubPerson.m
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import "MyHouseAddSubPersonVC.h"
#import "MyHouseAddSubPersonTableViewCell.h"
#import "MyHouseAddSubPersonModel.h"
#import "MyHouseData.h"
#import "MyHouseAddSubPeronOkShowScanCodeVc.h"
#define MyHouseAddSubPersonTableViewCellTextFeild_Identifier @"MyHouseAddSubPersonTableViewCellTextFeild"
#define MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier @"MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn"
#import "MyHouseAddSubPerSonSuccessVc.h"

@interface MyHouseAddSubPersonVC () <MyHouseAddSubPersonTableViewCellTextFeildDelegate>
@property (nonatomic,strong) NSMutableArray *cellTitleArr;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) MyHouseAddSubPersonModel *selfAddPersonModel;
@end

@implementation MyHouseAddSubPersonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = self.footerView;
    self.title = @"添加人员";
    [self initData];
}
 
- (void)initData{
    self.selfAddPersonModel = [[MyHouseAddSubPersonModel alloc]init];
    self.selfAddPersonModel.communityId = self.nowCommunityId;
    self.selfAddPersonModel.houseId = self.nowHouseId;
   
 
    self.cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"手机",@"身份", nil];
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"", @"",  nil];
    
    if (self.isYeZhuRight) {
    }else{
        [self.dataSourceArr replaceObjectAtIndex:2 withObject:@"租客"];
        self.selfAddPersonModel.relation = 7;//PersonRelatio_Num_Zuke
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.cellTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { 
    if (indexPath.row != 2) {
        MyHouseAddSubPersonTableViewCellTextFeild *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeild alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
            cell.delegate = self;
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceArr[indexPath.row];
        cell.textField.tag = indexPath.row+200;
        return cell;
  
    } else {
        MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
            cell.delegate = self;
        }
        
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceArr[indexPath.row];
        cell.textField.tag = indexPath.row+200;
        cell.touchBtnBlock = ^{
            [self textFieldTopBtnActionWithRowNum:indexPath.row];
        };
        if (self.isYeZhuRight) {//业主 可新增两种
        }else{//家属 只能增租客 不可点击选择
            cell.textField.userInteractionEnabled = NO;
            cell.viewTopChooseBtn.userInteractionEnabled = NO;
        }
        return cell;
    }
}
 
#pragma mark ===
- (void)textFieldTopBtnActionWithRowNum:(NSInteger)rowNum{
    [self.view endEditing:YES];//
    
    NSArray *titleArr = @[@"家属",@"租客"];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择人员的身份关系" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF
    //@"家属"
    UIAlertAction *fmailAction = [UIAlertAction actionWithTitle:titleArr.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.selfAddPersonModel.relation = 6;
        [weakSelf upRelationRowNum:rowNum andShowStr:titleArr.firstObject andIsFmailBool:YES];
    }];
 
    //@"租客"
    UIAlertAction *tenantAction = [UIAlertAction actionWithTitle:titleArr.lastObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.selfAddPersonModel.relation = 7;
        [weakSelf upRelationRowNum:rowNum andShowStr:titleArr.lastObject andIsFmailBool:NO];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:fmailAction];
    [alertVC addAction:tenantAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
- (void)upRelationRowNum:(NSInteger)rowNum andShowStr:(NSString *)showStr andIsFmailBool:(BOOL)isFamailBool{
    [self.dataSourceArr replaceObjectAtIndex:rowNum withObject:showStr];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];

    });
}
  

#pragma mark ===

- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)textStr{
    NSInteger index = tag-200;
    switch (index) {
        case 0:
        {//name
            self.selfAddPersonModel.name = textStr;
        }
            break;
        case 1:
        {//phone
            self.selfAddPersonModel.mobile = textStr;
        }
            break;
            
        default:
            break;
    }
    [self.dataSourceArr replaceObjectAtIndex:index withObject:textStr];

}
#pragma mark ==
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
    NSLog(@"新增 提交信息");
    //test
//    NSString *addInfoStr = [NSString stringWithFormat:@"邀请您（%@）加入我的%@成员关系", self.selfAddPersonModel.name,self.dataSourceArr.lastObject];
//    NSString *urlStr = @"http://192.168.12.113:8080/#/?id=112584117614415872&mobile=18012345678";//绑定时 家属的uid NSString *boundPeronUid = [ShareUserInfo sharedUserInfo].userInfo.uid;   NSString *endUrlStr = [urlStr stringByAppendingString:boundPeronUid];
//
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        MyHouseAddSubPeronOkShowScanCodeVc *vc = [[MyHouseAddSubPeronOkShowScanCodeVc alloc]init];
//        vc.showScanCodeWebUrlStr = urlStr;
//        vc.addInfoStr = addInfoStr;
//        vc.addressStr = self.addressStr;
//        [self pushVc:vc];
//    });
//    return;
//    //
    NSString *addInfoStr = [NSString stringWithFormat:@"邀请您（%@）加入我的%@成员关系", self.selfAddPersonModel.name,self.dataSourceArr.lastObject];

    WEAKSELF
    NSMutableDictionary *personInfo = [[NSMutableDictionary alloc]initWithDictionary:[self.selfAddPersonModel mj_keyValues]];
    DLog(@"personInfo  %@",personInfo);
    [MyHouseData addMyHousePersonsRelationsWithPersonInfoDic:personInfo withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            if (isNil(dic)) {
                Y_SVP_SHOW_ERR_MES(@"数据有误");
                return;
            }
            NSString *urlStr = [dic objectForKey:@"URL"];
            dispatch_async(dispatch_get_main_queue(), ^{
                MyHouseAddSubPerSonSuccessVc *vc = [[MyHouseAddSubPerSonSuccessVc alloc]init];
                vc.showScanCodeWebUrlStr = urlStr;
                vc.addInfoStr = addInfoStr;
                vc.addressStr = self.addressStr;
                [weakSelf pushVc:vc];
                //再删除nav中的编辑页 跳转了再删 不然就nil了
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                    if ([weakSelf respondsToSelector:@selector(removeSelfVc)]) {
                        [weakSelf performSelector:@selector(removeSelfVc) withObject:nil];
                    }
                });
            });
        }
    }];
}
- (void)removeSelfVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
         for (UIViewController *vc in vcArr) {
             if ([vc isKindOfClass:[MyHouseAddSubPersonVC class]]) {
                 [vcArr removeObject:vc];
                 break;
             }
         }
         self.navigationController.viewControllers = vcArr;
    });
}
@end
