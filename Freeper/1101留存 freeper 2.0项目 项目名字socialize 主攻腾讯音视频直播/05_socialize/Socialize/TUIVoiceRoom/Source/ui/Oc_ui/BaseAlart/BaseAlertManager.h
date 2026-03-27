//
//  BaseAlertManager.h
//  AFNetworking
//
//  Created by 余莹 on 2023/6/14.
//

#import <Foundation/Foundation.h>

typedef void(^AlertIndexBlock)(NSInteger chooseIndex);

static const NSInteger AlertManagerCancelIndex = 9999;
//
static const NSInteger AlertManagerCameraImgIndex = 0; //拍照
static const NSInteger AlertManagerPhotoLibraryIndex = 1; //相册

NS_ASSUME_NONNULL_BEGIN

@interface BaseAlertManager : NSObject
+ (BaseAlertManager *)shareManager;
#pragma mark ==
@property (nonatomic,strong) NSMutableArray *chooseImgTypeTitleArr;
#pragma mark ==
- (BaseAlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitleArr:(NSMutableArray *)otherTitleArr;
#pragma mark == 第一位是取消按钮 后面全部自定义红色文本按钮
- (BaseAlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle beignIsCancelTitle:(NSString *)canceTitle otherTitleArrOfAllIsRedColor:(NSMutableArray *)otherTitleArr;
#pragma mark == 第一位是取消按钮 后面全部自定义绿色文本按钮
- (BaseAlertManager *)crearAlertHaveFirstCancleBtnAndGreenLastBtnWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle fistCancelTitle:(NSString *)canceTitle lastTitle:(NSString *)lastTitle;
#pragma mark ==


- (void)showWithViewController:(UIViewController *)viewController IndexBlock:(AlertIndexBlock)indexBlock;
@end

NS_ASSUME_NONNULL_END
