//
//  ScanQR_BaseViewController.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanQR_BaseViewController : UIViewController
@property (nonatomic,copy)  void(^qrResultStrBlock)(NSString *) ;
- (void)goTowebVcWithQRResult:(NSString *)result;
@end

NS_ASSUME_NONNULL_END
