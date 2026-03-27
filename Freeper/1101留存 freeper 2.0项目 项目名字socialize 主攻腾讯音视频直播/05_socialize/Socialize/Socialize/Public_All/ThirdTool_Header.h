//
//  ThirdTool_Header.h
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#ifndef ThirdTool_Header_h
#define ThirdTool_Header_h
//_____________________________________
#import "Y_ToolOfOthers.h"
#import "UIImageView+CornerRadius.h"
#import "UIColor+Gradient.h"
#import "UIImage+Additions.h"
#import "UIImage+Color.h"
#import "UIButton+NewAnBtn.h"
#import "NSObject+Utils.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BezierPathTool.h"
#import "MJExtension.h"
#import <SDWebImage/SDWebImage.h>
#import <SGQRCode/SGQRCode.h>
#import "XCQRCodeVC.h"


#import "STScrollBar.h"
#import "KJMarqueeLabel.h"
//
#import "UrlWithString.h"

//___________________________________________________________Y_ResponsObject_相关__
#import "TextShowWithModelStr.h"
#define  Y_IS_Success_status                            ([[responsObject objectForKey:@"status"] intValue]== 0  ||  [[responsObject objectForKey:@"status"] intValue]== 200 )
#define  Y_IS_Success_code                                ( [[responsObject objectForKey:@"code"] intValue]== 0  ||  [[responsObject objectForKey:@"code"] intValue]== 200 )
#define  Y_Success_Or_ErrCode                            [[responsObject objectForKey:@"code"] intValue]
#define  Y_Success_Or_ErrCodeKeyIntV                     [[responsObject objectForKey:@"err_code"] intValue]
#define  Y_status_IS_Success                            ( [[responsObject objectForKey:@"status"] intValue]== 0  ||  [[responsObject objectForKey:@"status"] intValue]== 200 )


#define  Y_ResponsObject_codeStr                         [[responsObject allKeys] containsObject:@"code"] ? [NSString stringWithFormat:@"%@",[responsObject objectForKey:@"code"]] : @"1000"
#define  Y_ResponsObject_dataDic                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSDictionary dictionary]
#define  Y_ResponsObject_dataArr                         ( [[responsObject allKeys] containsObject:@"data"] && isNotNil([responsObject objectForKey:@"data"]) ) ? [responsObject objectForKey:@"data"] : [NSMutableArray array]
#define  Y_ResponsObject_dataStr                         [[responsObject allKeys] containsObject:@"data"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"data"]] ] : @""
#define  Y_ResponsObject_messageStr                      [[responsObject allKeys] containsObject:@"message"] ? [TextShowWithModelStr textShowWithNotNullStr:[NSString stringWithFormat:@"%@",[responsObject objectForKey:@"message"]] ] : @"暂无具体信息"
#define  Y_ResponsObject_rowsArr [[rows allKeys] containsObject:@"rows"]?[rows objectForKey:@"rows"]:[NSMutableArray array]
////_________________________________________________________SVProgressHUD__相关__
#import "SVProgressHUD.h"
//#import "SVProgressHUD+CustomHUD.h"

#define Y_SVP_SHOW_SUCCESS_MESSAGE           [SVProgressHUD showSuccessWithStatus:Y_ResponsObject_messageStr]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_DESCRIPTION           [SVProgressHUD showErrorWithStatus:error.description];  [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MESSAGE               [SVProgressHUD showErrorWithStatus:Y_ResponsObject_messageStr];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_ERR_MES(_msg)             [SVProgressHUD showErrorWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_SUCCESS_MES_5Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_SUCCESS_MES_10Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:10.0];
#define Y_SVP_SHOW_SUCCESS_MES_15Delay(_msg)         [SVProgressHUD showSuccessWithStatus:_msg]; [SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES(_msg)                 [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_DISMISS                        [SVProgressHUD dismiss];
#define Y_SVP_DISMISS_DELAY_TWO              [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_MES_5Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_10Delay(_msg)          [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:10.0];

#define Y_SVP_SHOW_MES_5Delay_Loading        [SVProgressHUD showWithStatus:@"加载中"];[SVProgressHUD dismissWithDelay:5.0];
#define Y_SVP_SHOW_MES_Loading               [SVProgressHUD showWithStatus:@"处理中"];
#define Y_SVP_SHOW_MES_IsDealing             [SVProgressHUD showWithStatus:@"正在处理"];
#define Y_SVP_SHOW_MES_IsDealing_15Delay     [SVProgressHUD showWithStatus:@"正在处理"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_MES_IsLoading_15Delay     [SVProgressHUD showWithStatus:@"正在加载"];[SVProgressHUD dismissWithDelay:15.0];
#define Y_SVP_SHOW_INFO_MES(_msg)            [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:2.0];
#define Y_SVP_SHOW_INFO_MES_5Delay(_msg)     [SVProgressHUD showInfoWithStatus:_msg]; [SVProgressHUD dismissWithDelay:5.0];

#define Y_SVP_SHOW_MES_IsDling_15Delay(_msg) [SVProgressHUD showWithStatus:_msg];[SVProgressHUD dismissWithDelay:15.0];
////_________________________________________________
//





//_____________________________________
@import MJRefresh;
@import Masonry;

#endif /* ThirdTool_Header_h */
