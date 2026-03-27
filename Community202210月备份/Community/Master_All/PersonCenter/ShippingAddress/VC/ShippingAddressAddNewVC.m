//
//  ShippingAddressAddNewVC.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "ShippingAddressAddNewVC.h"
#import "ShippingAddressTextFieldTableViewCell.h"
#import "ShippingAddressTitleAndBtnsTableViewCell.h"
#import "ShippingAddressTextFieldAndRightBtnTableViewCell.h"
#import "ShippingAddressLastDefineAddressSwichTableViewCell.h"
#define  ShippingAddressTextFieldTableViewCell_Identifier                         @"ShippingAddressTextFieldTableViewCell"
#define  ShippingAddressTitleAndBtnsTableViewCell_Identifier                      @"ShippingAddressTitleAndBtnsTableViewCell"
#define  ShippingAddressTextFieldAndRightBtnTableViewCell_Identifier              @"ShippingAddressTextFieldAndRightBtnTableViewCell"
#define  ShippingAddressLastDefineAddressSwichTableViewCell_Identifier            @"ShippingAddressLastDefineAddressSwichTableViewCell"


#define Tag_TextF   300
//
#define Row_Num_Name           0
#define Row_Num_Sex            1
#define Row_Num_Phone          2
#define Row_Num_Address        3
#define Row_Num_AddressDes     4
#define Row_Num_Tag            5
//
#import "ShippingAddressData.h"
//

@interface ShippingAddressAddNewVC () <ShippingAddressTitleAndBtnsTableViewCellDelegate,ShippingAddressTextFieldTableViewCellDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) ShippingAddressModel *selfAddOrEditModel;
@property (nonatomic,strong) NSMutableArray *arrOfContentText;
@end

@implementation ShippingAddressAddNewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selfAddOrEditModel = [[ShippingAddressModel alloc]init];
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"联系人",@"",@"电话", @"地址", @"门牌号", @"标签",  nil];//row2=title空
    self.arrOfContentText = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"", nil];
    if (self.isAddType) {
        self.title = @"新增地址";
    }else{
        self.title = @"编辑地址";
        self.selfAddOrEditModel.uuid = self.isEditWithAddressUuidStr;
    }
    [self initView];
    [self initData];
}

- (void)initView{
    self.view.backgroundColor = Color_245Gray;
    self.tableView.tableFooterView = self.footerView;
    self.footerView.footerBtn.backgroundColor =  Y_RGBA(246, 77, 69, 1);;
    self.tableView.scrollEnabled = NO;//按钮状态不做刷新
}
- (void)initData{
    if (!self.isAddType) {
        WEAKSELF
        [ShippingAddressData getUserAddressDetailWithUUID:self.isEditWithAddressUuidStr withDicBlock:^(NSDictionary * dic,  BOOL success) {
            if (success) {
                weakSelf.selfAddOrEditModel = [ShippingAddressModel mj_objectWithKeyValues:dic];
                [weakSelf editOrAddGetNewDataWillUpUI];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
    [self.tableView reloadData];
}

- (void)editOrAddGetNewDataWillUpUI{
    [self.arrOfContentText replaceObjectAtIndex:Row_Num_Name withObject:[TextShowWithModelStr textShowWithModelStr:self.selfAddOrEditModel.name]];
    [self.arrOfContentText replaceObjectAtIndex:Row_Num_Phone withObject:[TextShowWithModelStr textShowWithModelStr:self.selfAddOrEditModel.phone]];
    [self.arrOfContentText replaceObjectAtIndex:Row_Num_Address withObject:[TextShowWithModelStr textShowWithModelStr:self.selfAddOrEditModel.address]];
    [self.arrOfContentText replaceObjectAtIndex:Row_Num_AddressDes withObject:[TextShowWithModelStr textShowWithModelStr:self.selfAddOrEditModel.addressDescription]];
 }

- (void)footerSaveAction{
    if ( (self.selfAddOrEditModel.phone.length < 8) || (self.selfAddOrEditModel.phone.length > 11)) {
        Y_SVP_SHOW_ERR_MES(@"请输入正确的手机号！");
        return;
    }
    if (self.selfAddOrEditModel.name.length<=0 || self.selfAddOrEditModel.phone.length<=0 || self.selfAddOrEditModel.address.length<=0 || self.selfAddOrEditModel.addressDescription.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"信息未填写完全！");
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithDictionary:[self.selfAddOrEditModel mj_keyValues]];
    WEAKSELF
    
    if (self.isAddType) {
        [ShippingAddressData addUserAddressWithParms:parms withDicBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                NSString *msg = weakSelf.isAddType ? @"添加成功" : @"修改成功";
                Y_SVP_SHOW_SUCCESS_MES(msg);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popVC];
                });
            }
        }];
    }else{
        [ShippingAddressData editUserAddressWithParms:parms withDicBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                NSString *msg = weakSelf.isAddType ? @"添加成功" : @"修改成功";
                Y_SVP_SHOW_SUCCESS_MES(msg);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf popVC];
                });
            }
        }];
    }

}
#pragma mark ===

