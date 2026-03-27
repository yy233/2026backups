//
//  LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import "LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.h"
//section_two H==175
#import "PayOrderMoneyInPutTableViewCell.h"
#define  PayOrderMoneyInPutTableViewCell_Identifier    @"PayOrderMoneyInPutTableViewCell"

#import "LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel.h"

@interface LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc () <UITextFieldDelegate,PayOrderMoneyInPutTableViewCellDelegate>
@property (nonatomic,strong) NSString *saveNowMoneyNumStr;
@property (nonatomic,strong) LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel *nowSubPaymentItemModel;
@end

@implementation LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc
- (NSString *)saveNowMoneyNumStr{
    if (!_saveNowMoneyNumStr) {
        _saveNowMoneyNumStr = @"";
    }
    return _saveNowMoneyNumStr;
}
//预交等数据
- (void)initData{
    self.oneSectionTitleArr = [[NSMutableArray alloc]initWithObjects:@"缴费单位",@"固话号码", nil];
    self.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
    [self.tableView reloadData];
    //直缴 详情数据
    WEAKSELF
    //主页列表 点击来的数据 ｜     //新增缴费 点击来的数据

    NSString *typeIdStr = [TextShowWithModelStr textShowWithNotNullStr:self.mianVcGroupListSubOrderModel.typeId];
    NSString *accountStr = [TextShowWithModelStr textShowWithNotNullStr:self.mianVcGroupListSubOrderModel.account];
    NSString *itemIdStr = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.itemId];
    NSString *imgURLStr = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.typePicUrl];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.topView fillTopViewDataWithImgUrlStr:imgURLStr withMoneyNumStr:@"暂无"];
    });
    [LifeCostData lifeCostGetWillPayOrderDetailWithPayTypeId:typeIdStr withPhotoNumStr:accountStr withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {//    message = "第三方查询失败!";
        if (success) {
            NSDictionary *getMobileRechargeModelDic =  [[dic allKeys]containsObject:@"mobileRechargeModel"] ?  [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"mobileRechargeModel"]] : @{};
            NSString *mobileStr = [[getMobileRechargeModelDic allKeys]containsObject:@"mobile"] ? [NSString stringWithFormat:@"%@",[getMobileRechargeModelDic objectForKey:@"mobile"]] : accountStr;
            NSArray *paymentItemModelList = [[getMobileRechargeModelDic allKeys]containsObject:@"paymentItemModelList"] ? [NSArray arrayWithArray:[getMobileRechargeModelDic objectForKey:@"paymentItemModelList"]] : @[];
            NSArray *getPayMentMoedlArrs =  [LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel mj_objectArrayWithKeyValuesArray:paymentItemModelList];
            if (getPayMentMoedlArrs.count == 0 ) {
                [weakSelf fillDataWithPhotoStr:mobileStr withModel:nil];
            }else if (getPayMentMoedlArrs.count ==1 ){
                LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel *payMentItemModel = getPayMentMoedlArrs.firstObject;
                if ([payMentItemModel.paymentItemId isEqual:itemIdStr]) {
                    [weakSelf fillDataWithPhotoStr:mobileStr withModel:payMentItemModel];
                }
            }else{
                for (int i = 0; i <getPayMentMoedlArrs.count; i++) {
                    LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel *payMentItemModel = getPayMentMoedlArrs[i];
                    if ([payMentItemModel.paymentItemId isEqual:itemIdStr]) {
                        [weakSelf fillDataWithPhotoStr:mobileStr  withModel:payMentItemModel];
                    }
                }
            }
        }
    }];
}
- (void)fillDataWithPhotoStr:(NSString *)phoneStr withModel:(LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel *)payMentItemModel{
    WEAKSELF
    if (isNotNil(payMentItemModel)) {
        self.nowSubPaymentItemModel = payMentItemModel;
    }
    NSString *companyStr = [TextShowWithModelStr textShowWithNotNullStr:payMentItemModel.companyName];    //
    if (companyStr.length<=0) {
        companyStr = @"暂无详情";
    }
    weakSelf.onwSectionDataArr = [[NSMutableArray alloc]initWithObjects:companyStr,phoneStr, nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];

    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.oneSectionTitleArr.count;
    }else{
        return 1;
    }
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    }else{
        PayOrderMoneyInPutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PayOrderMoneyInPutTableViewCell_Identifier];
        if (!cell) {
            cell = [[PayOrderMoneyInPutTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PayOrderMoneyInPutTableViewCell_Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textField.delegate = self;
            cell.delegate = self;
        }
        cell.textField.text = self.saveNowMoneyNumStr;
        return cell;
    }
 
}

