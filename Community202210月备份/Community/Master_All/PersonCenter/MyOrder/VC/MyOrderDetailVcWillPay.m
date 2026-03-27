//
//  MyOrderDetailVcWillPay.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderDetailVcWillPay.h"

@interface MyOrderDetailVcWillPay ()<MyOrderDetailVcTopBtnsTableViewCellDelegate>

@end

@implementation MyOrderDetailVcWillPay

- (void)viewDidLoad {
    self.listType = MyOrderListCell_Type_WillPay;
    [super viewDidLoad];
    [self initData];
}
 
- (void)initData{
   
}
#pragma mark - Table view data source
//
- (UITableViewCell *)tableView:(UITableView *)tableView topInfoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyOrderDetailVcBaseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcBaseTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcBaseTextTableViewCell_Identifier];
        }
        cell.topTitleL.text = @"剩余13:33 请尽快支付";
        cell.detailL.text = @"商家配送";
        return cell;
    }else{
        MyOrderDetailVcTopBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcTopBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        }
        cell.delegate = self;
        [cell fillBtnsWithArr:@[@"取消订单",@"立即支付",@"联系商家"].mutableCopy andImgNameArr:@[@"Tobepaid_cancellationoforder",@"Tobepaid_Payimmediately",@"Tobepaid_Contactthemerchant"].mutableCopy whitType:MyOrderListCell_Type_WillPay];
        return cell;
    }
}

#pragma mark == MyOrderDetailVcTopBtnsTableViewCell delegate
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index{
    DLog(@"");
    if (index==0) {
        DLog(@"取消订单");
    }else if (index==1){
        DLog(@"立即支付");
    }else{
        DLog(@"联系商家");
    }
    /**
     MyOrderListCell_Type_WillPay,
     MyOrderListCell_Type_WillUse,
     MyOrderListCell_Type_WillEvaluation,
     MyOrderListCell_Type_EndDeal,
     MyOrderListCell_Type_IsCancel,//取消状态*/
}
@end
