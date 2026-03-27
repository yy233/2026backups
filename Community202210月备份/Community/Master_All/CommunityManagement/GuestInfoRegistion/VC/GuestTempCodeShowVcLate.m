//
//  GuestTempCodeShowVcLate.m
//  Community
//
//  Created by 余莹 on 2021/10/28.
//

#import "GuestTempCodeShowVcLate.h"

@interface GuestTempCodeShowVcLate ()

@end

@implementation GuestTempCodeShowVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initShowQrData];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)initShowQrData{
    if (self.isTempCodeShow) {
        self.guestNameShowLabel.text = @"临时访客二维码";
    }else{
        
    }
    //
    self.addressShowLabel.text = self.houseNameShowStr; 
    //
    NSString *showBottomText = [NSString stringWithFormat:@"——— 该二维码将在%ld分钟内有效 ———",self.tempTimeNum];
    if (self.tempTimeBeginInfoStr.length>0) {
        showBottomText = [NSString stringWithFormat:@"该二维码将在%@后%ld分钟内有效",self.tempTimeBeginInfoStr,self.tempTimeNum];
    }else{
        showBottomText = [NSString stringWithFormat:@"——— 该二维码将在%ld分钟内有效 ———",self.tempTimeNum];
    }
    self.timeDelineShowLabel.text = showBottomText;

    //
    NSString *qrOkStr = [NSString stringWithFormat:@"{\\\"visitorId\\\":%@}",self.visitorId];
    UIImage *qrImg = [CreatQrCodeImgTool creatQrCodeImgWithOnlyStr:qrOkStr];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.qrInfoImgV.image = qrImg;
    });
 
    
}
@end
