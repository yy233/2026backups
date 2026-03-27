//
//  IssBuniessShopAppmentManagerDetailVC.m
//  Community
//
//  Created by 余莹 on 2021/4/2.
//

#import "IssBuniessShopManagerDetailVC.h"
#import "ShopBuniessIssueVc.h"
#import "IssueManagerViewModel.h"
@interface IssBuniessShopManagerDetailVC ()

@end

@implementation IssBuniessShopManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)delDownBtnAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否下架本条发布" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"不下架" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"确认下架" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self chooseDownBuniessAction];
    }];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOk];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
   
    
}
- (void)chooseDownBuniessAction{

    //下架
    WEAKSELF
    [IssueManagerViewModel deletDownBuniessShopWithId:self.IDNum withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已成功取消了这条发布");
                [weakSelf popVC];
            });
     
        }
    }];
}

- (void)editBtnAction{
    ShopBuniessIssueVc *vc = [[ShopBuniessIssueVc alloc]init];
    vc.isEditType = YES;
    vc.editUseBuniessShopId = self.IDNum; 
    [self pushVc:vc];
}

//用于子类
- (UITableViewCell *)tableView:(UITableView *)tableView managerVcLastcellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    IssBuniessShopManagerDetailVcLastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssBuniessShopManagerDetailVcLastTableViewCell"];
    if (!cell) {
        cell = [[IssBuniessShopManagerDetailVcLastTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IssBuniessShopManagerDetailVcLastTableViewCell"];
    }
    [cell.delRentBtn addTarget:self action:@selector(delDownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.editRentBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
@end

#pragma mark ========

@implementation IssBuniessShopManagerDetailVcLastTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.delRentBtn];
        [self.contentView addSubview:self.editRentBtn];
        [_delRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_delRentBtn.superview);
            make.right.equalTo(_delRentBtn.superview.mas_centerX);
        }];
        [_editRentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editRentBtn.superview);
            make.left.equalTo(_delRentBtn.mas_right);
        }];
    }
    return self;
}
- (UIButton *)delRentBtn{
    if (!_delRentBtn) {
        _delRentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delRentBtn newAnBtnWithTextStr:@"取消发布"];
        [_delRentBtn newAnBtnWithBackColor:[UIColor whiteColor]];
        [_delRentBtn newAnBtnWithTextColor:Color_153GrayColor];
        [_delRentBtn newAnBtnWithFont:[UIFont systemFontOfSize:16]];
    }
    return _delRentBtn;
}
- (UIButton *)editRentBtn{
    if (!_editRentBtn) {
        _editRentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editRentBtn newAnBtnWithTextStr:@"修改"];
        [_editRentBtn newAnBtnWithBackColor:Color_38BlueColor];
        [_editRentBtn newAnBtnWithTextColor:[UIColor whiteColor]];
        [_editRentBtn newAnBtnWithFont:[UIFont systemFontOfSize:16]];
    }
    return _editRentBtn;
}
@end
