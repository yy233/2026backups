//
//  ImagePickerManager.m
//  Community
//
//  Created by 余莹 on 2021/9/14.
//

#import "ImagePickerManager.h"
@interface ImagePickerManager ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong)UIViewController *viewController;

@property (nonatomic, copy)FinishSelectImageBlcok imageBlock;

@end
@implementation ImagePickerManager

+ (ImagePickerManager *)shareManager
{
    static ImagePickerManager *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}


- (void)selectUserpicSourceWithViewController:(UIViewController *)viewController FinishSelectImageBlcok:(FinishSelectImageBlcok)finishSelectImageBlock{
    
    if (viewController) {
        self.viewController = viewController;
    }
    if (finishSelectImageBlock) {
        self.imageBlock = finishSelectImageBlock;
    }
//    UIAlertController *alertCol = [UIAlertController alertControllerWithTitle:@"请选择头像来源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])///<检测该设备是否支持拍摄
//        {
//            //                    [Tools showAlertView:@"sorry, 该设备不支持拍摄"];///<显示提示不支持
//
//            return;
//        }
//        UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
//
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;///<设置数据来源为拍照
//        picker.allowsEditing = YES;
//        picker.delegate = self;///<代理设置
//
//        [self.viewController presentViewController:picker animated:YES completion:nil];///<推出视图控制器
//
//
//    }];
//     [alertCol addAction:action];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//        UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建
//
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;///<设置数据来源为相册
//        //允许选择照片之后可编辑
//        picker.allowsEditing = YES;
//        picker.delegate = self;///<代理设置
//
//        [viewController presentViewController:picker animated:YES completion:nil];///<推出视图控制器
//
//    }];
//    [alertCol addAction:action2];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//
//
//    }];
//    [alertCol addAction:cancelAction];
//    [viewController presentViewController:alertCol animated:YES completion:nil];
    
    AlertManager *alert = [[AlertManager shareManager] creatAlertWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet cancelTitle:@"取消" otherTitleArr:[AlertManager shareManager].chooseImgTypeTitleArr];
    [alert showWithViewController:viewController IndexBlock:^(NSInteger index) {
        
        if (index == AlertManagerCameraImgIndex) {
            
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])return;///<检测该设备是否支持拍摄
       
            UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建

            picker.sourceType = UIImagePickerControllerSourceTypeCamera;///<设置数据来源为拍照
            picker.allowsEditing = YES;
            picker.delegate = self;///<代理设置
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
           [self.viewController presentViewController:picker animated:YES completion:nil];///<推出视图控制器

        }else if (index == AlertManagerPhotoLibraryIndex){
            
            UIImagePickerController* picker = [[UIImagePickerController alloc]init];///<图片选择控制器创建

            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;///<设置数据来源为相册
            //允许选择照片之后可编辑
            picker.allowsEditing = YES;
            picker.delegate = self;///<代理设置
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [viewController presentViewController:picker animated:YES completion:nil];///<推出视图控制器
        }else if (index == AlertManagerCancelIndex){
            NSLog(@"取消按钮");//
        }else{
            
            
        }
        
    }];
  
  
}



#pragma mark - 相册/相机回调  显示所有的照片，或者拍照选取的照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    //获取编辑之后的图片
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (self.imageBlock) {
        
        self.imageBlock(image);
    }
    
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
    
}


//  取消选择 返回当前试图
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
