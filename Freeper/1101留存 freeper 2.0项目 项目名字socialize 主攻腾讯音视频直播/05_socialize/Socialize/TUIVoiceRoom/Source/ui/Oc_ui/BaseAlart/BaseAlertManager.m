//
//  BaseAlertManager.m
//  AFNetworking
//
//  Created by 余莹 on 2023/6/14.
//

#import "BaseAlertManager.h"

#define Y_pathForResource                       [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"Locale_Type"]] ofType:@"lproj"]
#define Y_bundleWithPath                        [NSBundle bundleWithPath:Y_pathForResource]
#define Y_LocaleTypeFile_NSLocalString(key)     [Y_bundleWithPath  localizedStringForKey:(key) value:@"" table:@"Locale_Type"]

@interface BaseAlertManager ()

@property(nonatomic, strong) UIAlertController *alertCol;
@property(nonatomic, strong) NSMutableArray *actionTitles;
@property(nonatomic, copy)    AlertIndexBlock indexBlock;

@end


@implementation BaseAlertManager


+ (BaseAlertManager *)shareManager
{
    static BaseAlertManager *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    
    return managerInstance;
}

#pragma mark ==
- (BaseAlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitleArr:(NSMutableArray *)otherTitleArr{
    
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //存
    self.actionTitles = [NSMutableArray arrayWithArray:otherTitleArr];
    [self.actionTitles addObject:canceTitle];//cancel
    //
    [self buildOtherAction];
    [self buildCancelAction];
    
    return [BaseAlertManager shareManager];
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
- (BaseAlertManager *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle beignIsCancelTitle:(NSString *)canceTitle otherTitleArrOfAllIsRedColor:(NSMutableArray *)otherTitleArr{
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //存
    self.actionTitles = [NSMutableArray arrayWithCapacity:0];
    [self.actionTitles addObject:canceTitle];//cancel
    [self.actionTitles addObjectsFromArray:otherTitleArr];
    //
    [self buildCancelActionWithCancelStr:canceTitle];
    [self buildOtherRedColorAction:otherTitleArr];
    
    return [BaseAlertManager shareManager];
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



#pragma mark == 第一位是取消按钮 后面全部自定义绿色文本按钮
- (BaseAlertManager *)crearAlertHaveFirstCancleBtnAndGreenLastBtnWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle fistCancelTitle:(NSString *)canceTitle lastTitle:(NSString *)lastTitle{
    
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //存
    self.actionTitles = [NSMutableArray arrayWithCapacity:0];
    [self.actionTitles addObject:canceTitle];//cancel
    
    [self.actionTitles addObjectsFromArray:@[lastTitle]];
    //
    [self buildGrayColorCancelActionWithCancelStr:canceTitle];
    [self buildOtherGreenColorAction:@[lastTitle].mutableCopy];
    
//    UIView *firstSubview = self.alertCol.view.subviews.firstObject;
//    UIView *alertContentView = firstSubview.subviews.firstObject;
//    for (UIView *subSubView in alertContentView.subviews) { //This is main catch
//        subSubView.backgroundColor =  [UIColor redColor];
//        subSubView.layer.borderColor = [UIColor blueColor].CGColor;
//        subSubView.layer.borderWidth = 1.0;
//    }
    
    return [BaseAlertManager shareManager];
}


- (void)buildGrayColorCancelActionWithCancelStr:(NSString *)cancelTitle{
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.indexBlock(AlertManagerCancelIndex);//9999
    }];
    [cancelAction setValue:[UIColor grayColor] forKey:@"_titleTextColor"];
    [self.alertCol addAction:cancelAction];
    
}
#define kRGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

- (void)buildOtherGreenColorAction:(NSMutableArray *)otherTitleArr{
    for (int i = 0 ; i < otherTitleArr.count; i++) {//cancel则不做此类add
        NSString *actionTitle = otherTitleArr[i];
    
        UIAlertAction *alAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.indexBlock) {//index block
                self.indexBlock(i);
            }
        }];
        
        //#define Color_Socialize_GreenColor                      rgba(1, 211, 211, 1)

        [alAction setValue:kRGBA(1, 211, 211, 1) forKey:@"_titleTextColor"];
        [self.alertCol addAction:alAction];
    }
    
    
}


//用UIActionSheet的willPresentActionSheet委托方法来更改操作表按钮的颜色。
//
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
//{
//    for (UIView *subview in actionSheet.subviews) {
//        if ([subview isKindOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)subview;
//            button.titleLabel.textColor = [UIColor cyanColor];
//        }
//    }
//}

#pragma mark ==
- (NSMutableArray *)chooseImgTypeTitleArr{
    if (!_chooseImgTypeTitleArr) {
        NSString *pzs = Y_LocaleTypeFile_NSLocalString(@"拍照");
        NSString *xcs = Y_LocaleTypeFile_NSLocalString(@"相册");
        _chooseImgTypeTitleArr = [[NSMutableArray alloc]initWithObjects:pzs,xcs, nil];// AlertManagerCameraImgIndex = 0 拍照  ||  AlertManagerPhotoLibraryIndex 相册1
    }
    return _chooseImgTypeTitleArr;
}
@end
