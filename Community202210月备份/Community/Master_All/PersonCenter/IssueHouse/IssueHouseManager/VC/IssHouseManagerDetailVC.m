//
//  IssHouseAppmentManagerDetailVC.m
//  Community
//
//  Created by 余莹 on 2021/4/2.
//

#import "IssHouseManagerDetailVC.h"
#import "IssueManagerViewModel.h"
@interface IssHouseManagerDetailVC ()

@end

@implementation IssHouseManagerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
     
}
- (void)delDownBtnAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否下架本条发布" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"不下架" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"确认下架" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self chooseDownHouseAction];
    }];
    [alertController addAction:alertActionCancel];
    [alertController addAction:alertActionOk];
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
   
    
}
- (void)chooseDownHouseAction{
    
    //下架
    WEAKSELF
    [IssueManagerViewModel deletDownHouseWithId:self.IDNum withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已成功下架了这条发布");
                [weakSelf popVC];
            });
        }
    }];
}
 
- (void)editBtnAction{
        NSString *modeeStr = [TextShowWithModelStr textShowWithModelStr:self.houseModel.houseLeaseMode];
        HouseAllTypeBaseIssueVc *vc = [[HouseAllTypeBaseIssueVc alloc]init];
     
//    self.houseModel.id//用于修改发布 和self.id 一个值
    vc.editUseRentHouseId = self.IDNum;
    vc.editUseModel = self.houseModel;//add用的model 和 详情页展示用的model不一样；
 
    NSLog(@"editUseRentHouseId    __________  \n  %ld \n  %ld",self.IDNum ,(long)self.houseModel.ID);
        if ( [modeeStr isEqualToString:@"整租"] ) {
            vc.type = IssueHouse_Type_ZhengZu;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([modeeStr isEqualToString:@"合租"]) {
            vc.type = IssueHouse_Type_HeZu;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([modeeStr isEqualToString:@"单间"]) {
            vc.type = IssueHouse_Type_DanJian;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //___
        if ([modeeStr isEqualToString:@"不限"]) {//整租
            vc.type = IssueHouse_Type_ZhengZu;
            [self.navigationController pushViewController:vc animated:YES];
        }
}

//被用于子类 房屋管理 编辑下架cell
- (UITableViewCell *)tableView:(UITableView *)tableView managerVcLastcellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    IssHouseManagerDetailVcLastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IssHouseManagerDetailVcLastTableViewCell"];
    if (!cell) {
        cell = [[IssHouseManagerDetailVcLastTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"IssHouseManagerDetailVcLastTableViewCell"];
    }
    [cell.delRentBtn addTarget:self action:@selector(delDownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [cell.editRentBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
@end

#pragma mark ========

@implementation IssHouseManagerDetailVcLastTableViewCell
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
