//
//  ZYAuthorizationManager.m
//  Community
//
//  Created by ZY on 2021/12/22.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "ZYAuthorizationManager.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation ZYAuthorizationManager
singleton_implementation(sharedManager)

- (BOOL)requestAuthorization:(KSystemPermissions)systemPermissions presentVc:(UIViewController *)vc {
    switch (systemPermissions) {
        case KAVMediaTypeVideo:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if ((authStatus == AVAuthorizationStatusDenied) || (authStatus == AVAuthorizationStatusRestricted)) {
                    NSString *title = @"请开启相机权限";
                    NSString *message = @"如果App相机权限没有开启，将无法拍照";
                    [self showAlertWithTitle:title message:message presentVc:vc];
                    
                    return NO;
                }
            }
        }
            break;
            
        case KALAssetsLibrary:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
                if ((authStatus == PHAuthorizationStatusDenied) || (authStatus == PHAuthorizationStatusRestricted)) {
                    NSString *title = nil;
                    NSString *message = @"无法获取相册图片，请开启照片的访问权限";
                    [self showAlertWithTitle:title message:message presentVc:vc];
                    
                    return NO;
                }
            }
        }
            break;
        case KCLLocationManager:
        {
            CLAuthorizationStatus authStatus = CLLocationManager.authorizationStatus;
            if ((authStatus == kCLAuthorizationStatusDenied) || (authStatus == kCLAuthorizationStatusRestricted)) {
                NSString *title = nil;
                NSString *message = @"无法定位到您所在的城市，请前去开启定位";
                [self showAlertWithTitle:title message:message presentVc:vc];
                
                return NO;
            }
        }
            break;
        case KAVAudioSession:
        {
            if (![self canRecord]) {
                NSString *title = @"请开启麦克风权限";
                NSString *message = @"如果App麦克风权限没开启，将无法录制语音";
                [self showAlertWithTitle:title message:message presentVc:vc];
                
                return NO;
            }
        }
            break;
        case KABAddressBook:
        {
            CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
            if ((status == CNAuthorizationStatusDenied) || (status == CNAuthorizationStatusRestricted)) {
                NSString *title = @"请开启通讯录权限";
                NSString *message = @"如果App通讯录权限没开启，将无法访问手机通讯录";
                [self showAlertWithTitle:title message:message presentVc:vc];
                
                return NO;
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)canRecord{
    __block BOOL bCanRecord = YES;
    if ([[UIDevice currentDevice] systemVersion].floatValue > 7.0){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                }
            }];
        }
    }

    return bCanRecord;
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message presentVc:(UIViewController *)vc {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 打开设置页面，去设置定位
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
                //设备系统为IOS 10.0或者以上的
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }else{
                //设备系统为IOS 10.0以下的
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:cancleAction];
    [alertVC addAction:okAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
