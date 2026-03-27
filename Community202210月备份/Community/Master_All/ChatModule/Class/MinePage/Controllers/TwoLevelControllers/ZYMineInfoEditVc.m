//
//  ZYMineInfoEditVc.m
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import "ZYMineInfoEditVc.h"
#import "ZYMineInfoEditCell.h"
#import "ZYMineInfoEditBottomCell.h"
//
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
#import "ZYQcodeView.h"
//

static NSString * const mineInfoEditCellID = @"ZYMineInfoEditCell";
static NSString * const mineInfoEditBottomCellID = @"ZYMineInfoEditBottomCell";
#define kMineInfoEditCellHeight 310
#define kMineInfoEditBottomCellHeight 56

@interface ZYMineInfoEditVc () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) ZYQcodeView *qcodeView;
//@property (nonatomic,strong) UIImage *saveChooseHeaderImg;

// 当前二维码背景图index
@property (nonatomic, assign) NSInteger qcodeIndex;

@end

@implementation ZYMineInfoEditVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"编辑个人信息";
    self.qcodeIndex = 1;
    [self setUI];
    [self customTableView];
    [self initData];
}

// 加载xib父类的视图
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    
    return self;
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview);
    }];
    
    [self.view addSubview:self.qcodeView];
    self.qcodeView.hidden = YES;
    [_qcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_qcodeView.superview);
    }];
}
- (void)initData{
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithDictionary:[[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn mj_keyValues]];
    WEAKSELF
    STRONGSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [strongSelf.qcodeView fillUserInfo:[NSMutableDictionary dictionaryWithDictionary:userInfoDic]];
    });
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

-  (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"二维码名片", @"聊天号"];
    }
    
    return _titleArray;
}

