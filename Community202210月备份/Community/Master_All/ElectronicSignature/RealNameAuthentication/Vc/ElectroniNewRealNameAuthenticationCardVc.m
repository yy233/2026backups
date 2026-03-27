//
//  ElectroniNewRealNameAuthenticationVc.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
// 实名认证 共用页

#import "ElectroniNewRealNameAuthenticationCardVc.h"
//cell
#import "ElectroniNewRealNameAuthTextFieldTableViewCell.h"
#define  ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier   @"ElectroniNewRealNameAuthTextFieldTableViewCell"
#import "ElectroniNewRealNameAuthIdCardTableViewCell.h"
#define  ElectroniNewRealNameAuthIdCardTableViewCell_Identifier   @"ElectroniNewRealNameAuthIdCardTableViewCell"
//view
#import "ElectroniNewRealNameAuthSectionOneHeaderView.h" //组header
//vc
#import "ElectroniNewRealNameAuthenticationFaceVc.h"
#import "ElectroniNewRealNameAuthenticationSuccessVc.h"
//data
#import "RealNameAuthenticationCardData.h"
#import "RealNameAuthenticationViewModel.h"

#define  Height_IdCardCell   130
#define  Height_TextCell     80

#define  cellRow_nationality  0
#define  cellRow_name         1
#define  cellRow_gender       2
#define  cellRow_cardT        3
#define  cellRow_cardId       4
#define  cellRow_cardAddress  5

//
@interface ElectroniNewRealNameAuthenticationCardVc () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
//@property (nonatomic,strong) UIImageView *headerView;
//@property (nonatomic,strong) ElectronicSignatureBaseFooterView *footerView;

@property (nonatomic,strong) NSMutableArray *TextFieldTitleArr;
@property (nonatomic,strong) NSMutableArray *cellTextFieldContentArr;
@property (nonatomic,assign) UserCard_Type cardType;
@property (nonatomic,assign) BOOL isOneImgSending;
@property (nonatomic,strong) UIImage *saveFaceImg;//正面存
@property (nonatomic,strong) UIImage *saveBackImg;//背面存
@end

@implementation ElectroniNewRealNameAuthenticationCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self initView];
    [self upThisSectionHeadrviewNotMoveWithChangeTableView];
    [self initData];
}
- (void)upThisSectionHeadrviewNotMoveWithChangeTableView{
     //导致刷新无效 新alloc了tableView
//     self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_38BlueColor];
    self.title = @"实名认证";
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarTransparentStyle];
}
#pragma mark ==
- (void)initData{
    self.cellTextFieldContentArr = [[NSMutableArray alloc]initWithObjects:@"中国",@"",@"",@"身份证",@"",@"",  nil];
    [self.tableView reloadData];
}
- (void)nextAction{
    
    NSString *cerNo = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_cardId]];
    NSString *cerName = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_name]];
    NSString *cerAddress = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_cardAddress]];
    
    if (cerNo.length==0 || cerName.length==0 || cerAddress.length==0) {
        Y_SVP_SHOW_ERR_MES(@"缺少个人信息!");
        return;
    }
    
    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [[RealNameAuthenticationViewModel realNameAuthenticationViewModelShare] sendCerNo:cerNo andCerName:cerName andCerDetailAddress:cerAddress withUiVc:self withDicBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS;
        if (success) {
            //采集人脸
            dispatch_async(dispatch_get_main_queue(), ^{
                [self goFaceVcWithDic:dic];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"实名失败");
        }
    }];
}
- (void)goFaceVcWithDic:(NSDictionary *)dic{
    NSString *cerAddress = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_cardAddress]];
    //
    NSString *willFaceJsonStr =  @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    willFaceJsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //_________
    ElectroniNewRealNameAuthenticationFaceVc *vc = [[ElectroniNewRealNameAuthenticationFaceVc alloc]init];
    vc.cerAddress = cerAddress;
    vc.getCerJsonStr =  willFaceJsonStr;
    [self pushVc:vc];
}
 
