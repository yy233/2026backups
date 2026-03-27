//
//  ChatMessageDefineSetTableVc.m
//  Community
//
//  Created by 余莹 on 2021/5/18.
//

#import "ChatMessageDefineSetTableVc.h"
#import "ChatMainSetRightSwichTableViewCell.h"
#define  ChatMainSetRightSwichTableViewCell_Identifier         @"ChatMainSetRightSwichTableViewCell"
//
#import "ChatManagerData.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

@interface ChatMessageDefineSetTableVc () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic,strong) NSMutableArray *titleArr;

@end

@implementation ChatMessageDefineSetTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupsetupNavigationBarWithChatVcStyle];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==2) {
        [self iconImgTap];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<=1) {
        
        ChatMainSetRightSwichTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMainSetRightSwichTableViewCell_Identifier ];
        if (!cell) {
            cell = [[ChatMainSetRightSwichTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChatMainSetRightSwichTableViewCell_Identifier];
        }
        cell.titleL.text = self.titleArr[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" ];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"reuseIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font  = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = Y_ColorWith16FromRGB(0x333333);
        }
        cell.textLabel.text = self.titleArr[indexPath.row];
        return cell;
    }
   
}
 
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"使用听筒模式",@"回车键发送消息",@"聊天背景",@"清空聊天记录", nil];
    }
    return _titleArr;
}

#pragma mark == == == == == == == == == == == == ==
#pragma mark == img pick
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
    [ChatManagerData chatWillSendImgFileWithImg:photo withGetDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            NSString *imgUrlStr = [[dic allKeys]containsObject:@"url"] ? dic[@"url"] : @"";
           //用户好友会话的背景 群背景为空时_群的背景
                [ChatManagerData chatVcSetBackImgWithImgUrlStr:imgUrlStr withBlock:^(NSDictionary * dic, BOOL success) {
                    if (success) {
                        Y_SVP_SHOW_SUCCESS_MES(@"默认背景设置成功");
                        Y_NSNotificationCenter_PostNotice_HaveObject_Name(ChatVcChangeBackImg_NoticeName, imgUrlStr);
                        [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.personalBackground = imgUrlStr;
                    }
                }];
        }
    }];
}
 
@end
