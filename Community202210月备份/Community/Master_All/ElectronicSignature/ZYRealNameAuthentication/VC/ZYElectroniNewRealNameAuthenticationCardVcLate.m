//
//  ZYElectroniNewRealNameAuthenticationCardVcLate.m
//  Community
//
//  Created by 余莹 on 2022/4/29.
//

#import "ZYElectroniNewRealNameAuthenticationCardVcLate.h"

 
   

#import "ZYElectroniNewRealNameAuthenticationCardVc.h"
//cell
#import "ZYElectroniNewRealNameAuthTextFieldTableViewCell.h"
#define  ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier   @"ZYElectroniNewRealNameAuthTextFieldTableViewCell"
#import "ZYElectroniNewRealNameAuthIdCardTableViewCell.h"
#define  ElectroniNewRealNameAuthIdCardTableViewCell_Identifier   @"ZYElectroniNewRealNameAuthIdCardTableViewCell"
//view
#import "ZYElectroniNewRealNameAuthSectionOneHeaderView.h" //组header
//vc
#import "ZYElectroniNewRealNameAuthenticationFaceVc.h"
#import "ZYElectroniNewRealNameAuthenticationSuccessVc.h"
//data
#import "ZYRealNameAuthenticationCardData.h"
#import "ZYRealNameAuthenticationViewModel.h"

#define  Height_TextCell     80
#define  cellRow_name         0
#define  cellRow_cardId       1
 
#define  Height_SectionFooter    200

typedef enum : NSUInteger {
    Photo_mode_Type_Grapht,
    Photo_mode_Type_Album
} Photo_mode_Type;

//
@interface ZYElectroniNewRealNameAuthenticationCardVcLate () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *TextFieldTitleArr;
@property (nonatomic,strong) NSMutableArray *cellTextFieldContentArr;
@property (nonatomic,assign) UserCard_Type cardType;
@property (nonatomic,assign) BOOL isOneImgSending;
@property (nonatomic,strong) UIImage *saveFaceImg;//正面存
@property (nonatomic,strong) UIImage *saveBackImg;//背面存
@end

@implementation ZYElectroniNewRealNameAuthenticationCardVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self initView];
    [self initData];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteTextColorWithBackViewCustomColor:Color_38BlueColor];
    self.title = @"实名认证";
}
#pragma mark ==

/**
 //20220429改版
 */
- (void)initData{
    ////self.cellTextFieldContentArr = [[NSMutableArray alloc]initWithObjects:@"姓  名",@"身份证", nil];
    [self.tableView reloadData];
}
- (void)nextAction{
    WEAKSELF
    NSString *cerNo = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_cardId]];
    NSString *cerName = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_name]];
    

    if (cerNo.length==0 || cerName.length==0) {
        Y_SVP_SHOW_ERR_MES(@"缺少个人信息!");
        return;
    }
   
    if (cerNo.length == 15 || cerNo.length ==18 ) {
        //身份证号是18位数，第一代身份证是15位数。
    }else{
        Y_SVP_SHOW_ERR_MES(@"身份证格式有误！");
        return;
    }
    
    Y_SVP_SHOW_MES_IsDealing_15Delay;
    [[ZYRealNameAuthenticationViewModel realNameAuthenticationViewModelShare] sendCerNo:cerNo andCerName:cerName andCerDetailAddress:@"" withUiVc:self withDicBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS;
        if (success) {
            //采集人脸 redic全传来
            NSMutableDictionary *willSendToRealNameDic = [[NSMutableDictionary alloc]initWithCapacity:0];
            if ([[dic allKeys]containsObject:@"data"]) {
                willSendToRealNameDic =  ( [[dic allKeys] containsObject:@"data"] && isNotNil([dic objectForKey:@"data"]) ) ? [dic objectForKey:@"data"] : [NSDictionary dictionary];

            }else{
                willSendToRealNameDic = [NSMutableDictionary dictionaryWithDictionary:dic];

            }
             dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf goFaceVcWithDic:willSendToRealNameDic];
            });
        }else{
            Y_SVP_SHOW_ERR_MES(@"实名失败");
        }
    }];
}
- (void)goFaceVcWithDic:(NSDictionary *)dic{
    NSString *cerAddress = @"";// [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_cardAddress]];
    //
    NSString *willFaceJsonStr = @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    willFaceJsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //_________
    ZYElectroniNewRealNameAuthenticationFaceVc *vc = [[ZYElectroniNewRealNameAuthenticationFaceVc alloc]init];
    vc.realName = [NSString stringWithFormat:@"%@",self.cellTextFieldContentArr[cellRow_name]];
    vc.cerAddress = cerAddress;
    vc.getCerJsonStr =  willFaceJsonStr;
    [self pushVc:vc];
}
 
