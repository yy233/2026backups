//
//  XCQRCodeVC.h
//  SGQRCodeExample
//
//  Created by kingsic on 2022/7/11.
//  Copyright © 2022 kingsic. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  Notice_Name_GetQRresultAction @"Notice_Name_GetQRresultAction"

typedef void(^QRresultStrBlock)(NSString * _Nullable rStr);
NS_ASSUME_NONNULL_BEGIN



@interface XCQRCodeVC : Y_BaseViewController

@property (nonatomic,copy) QRresultStrBlock resBlock;
@property (nonatomic,assign) BOOL isPushType;//是navpush过来的吗

 @end

NS_ASSUME_NONNULL_END
