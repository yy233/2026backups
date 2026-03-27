//
//  MyOrderDetailVcEndDeal.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "MyOrderDetailVcEndDeal.h"

@interface MyOrderDetailVcEndDeal () <MyOrderDetailVcTopBtnsTableViewCellDelegate>

@end

@implementation MyOrderDetailVcEndDeal
 
- (void)viewDidLoad {
//    self.listType = MyOrderListCell_Type_EndDeal;
    self.listType = MyOrderListCell_Type_WillEvaluation; 
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
        cell.topTitleL.text = @"感谢您对未来物服的信任，期待再次光临";
        cell.detailL.text = @"";
        return cell;
    }else{
        MyOrderDetailVcTopBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderDetailVcTopBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderDetailVcTopBtnsTableViewCell_Identifier];
        }
        cell.delegate = self;
//        [cell fillBtnsWithArr:@[@"致电商家",@"再来一单"].mutableCopy andImgNameArr:@[@"Completed_Call",@"Cancelled_Onemoreorder"].mutableCopy whitType:MyOrderListCell_Type_EndDeal];
        [cell fillBtnsWithArr:@[@"致电商家",@"再来一单"].mutableCopy andImgNameArr:@[@"Completed_Call",@"Cancelled_Onemoreorder"].mutableCopy whitType:MyOrderListCell_Type_WillEvaluation];

        return cell;
    }
}

#pragma mark == MyOrderDetailVcTopBtnsTableViewCell delegate
- (void)topBtncellType:(MyOrderListCell_Type)type subBtnTouchBtnIndex:(NSInteger)index{
    DLog(@"");
    if (index==0) {
        DLog(@"致电商家");
        [MyOrderCallShopTool callShopWithOrderModel:self.orderModel];
    }else if (index==1){
        DLog(@"再来一单");
    }else{
        DLog(@"");
    }
}
@end