#pragma mark ==
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
    hV.backgroundColor =  Y_ColorWith16FromRGB(0xF0F1F6);
    return hV;
}
////200的h
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return Height_SectionFooter;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *wV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 200)];
//    wV.backgroundColor = [UIColor whiteColor];
//    return wV;
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Height_TextCell;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZYElectroniNewRealNameAuthTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier];
    if (!cell) {
        cell = [[ZYElectroniNewRealNameAuthTextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectroniNewRealNameAuthTextFieldTableViewCell_Identifier];
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 16);
        cell.textField.delegate = self;
    }
    cell.titleL.text = self.TextFieldTitleArr[indexPath.row];
    cell.textField.text = self.cellTextFieldContentArr[indexPath.row];
    cell.textField.tag = indexPath.row+600;
     if (indexPath.row == cellRow_cardId) {
        cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;//指定数字和标点符号键盘。
    }else{
        cell.textField.keyboardType = UIKeyboardTypeDefault;

    }
    return cell;
}
#pragma  mark ==
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag - 600 == cellRow_name) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_name withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
    if (textField.tag - 600 == cellRow_cardId) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardId withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
}
- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if (textField.tag - 600 == cellRow_name) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_name withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
    if (textField.tag - 600 == cellRow_cardId) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardId withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag - 600 == cellRow_name) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_name withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
    if (textField.tag - 600 == cellRow_cardId) {
        [self.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardId withObject:[TextShowWithModelStr textShowWithModelStr:textField.text]];
    }
}
 
#pragma mark==
- (void)initView{
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
 
- (ZYElectroniRealNameAuthenticationBaseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZYElectroniRealNameAuthenticationBaseHeaderView alloc]initWithFrame:CGRectZero];
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

        _TextFieldTitleArr = [[NSMutableArray alloc]initWithObjects:@"姓  名",@"身份证号 ", nil];
    }
    return _TextFieldTitleArr;
}
- (NSMutableArray *)cellTextFieldContentArr{
    if (!_cellTextFieldContentArr) {
        _cellTextFieldContentArr = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
    }
    return _cellTextFieldContentArr;
}
#pragma mark == 证件图片数据
- (void)imgSendActionWithImg:(UIImage*)img type:(UserCard_Type)type{
    self.isOneImgSending = YES;
    WEAKSELF
    [ZYRealNameAuthenticationCardData getUserInfoWithImg:img withType:type withModelBlock:^(RealNameAuthenticationCardModel * model, BOOL success) {
        weakSelf.isOneImgSending = NO;//结束一个图的处理
        Y_SVP_DISMISS
            if (success) {
                if (weakSelf.cardType==UserCard_Type_face) {
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_name withObject:[TextShowWithModelStr textShowWithModelStr:model.name]];
                    [weakSelf.cellTextFieldContentArr replaceObjectAtIndex:cellRow_cardId withObject:[TextShowWithModelStr textShowWithModelStr:model.num]];
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
      
    }];
}
 
 
#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick

- (void)chooseImageWithType:(Photo_mode_Type)type {
    
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.delegate = self;
    if (type == Photo_mode_Type_Grapht) {
        
        pickVC.allowsEditing = NO;
        pickVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        
        pickVC.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
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