#pragma mark - 定制TableView
- (void)customTableView {

    // 防止tableView刷新漂移问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    // 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMineInfoEditCell" bundle:nil] forCellReuseIdentifier:mineInfoEditCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZYMineInfoEditBottomCell" bundle:nil] forCellReuseIdentifier:mineInfoEditBottomCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return self.titleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ZYMineInfoEditCell *cell = [tableView dequeueReusableCellWithIdentifier:mineInfoEditCellID forIndexPath:indexPath];
        
        NSString *headerImgStr = [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl];
        NSURL *headerImgUrl = [UrlWithString getURLWithStr:@""];
        if([[TextShowWithModelStr textShowWithModelStr: headerImgStr ] rangeOfString:@"http"].location !=NSNotFound){
            headerImgUrl = [UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL,headerImgStr]]; //BASE_Chat_Img_Default_URL 旧有值 新为@“”
        }else{
            headerImgUrl = [UrlWithString getURLWithStr: [NSString stringWithFormat:@"%@%@",BASE_Chat_Img_Default_URL_AddBase,headerImgStr]];
        }
      
        [cell.iconImageView sd_setImageWithURL:headerImgUrl  placeholderImage:[UIImage imageNamed:@"My_headportrait"]]; 
        
        cell.nameTF.text = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.nickName;
        cell.signatureTextView.text = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.autograph;
        //
        cell.nameTF.delegate = self;
        cell.signatureTextView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconImgTap)];
        cell.iconImageView.userInteractionEnabled = YES;
        [cell.iconImageView addGestureRecognizer:tap];
        
        return cell;
    }else {
        ZYMineInfoEditBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:mineInfoEditBottomCellID forIndexPath:indexPath];
        cell.titleLabel.text = self.titleArray[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"二维码名片");
            self.qcodeView.hidden = NO;
        }else if (indexPath.row == 1) {
            NSLog(@"聊天号");
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return kMineInfoEditCellHeight;
    }else {
        
        return kMineInfoEditBottomCellHeight;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
    NSLog(@"TF=%@", textField.text);

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"TFeeeee=%@", textField.text);
    [self selfNickNameChangeWithStr:textField.text];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"TV=%@", textView.text);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"TVeeee=%@", textView.text);
    [self selfAutographChangeWithStr:textView.text];
}
- (void)selfNickNameChangeWithStr:(NSString *)nickStr{
    if (nickStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"昵称不能为空");
        [self.tableView reloadData];
        return;
    }
    [ChatManagerData chatUserInfoChangeNickNameNew:nickStr withBlock:^(NSDictionary * dic, BOOL success) {//chatUserInfoChangeNickName旧接口
        if (success) {
            //昵称
            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.nickName = nickStr;
        }else{
        }
    }];
}
//个性签名
- (void)selfAutographChangeWithStr:(NSString *)autographStr{
    if (autographStr.length<=0) {
        autographStr = @"";
//        Y_SVP_SHOW_ERR_MES(@"个性签名能为空");
    }
    [ChatManagerData chatUserInfoChangeAutograph:autographStr withBlock:^(NSDictionary * dic, BOOL success) {
        //个性签名
        [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.autograph = autographStr;
        
    }];
}
#pragma mark - 处理点击事件
- (void)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark == 头像
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

#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick

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
    NSString *strOfUIImagePickerControllerMediaType = info[UIImagePickerControllerMediaType];
   UIImage *photo = info[UIImagePickerControllerOriginalImage];
   [self dismissViewControllerAnimated:YES completion:nil];
   [self imgDetalWithPhoto:photo];
}
#pragma mark === 提交img信息的 //图片上传
- (void)imgDetalWithPhoto:(UIImage *)photo{
    if (isNil(photo)) {
        Y_SVP_SHOW_ERR_MES(@"空图片！");
    }
//    self.saveChooseHeaderImg = photo;
    WEAKSELF
    [ChatManagerData chatWillSendImgFileWithImg:photo withGetDicBlock:^(NSDictionary * dic,  BOOL success) {
        if (success) {
            DLog(@"");
            STRONGSELF
            if ([[dic allKeys]containsObject:@"url"]) {
                NSString *getUrl = [NSString stringWithString:dic[@"url"]];
                [strongSelf getImgUrlToSend:getUrl];
            }else{
                Y_SVP_SHOW_ERR_MES(@"图片文件上传出错!");
            }
        }
    }];
}
- (void)getImgUrlToSend:(NSString *)urlStr{
    WEAKSELF
    [ChatManagerData chatUserChangeHeaderImgUrlStrNew:urlStr withBlock:^(NSDictionary * dic,  BOOL success) {//chatUserInfoChangeHeaderImgUrlStr 旧接口
        if (success) {
            DLog(@"");
            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl = urlStr;
            [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgSmallUrl = urlStr;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
             
        }
    }];
}
#pragma mark ==
- (ZYQcodeView *)qcodeView {
    if (!_qcodeView) {
        _qcodeView = [[NSBundle mainBundle] loadNibNamed:@"ZYQcodeView" owner:nil options:nil].lastObject;
        _qcodeView.hidden = YES;
        [_qcodeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qcodeViewTap)]];
        [_qcodeView.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTap)]];
        [_qcodeView.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_qcodeView.saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_qcodeView.refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _qcodeView;
}

// 点击qcodeView
- (void)qcodeViewTap {
    
    self.qcodeView.hidden = YES;
//    [self.qcodeView removeFromSuperview];
}

- (void)contentViewTap {
}

// 关闭qcodeView
- (void)closeButtonClicked {
    
    self.qcodeView.hidden = YES;
//    [self.qcodeView removeFromSuperview];
}

// 保存二维码
- (void)saveButtonClicked {
    
    NSLog(@"保存二维码");
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"保存中..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.qcodeView.closeButton.hidden = YES;
        self.qcodeView.saveButton.hidden = YES;
        self.qcodeView.saveLabel.hidden = YES;
        self.qcodeView.refreshButton.hidden = YES;
        self.qcodeView.refreshLabel.hidden = YES;
        [SaveScreenViewImgToLocalTool saveImgToPhonePhotoLocalWithView:self.qcodeView];
        self.qcodeView.closeButton.hidden = NO;
        self.qcodeView.saveButton.hidden = NO;
        self.qcodeView.saveLabel.hidden = NO;
        self.qcodeView.refreshButton.hidden = NO;
        self.qcodeView.refreshLabel.hidden = NO;
    });
}

// 刷新二维码
- (void)refreshButtonClicked {
    
    NSLog(@"刷新二维码");
    self.qcodeIndex++;
    if (self.qcodeIndex > 11) {
        self.qcodeIndex = 1;
    }
    self.qcodeView.qcodeBackgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"QRCode%ld", self.qcodeIndex]];
}

@end
