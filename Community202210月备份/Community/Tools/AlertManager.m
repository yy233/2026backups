//
//  AlertManager.m
//  Community
//
//  Created by 余莹 on 2021/9/14.
//

#import "AlertManager.h"

@interface AlertManager ()

@property(nonatomic, strong) UIAlertController *alertCol;
@property(nonatomic, strong) NSMutableArray *actionTitles;
@property(nonatomic,copy)    AlertIndexBlock indexBlock;
@end

@implementation AlertManager



+ (AlertManager *)shareManager
{
    static AlertManager *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}
#pragma mark ==
//- (AlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION{
//
//    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
//    NSString *actionTitle = nil;
//    va_list args;//用于指向第一个参数
//    self.actionTitles = [NSMutableArray array];
//    [self.actionTitles addObject:canceTitle];
//    if (otherTitle) {
//        [self.actionTitles addObject:otherTitle];
//        va_start(args, otherTitle);//对args进行初始化，让它指向可变参数表里面的第一个参数
//        while ((actionTitle = va_arg(args, NSString*))) {
//
//            [self.actionTitles addObject:actionTitle];
//
//        }
//        va_end(args);
//    }
//    [self buildCancelAction];
//    [self buildOtherAction];
//
//    return [AlertManager shareManager];
//}
//
//- (void)buildCancelAction{
//
//    NSString *cancelTitle = self.actionTitles[0];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        self.indexBlock(0);
//
//    }];
//    [self.alertCol addAction:cancelAction];
//
//}
//
//- (void)buildOtherAction{
//
//    for (int i = 0 ; i < self.actionTitles.count; i++) {
//        if (i == 0)continue;
//        NSString *actionTitle = self.actionTitles[i];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            if (self.indexBlock) {
//
//                self.indexBlock(i);
//            }
//
//        }];
//
//        [self.alertCol addAction:action];
//    }
//
//}
#pragma mark ==
- (AlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitleArr:(NSMutableArray *)otherTitleArr{
    
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //存
    self.actionTitles = [NSMutableArray arrayWithArray:otherTitleArr];
    [self.actionTitles addObject:canceTitle];//cancel
    //
    [self buildOtherAction];
    [self buildCancelAction];
    
    return [AlertManager shareManager];
}
- (void)buildCancelAction{
    
    NSString *cancelTitle = self.actionTitles.lastObject;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.indexBlock(AlertManagerCancelIndex);//9999
        
    }];
    [self.alertCol addAction:cancelAction];
    
}

- (void)buildOtherAction{
    
    for (int i = 0 ; i < self.actionTitles.count-1; i++) {//cancel则不做此类add
        NSString *actionTitle = self.actionTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.indexBlock) {
                
                self.indexBlock(i);
            }
            
        }];
        
        [self.alertCol addAction:action];
    }
    
}

- (void)showWithViewController:(UIViewController *)viewController IndexBlock:(AlertIndexBlock)indexBlock{
    
    if (indexBlock) {
        
        self.indexBlock = indexBlock;
        
    }
    
    [viewController presentViewController:self.alertCol animated:YES completion:^{
        
    }];
}

#pragma mark == 第一位是取消按钮 后面全部自定义红色文本按钮
- (AlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle beignIsCancelTitle:(NSString *)canceTitle otherTitleArrOfAllIsRedColor:(NSMutableArray *)otherTitleArr{
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //存
    self.actionTitles = [NSMutableArray arrayWithCapacity:0];
    [self.actionTitles addObject:canceTitle];//cancel
    [self.actionTitles addObjectsFromArray:otherTitleArr];
    //
    [self buildCancelActionWithCancelStr:canceTitle];
    [self buildOtherRedColorAction:otherTitleArr];
    
    return [AlertManager shareManager];
}
- (void)buildCancelActionWithCancelStr:(NSString *)cancelTitle{
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.indexBlock(AlertManagerCancelIndex);//9999
        
    }];
    [self.alertCol addAction:cancelAction];
    
}
- (void)buildOtherRedColorAction:(NSMutableArray *)otherTitleArr{
    for (int i = 0 ; i < otherTitleArr.count; i++) {//cancel则不做此类add 从1开始
        NSString *actionTitle = otherTitleArr[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.indexBlock) {
                
                self.indexBlock(i);
            }
            
        }];
        
        [self.alertCol addAction:action];
    }
    
}


#pragma mark ==

- (NSMutableArray *)payTitleArr{
    if (!_payTitleArr) {
        if (![WXApi isWXAppInstalled]) {
            _payTitleArr = [[NSMutableArray alloc]initWithObjects:@"支付宝", nil];//点击事件 0 支付宝
        }else{
            _payTitleArr = [[NSMutableArray alloc]initWithObjects:@"支付宝", @"微信", nil];//点击事件 0 支付宝 1微信
        }
    }
    return _payTitleArr;
}
- (NSMutableArray *)chooseImgTypeTitleArr{
    if (!_chooseImgTypeTitleArr) {
        _chooseImgTypeTitleArr = [[NSMutableArray alloc]initWithObjects:@"拍照",@"相册", nil];// AlertManagerCameraImgIndex = 0 拍照  ||  AlertManagerPhotoLibraryIndex 相册1
    }
    return _chooseImgTypeTitleArr;
}
@end