#pragma mark === UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    BOOL isHaveDian = YES;
    if ([self.saveNowMoneyNumStr rangeOfString:@"."].location==NSNotFound) {
        isHaveDian=NO;
    }
    if ([string length]>0)
    {
        unichar single=[string characterAtIndex:0];//当前输入的字符
        if ((single >='0' && single<='9') || single=='.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([self.saveNowMoneyNumStr length]==0){
                if(single == '.'){
                   [self alertView:@"亲，第一个数字不能为小数点"];
                    [self.saveNowMoneyNumStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
                if (single == '0') {
                    [self alertView:@"亲，第一个数字不能为0"];
                    [self.saveNowMoneyNumStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;

                }
            }
            if (single=='.')
            {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian=YES;
                    return YES;
                }else
                {
                    [self alertView:@"亲，您已经输入过小数点了"];
                    [self.saveNowMoneyNumStr stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran=[self.saveNowMoneyNumStr rangeOfString:@"."];
                    NSUInteger tt=range.location-ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        [self alertView:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self alertView:@"亲，您输入的格式不正确"];
            [self.saveNowMoneyNumStr stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
    
    return YES;
}
- (void)alertView:(NSString *)str{ 
    Y_SVP_SHOW_INFO_MES(str);
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.saveNowMoneyNumStr = textField.text;

}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    self.saveNowMoneyNumStr = textField.text;
}

#pragma mark == btns delegate
- (void)touchMoneyNumBtnWithMoneyStr:(NSString *)moneyStr{
    NSLog(@"moneyStr = %@",moneyStr);
    self.saveNowMoneyNumStr = moneyStr;
    [self.tableView reloadData];
    
}
#pragma mark == 立即缴费
- (void)footerBtnAction{
    WEAKSELF
    
    DLog(@"立即缴费");
    if (isNil(self.nowSubPaymentItemModel)) {
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
    NSString *typeId = [TextShowWithModelStr textShowWithModelStr: self.mianVcGroupListSubOrderModel.typeId ];
    NSString *itemId = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.itemId ];
    NSString *itemCode = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.itemCode];
    NSString *billKey = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.account];
    NSString *payAmount = [TextShowWithModelStr textShowWithModelStr:self.saveNowMoneyNumStr];
    NSString *deviceType = @"2";
    NSString *idStr = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.idStr];
    //    NSString *queryAcqSsn = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.queryAcqSsn];
    //    NSString *customerName = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.customerName];
    //    NSString *contactNo = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.contactNo];
    //    NSString *balance = [TextShowWithModelStr textShowWithModelStr:self.mianVcGroupListSubOrderModel.balance];
    //必需的键值
    [parms setValue:typeId     forKey:@"typeId"];
    [parms setValue:itemId     forKey:@"itemId"];
    [parms setValue:itemCode   forKey:@"itemCode"];
    [parms setValue:billKey    forKey:@"billKey"];
    [parms setValue:payAmount  forKey:@"payAmount"];
    [parms setValue:deviceType forKey:@"deviceType"];
    //
    [parms setValue:@"1"                   forKey:@"type"];//手机充值该字段必传1。
    [parms setValue:payAmount              forKey:@"billAmount"];
 
     
    
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