#pragma mark ==
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        //有图在处理状态
        if (self.isOneImgSending) {
            Y_SVP_SHOW_ERR_MES(@"图片处理中,其他图片请稍后提交");
            return;
        }else{
            //非处理状态
            if (indexPath.row==0) {
                self.cardType = UserCard_Type_face;
            }else{
                self.cardType = UserCard_Type_back;
            }
            //图片拍摄or选择
            [self chooseImage];
        }
       
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return self.cellTextFieldContentArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 80;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    SectionHeaderViewWithTextLabel *v = [[SectionHeaderViewWithTextLabel alloc]init];
//    v.titleLabel.textColor =  Y_RGBA(136, 136, 136, 1);
//    v.titleLabel.font = [UIFont systemFontOfSize:15];
//    v.titleLabel.text = self.sectionTitleArr[section];
    if (section==0) {
        ElectroniNewRealNameAuthSectionOneHeaderView *sectionOneheaderView = [[ElectroniNewRealNameAuthSectionOneHeaderView alloc]initWithFrame:CGRectZero];
        return sectionOneheaderView;
    }else{
        return [UIView new];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return Height_IdCardCell;
    }else{
        return Height_TextCell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ElectroniNewRealNameAuthIdCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthIdCardTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectroniNewRealNameAuthIdCardTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthIdCardTableViewCell_Identifier];
            cell.separatorInset = UIEdgeInsetsMake(0, Screen_W, 0, 0);
        }
        if (indexPath.row==0) {
            if (isNotNil(self.saveFaceImg)) {
                [cell setTextAndImgWithZhengMianWithImg:self.saveFaceImg];
            }else{
                [cell setTextAndImgWithZhengMianWithImg:[UIImage imageNamed:@"zmd"]];
            }
            //正面
        }else{
            if (isNotNil(self.saveBackImg)) {
                [cell setTextAndImgWithFanMianWithImg:self.saveBackImg];
            }else{
                [cell setTextAndImgWithFanMianWithImg:[UIImage imageNamed:@"fmd"]];
            }
            //反面
        }
        return cell;
    }else{
        ElectroniNewRealNameAuthTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier];
        if (!cell) {
            cell = [[ElectroniNewRealNameAuthTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier];
            cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        }
        cell.titleL.text = self.TextFieldTitleArr[indexPath.row];
        cell.textField.text = self.cellTextFieldContentArr[indexPath.row];
        return cell;
    }
}
 
#pragma mark==
- (void)initView{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(-KNavBarHeight, 0, 0, 0));
        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 0.1;
}

#pragma mark ==
- (UITableView *)tableView{
   if (!_tableView) {
       _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.tableFooterView = [UIView new];
       _tableView.backgroundColor = Color_245Gray;
       [self.view addSubview:_tableView];
   }
   return _tableView;
}
 
//- (ElectronicSignatureBaseFooterView *)footerView{
//    if (!_footerView) {
//        _footerView  = [[ElectronicSignatureBaseFooterView alloc]initWithFrame:CGRectZero];
//        [_footerView.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        [_footerView.footerBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
//        _footerView.backgroundColor = [UIColor whiteColor];
//    }
//    return _footerView;
//}
//- (UIImageView *)headerView{
//    if (!_headerView) {
//        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 115)];
//        _headerView.image = [UIImage imageNamed:@"rz"];
//    }
//    return _headerView;
//}
//更20200224改
- (ElectroniRealNameAuthenticationBaseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ElectroniRealNameAuthenticationBaseHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.footerBtn.layer.cornerRadius = 22;
    }
    return _footerView;
}
- (NSMutableArray *)TextFieldTitleArr{
    if (!_TextFieldTitleArr) {
        _TextFieldTitleArr = [[NSMutableArray alloc]initWithObjects:@"国籍",@"真实姓名",@"性别",@"证件类型",@"身份证号码",@"身份证地址", nil];
    }
    return _TextFieldTitleArr;
}
- (NSMutableArray *)cellTextFieldContentArr{
    if (!_cellTextFieldContentArr) {
        _cellTextFieldContentArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"", nil];
    }
    return _cellTextFieldContentArr;
}
#pragma mark == 证件图片数据
- (void)imgSendActionWithImg:(UIImage*)img type:(UserCard_Type)type{
    self.isOneImgSending = YES;
    WEAKSELF
    [RealNameAuthenticationCardData getUserInfoWithImg:img withType:type withModelBlock:^(RealNameAuthenticationCardModel * model, BOOL success) {
        weakSelf.isOneImgSending = NO;//结束一个图的处理
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Y_SVP_DISMISS
            if (success) {
                if (weakSelf.cardType==UserCard_Type_face) {
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_name withObject:[TextShowWithModelStr textShowWithModelStr:model.name]];
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_gender withObject:[TextShowWithModelStr textShowWithModelStr:model.sex]];
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardId withObject:[TextShowWithModelStr textShowWithModelStr:model.num]];
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardAddress withObject:[TextShowWithModelStr textShowWithModelStr:model.address]];
                    //正面
                    weakSelf.saveFaceImg = img;
                    
                }else{
                    //背面
                    weakSelf.saveBackImg = img;
                }
                //国籍
                [self.tableView reloadData];
                [self.tableView layoutIfNeeded];
                dispatch_async(dispatch_get_main_queue(), ^{
                 
                    [UIView performWithoutAnimation:^{
                        [weakSelf.tableView reloadData];
                        [weakSelf.tableView layoutIfNeeded];
                    }];
                });
            }
          
//        });
      
    }];
}
 
 
#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick

- (void)chooseImage {
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickVC.delegate = self;
    pickVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:pickVC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate 图片 回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    [self imgSendActionWithImg:photo type:self.cardType];
}
@end
