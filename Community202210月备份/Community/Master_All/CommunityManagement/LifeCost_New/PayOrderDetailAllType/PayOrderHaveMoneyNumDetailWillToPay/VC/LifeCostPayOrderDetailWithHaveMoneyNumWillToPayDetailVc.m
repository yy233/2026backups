//
//  LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc.h"

@interface LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc ()
@end

@implementation LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc

//出来账单的数据
- (void)initData{
    self.oneSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费单位",@"户号/户名",@"地址",@"账期", nil];
    self.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", nil];
    [self.tableView reloadData];
    WEAKSELF
    [LifeCostData lifeCostGetWillPayOrderDetailWithIdStr:self.idStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            weakSelf.detailModel = [LifeWillToPayOrderDetailModel mj_objectWithKeyValues:dic];
            NSString *companyStr = [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.companyName];
            NSString *accountAndNameStr = [NSString stringWithFormat:@"%@ | %@", [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.billKey], [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.customerName]];
            NSString *addressStr = [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.address];
            NSString *endDatetr = [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.endDate];
            //
            if (companyStr.length<=0) {
                companyStr = @"暂无详情";
            }
            if (addressStr.length<=0) {
                addressStr = @"暂无详情";
            }
            if (endDatetr.length<=0) {
                endDatetr = @"暂无详情";
            }
            weakSelf.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:companyStr,accountAndNameStr,addressStr,endDatetr, nil];
            NSString *imgURLStr = [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.typePicUrl];
            NSString *moneyNumStr = [TextShowWithModelStr textShowWithNotNullStr:weakSelf.detailModel.billAmount];
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.topView fillTopViewDataWithImgUrlStr:imgURLStr withMoneyNumStr:moneyNumStr];

            });
        }
    }];
    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1; 
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.oneSectionTitleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderSubTextCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"orderSubTextCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.oneSectionTitleArr[indexPath.row];
    cell.detailTextLabel.text = self.onwSectionDataArr[indexPath.row];
    return cell;
    
}

#pragma mark == 立即缴费
- (void)footerBtnAction{
    DLog(@"立即缴费");

    WEAKSELF
   
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *typeId = [TextShowWithModelStr textShowWithModelStr: self.detailModel.typeId ];
    NSString *itemId = [TextShowWithModelStr textShowWithModelStr:self.detailModel.itemId ];
    NSString *itemCode = [TextShowWithModelStr textShowWithModelStr:self.detailModel.itemCode];
    NSString *billKey = [TextShowWithModelStr textShowWithModelStr:self.detailModel.billKey];
    NSString *payAmount = [TextShowWithModelStr textShowWithModelStr:self.detailModel.billAmount];
    NSString *deviceType = @"2";
    NSString *idStr = [TextShowWithModelStr textShowWithModelStr:self.detailModel.idStr];
    NSString *queryAcqSsn = [TextShowWithModelStr textShowWithModelStr:self.detailModel.queryAcqSsn];
    NSString *customerName = [TextShowWithModelStr textShowWithModelStr:self.detailModel.customerName];
    NSString *contactNo = [TextShowWithModelStr textShowWithModelStr:self.detailModel.contactNo];
    NSString *balance = [TextShowWithModelStr textShowWithModelStr:self.detailModel.balance];
    NSString *addressStr = [TextShowWithModelStr textShowWithModelStr:self.detailModel.address];

    [parms setValue:typeId     forKey:@"typeId"];
    [parms setValue:itemId     forKey:@"itemId"];
    [parms setValue:itemCode   forKey:@"itemCode"];
    [parms setValue:billKey    forKey:@"billKey"];
    [parms setValue:payAmount  forKey:@"payAmount"];
    [parms setValue:deviceType forKey:@"deviceType"];
    //非必需键值
    [parms setValue:@"0"                   forKey:@"type"];
    [parms setValue:idStr                  forKey:@"id"];
    [parms setValue:payAmount              forKey:@"billAmount"];
    [parms setValue:queryAcqSsn            forKey:@"queryAcqSsn"];
    [parms setValue:customerName           forKey:@"customerName"];
    [parms setValue:contactNo              forKey:@"contactNo"];
    [parms setValue:balance                forKey:@"balance"];
    

 
    [LifeCostData lifeCostPayOrderActionWithBodyDic:parms withDlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success ) {
            LifeCostPayOrderGetWithSuccessOrFailModel *successPayOrderGetEndModel = [LifeCostPayOrderGetWithSuccessOrFailModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                LifeCostPayActionSuccessOrFailWebVC *vc = [[LifeCostPayActionSuccessOrFailWebVC alloc]init];
                vc.payActionPlaceOrderEndGetUrlStr = [TextShowWithModelStr textShowWithModelStr:  successPayOrderGetEndModel.url];
                vc.orderNoStr = [TextShowWithModelStr textShowWithModelStr:successPayOrderGetEndModel.orderNo];
                [weakSelf pushVc:vc]; 
            });
        }
    }];
}
@end
