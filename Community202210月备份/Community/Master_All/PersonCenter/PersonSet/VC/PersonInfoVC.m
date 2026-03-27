//
//  PersonInfoVC.m
//  Community
//
//  Created by 刘久炼 on 2021/2/26.
//

#import "PersonInfoVC.h"
#import "PersonInfoPhotoCell.h"
#import "PersonInfoNormalCell.h"
#import "BRDatePickerView.h"


#import "ShippingAddressVC.h"
#import "NickNameEditVC.h"

//
#import "PersonInfoUseModel.h"

@interface PersonInfoVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSMutableArray *subArray;

@property(nonatomic, strong) NSString *selectedDate;

@end

static NSString *const photoCellID = @"PersonInfoPhotoCell";
static NSString *const normalCellID = @"PersonInfoNormalCell";

@implementation PersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
    [self setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
    
    [self initData];
}

- (void)initView{
    self.title = @"个人信息";
//    self.tableView.backgroundColor = Color_245Gray;
    [self.tableView registerClass:[PersonInfoPhotoCell class] forCellReuseIdentifier:photoCellID];
    [self.tableView registerClass:[PersonInfoNormalCell class] forCellReuseIdentifier:normalCellID];
//    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorColor = [ThemeManager shareManager].themeLineColor;
}
- (void)initData{
//    self.titleArray = [NSMutableArray arrayWithObjects:@"头像",@"昵称",@"生日",@"收货地址",nil];
//    self.subArray = [NSMutableArray arrayWithObjects:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl,[ShareUserInfo sharedUserInfo].userInfo.nickname, [ShareUserInfo sharedUserInfo].userInfo.birthdayTime,@"修改/添加",nil];
    self.titleArray = [NSMutableArray arrayWithObjects:@"头像",@"昵称",@"生日",nil];
    self.subArray = [NSMutableArray arrayWithObjects:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl,[ShareUserInfo sharedUserInfo].userInfo.nickname, [ShareUserInfo sharedUserInfo].userInfo.birthdayTime,nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //防止个人中心主页的数据没有时的加载
    WEAKSELF
    [PersonInfoViewModel getPersonUserInfoWithBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",dic);
                PersonInfoUseModel *getInfodel = [PersonInfoUseModel mj_objectWithKeyValues:dic];
                [ShareUserInfo sharedUserInfo].userInfo.nickname = [TextShowWithModelStr textShowWithModelStr:getInfodel.nickname];
                [ShareUserInfo sharedUserInfo].userInfo.avatarUrl = [TextShowWithModelStr textShowWithModelStr:getInfodel.avatarUrl];
                [ShareUserInfo sharedUserInfo].userInfo.birthdayTime = [TextShowWithModelStr textShowWithModelStr:getInfodel.birthdayTime];
                weakSelf.subArray = [NSMutableArray arrayWithObjects:[ShareUserInfo sharedUserInfo].userInfo.avatarUrl,[ShareUserInfo sharedUserInfo].userInfo.nickname, [ShareUserInfo sharedUserInfo].userInfo.birthdayTime,nil];
                [weakSelf.tableView reloadData];
            });
            
        }
    }];
}
#pragma mark ==
 


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        PersonInfoPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[PersonInfoPhotoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:photoCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        if ([ShareUserInfo sharedUserInfo].userInfo.avatarUrl.length>0 || [NSString stringWithString:self.subArray[indexPath.row]].length>0 ) {
            cell.img = self.subArray[indexPath.row];
        }
        return cell;
    }else{
        PersonInfoNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
        if (!cell) {
            cell = [[PersonInfoNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellID];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title = self.titleArray[indexPath.row];
        cell.sub = self.subArray[indexPath.row];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //头像
        [self iconImgTap];
    }else if (indexPath.row == 1){
        NickNameEditVC *vc = [[NickNameEditVC alloc] init];
        [self pushVc: vc];
    }else if (indexPath.row == 2){
        // 1.创建日期选择器
        BRDatePickerView *datePickerView = [[BRDatePickerView alloc]init];
        // 2.设置属性
        datePickerView.pickerMode = BRDatePickerModeYMD;
        datePickerView.title = @"请选择日期";
        if ([ShareUserInfo sharedUserInfo].userInfo.birthdayTime.length>=0) {//存在生日
            datePickerView.selectValue = self.subArray[2];
        }
        datePickerView.maxDate = [NSDate date];
        datePickerView.isAutoSelect = NO;
//        kWeakSelf(self)
//        datePickerView.resultBlock = ^(NSDate *selectDate, NSString *selectValue) {
////            NSLog(@"选择的值：%@", selectValue);
//            kStrongSelf(self)
//            [self.subArray replaceObjectAtIndex:2 withObject:selectValue];
//            [self.tableView reloadData];
//        };
        // 设置自定义样式
        BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
        customStyle.pickerColor = [UIColor whiteColor];
        customStyle.pickerTextColor = [Tool getColorWithHexString:@"#999999"];
        customStyle.selectRowTextColor = [Tool getColorWithHexString:@"#333333"];
        customStyle.separatorColor = [Tool getColorWithHexString:@"#DDDDDD"];
        customStyle.language = @"zh-Hans";
        customStyle.doneBtnTitle = @"完成";
        customStyle.doneTextColor = [Tool getColorWithHexString:@"#2672F9"];
        customStyle.cancelTextColor = [Tool getColorWithHexString:@"#999999"];
        customStyle.titleTextColor = [Tool getColorWithHexString:@"#333333"];
        datePickerView.pickerStyle = customStyle;
        WEAKSELF
        datePickerView.resultBlock = ^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
            [weakSelf changeBirdTimeWithStr:selectValue];
        };

        // 3.显示
        [datePickerView show];
    }
//    else if (indexPath.row == 3){
//        //收货地址
//        ShippingAddressVC *vc = [[ShippingAddressVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//        
//    }
}
- (void)changeBirdTimeWithStr:(NSString *)selectValueStr{
    WEAKSELF
    [PersonInfoViewModel changePersonBirthdayTimeNameWithStr:selectValueStr withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"成功更改生日");
            [ShareUserInfo sharedUserInfo].userInfo.birthdayTime = selectValueStr;
            Y_NSNotificationCenter_PostNotice_NilObject_Name(PersonInfo_Change_Notice);
            [weakSelf.subArray replaceObjectAtIndex:2 withObject:selectValueStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick

//- (void)chooseImage {
//}
- (void)iconImgTap{
    DLog(@"");
        //非处理状态
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片拍照
            [weakSelf chooseImageWithType:Photo_Choose_Type_Grapht];
        }];
        UIAlertAction *photoalbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //图片相册选择
            [weakSelf chooseImageWithType:Photo_Choose_Type_Album];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:photographAction];
        [alertVC addAction:photoalbumAction];
        [alertVC addAction:cancleAction];
        alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:alertVC animated:YES completion:nil];
   
}

