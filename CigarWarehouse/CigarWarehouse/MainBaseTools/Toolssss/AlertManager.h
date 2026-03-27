//
//  AlertManager.h
//  Community
//
//  Created by 余莹 on 2021/9/14.
//

#import <Foundation/Foundation.h>

static const NSInteger AlertManagerCancelIndex = 9999;
//
static const NSInteger AlertManagerCameraImgIndex = 0; //拍照
static const NSInteger AlertManagerPhotoLibraryIndex = 1; //相册
static const NSInteger AlertManagerZFBIndex = 0;
static const NSInteger AlertManagerWXIndex = 1;
 
typedef void(^AlertIndexBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject
+ (AlertManager *)shareManager;

//- (AlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION;
- (AlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitleArr:(NSMutableArray *)otherTitleArr;

- (void)showWithViewController:(UIViewController *)viewController IndexBlock:(AlertIndexBlock)indexBlock;

#pragma mark ==
@property (nonatomic,strong) NSMutableArray *payTitleArr;
@property (nonatomic,strong) NSMutableArray *chooseImgTypeTitleArr; 

@end

NS_ASSUME_NONNULL_END