- (void)touchCellTypeIsBottomCellTipType:(BOOL)isBottomCell withSubBtnIndex:(NSInteger)index{
    if (isBottomCell) {//@[@"家",@"公司",@"学校",]
        
        if (index==0) {
            DLog(@"家");
            self.selfAddOrEditModel.tag = @"家";
        }else if (index==1){
            DLog(@"公司");
            self.selfAddOrEditModel.tag = @"公司";
        }else{
            DLog(@"学校");
            self.selfAddOrEditModel.tag = @"学校";
        }
    }else{
        if (index==0) {
            DLog(@"先生");
            self.selfAddOrEditModel.sex = 0;
        }else{
            DLog(@"女士");
            self.selfAddOrEditModel.sex = 1;
        }
    }
}
#pragma mark ==
- (void)getTextFieldTag:(NSInteger)tag withTextStrWithStr:(NSString *)str{
    switch (tag-Tag_TextF) {
        case 0://name
        {
            self.selfAddOrEditModel.name = str;
            
        }
            break;
        case 2://phone
        {
            self.selfAddOrEditModel.phone = str;
        }
            break;
        case 3://address
        {
            self.selfAddOrEditModel.address  = str;
        }
            break;
        case 4://door
        {
            self.selfAddOrEditModel.addressDescription = str;
        }
            break;
            
        default:
            break;
    }
    [self editOrAddGetNewDataWillUpUI];
}
#pragma mark --
- (void)changeSwitchWithisDefType:(UISwitch *)sender{
    self.selfAddOrEditModel.isdefult = sender.on==YES ? 1 : 0;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.dataSourceArr.count;
    }else{
        return 1;//ShippingAddressLastDefineAddressSwichTableViewCell
    }
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        ShippingAddressLastDefineAddressSwichTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShippingAddressLastDefineAddressSwichTableViewCell_Identifier];
        if (!cell) {
            cell = [[ShippingAddressLastDefineAddressSwichTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShippingAddressLastDefineAddressSwichTableViewCell_Identifier];
        }
        
        cell.defineSwitch.on = self.selfAddOrEditModel.isdefult==0?NO:YES;
        [cell.defineSwitch addTarget:self action:@selector(changeSwitchWithisDefType:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else{
        if (indexPath.row==0 || indexPath.row==4) {
            ShippingAddressTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShippingAddressTextFieldTableViewCell_Identifier];
            if (!cell) {
                cell = [[ShippingAddressTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShippingAddressTextFieldTableViewCell_Identifier];
            }
            cell.titleL.text = self.dataSourceArr[indexPath.row];
            if (indexPath.row==0) {
                cell.textField.placeholder = @"姓名";
            }else{
                cell.textField.placeholder = @"详细地址，如：16号楼5层501室";
            }
            cell.textField.tag = Tag_TextF + indexPath.row;
            cell.textFieldDelegate = self;
            cell.textField.text = self.arrOfContentText[indexPath.row];
            return cell;
        }else if (indexPath.row==2 || indexPath.row==3){
            ShippingAddressTextFieldAndRightBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShippingAddressTextFieldAndRightBtnTableViewCell_Identifier];
            if (!cell) {
                cell = [[ShippingAddressTextFieldAndRightBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShippingAddressTextFieldAndRightBtnTableViewCell_Identifier];
            }
            cell.titleL.text = self.dataSourceArr[indexPath.row];
            if (indexPath.row==2) {
                [cell.rightBtn  newAnBtnWithImg:[UIImage imageNamed:@"New_maillist"]];
                cell.textField.placeholder = @"手机号";
            }else{
                [cell.rightBtn  newAnBtnWithImg:[UIImage imageNamed:@"Address_arrow"]];
                cell.textField.placeholder = @"选择收货地址";
            }
            cell.textField.tag = Tag_TextF + indexPath.row;
            cell.textFieldDelegate = self;
            cell.textField.text = self.arrOfContentText[indexPath.row];
            return cell;
        }else{
            ShippingAddressTitleAndBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShippingAddressTitleAndBtnsTableViewCell_Identifier];
            if (!cell) {
                cell = [[ShippingAddressTitleAndBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ShippingAddressTitleAndBtnsTableViewCell_Identifier];
            }
            cell.titleL.text = self.dataSourceArr[indexPath.row];
            
            if (indexPath.row==1){
                [cell fillCellBtnsCellTypeIsBottomCellTipType:NO withTitleArr:@[@"先生",@"女士"].mutableCopy];
            }else {
                [cell fillCellBtnsCellTypeIsBottomCellTipType:YES withTitleArr:@[@"家",@"公司",@"学校",].mutableCopy];
            }
            if (!self.isAddType) {//编辑状态 有原始数据
                if (indexPath.row==1){
                     [cell showSelectedIndex:self.selfAddOrEditModel.sex];
                }else {
                     if ([self.selfAddOrEditModel.tag isEqualToString: @"家"]) {
                        [cell showSelectedIndex:0];
                    }else if ([self.selfAddOrEditModel.tag isEqualToString: @"公司"]){
                        [cell showSelectedIndex:1];
                    }else if ([self.selfAddOrEditModel.tag isEqualToString: @"学校"]){
                        [cell showSelectedIndex:2];
                    }else{
                    }
                }
            }
            cell.delegate = self;
          
            return cell;
        }
    }
    
}
 
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(footerSaveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

@end