- (void)chooseImageWithType:(Photo_Choose_Type)type {
   
   UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
   pickVC.delegate = self;
   if (type == Photo_Choose_Type_Grapht) {
       
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
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [PersonInfoViewModel changePersonHeaderImgWithUpSendImg:photo withBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
//            NSString *imgUrl =  [[dic allKeys] containsObject:@"data"]?[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]] : @"";//1213改接口改数据
            NSMutableDictionary *getDataDic =  ( [[dic allKeys] containsObject:@"data"] && isNotNil([dic objectForKey:@"data"]) ) ? [dic objectForKey:@"data"] : [NSDictionary dictionary]; 
            NSString *imgUrl =  [[getDataDic allKeys] containsObject:@"url"]?[NSString stringWithFormat:@"%@",[getDataDic objectForKey:@"url"]] : @"";

            if (imgUrl.length>0) {
                [PersonInfoViewModel changePersonHeadImgWithUrlStr:imgUrl withBlock:^(NSDictionary * subDic, BOOL subSuccess) {
                    if (subSuccess) {
                        [ShareUserInfo sharedUserInfo].userInfo.avatarUrl  = imgUrl;
                        Y_NSNotificationCenter_PostNotice_NilObject_Name(PersonInfo_Change_Notice);
                        Y_SVP_SHOW_SUCCESS_MES(@"成功更改头像");
                        [weakSelf.subArray replaceObjectAtIndex:0 withObject:imgUrl];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView reloadData];
                        });
                    }else{
                        Y_SVP_SHOW_ERR_MES(@"更改头像失败");
                    }
                }];
               
            }else{
                Y_SVP_SHOW_ERR_MES(@"更改头像失败");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}

@end
