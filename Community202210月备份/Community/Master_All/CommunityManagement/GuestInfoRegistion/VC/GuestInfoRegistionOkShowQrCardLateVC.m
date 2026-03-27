//
//  GuestInfoRegistionOkShowQrCardLateVC.m
//  Community
//
//  Created by 余莹 on 2022/5/20.
//

#import "GuestInfoRegistionOkShowQrCardLateVC.h"
#import "ZYVisitorInviteEditVc.h"
#import "ZYVisitorInviteInfoVc.h"

@interface GuestInfoRegistionOkShowQrCardLateVC ()

@end

@implementation GuestInfoRegistionOkShowQrCardLateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *mVc = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYVisitorInviteEditVc class]]) {
            [mVc removeObject:vc];
        }
        if ([vc isKindOfClass:[ZYVisitorInviteInfoVc class]]) {
            [mVc removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [mVc copy];
}
- (void)changeBackViewsUI{//比例更换 底图img更换
    WEAKSELF
    
    [self.qrBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipLabel.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.qrBackView.superview).offset(16);
        make.right.equalTo(weakSelf.qrBackView.superview).offset(-16);
        make.bottom.equalTo(weakSelf.qrBackView.superview).offset(-50-kGHSafeAreaBottomHeight);
    }];
    [self.subTopBackView_4Proportion mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.subTopBackView_4Proportion.superview);
        make.height.equalTo(weakSelf.subTopBackView_4Proportion.superview).multipliedBy(0.25);
    }];
    [self.subBottomBackView_6Proportion mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.subBottomBackView_6Proportion.superview);
        make.height.equalTo(weakSelf.subBottomBackView_6Proportion.superview).multipliedBy(0.75);
    }];
    
    self.qrBackImgV.image = [UIImage imageNamed:@"codeBkbj"];
    
    self.showPasswordTipBtn.hidden = YES;
    self.showPasswordStrBtn.hidden = YES;
    self.addressShowLabel.text = @"";//总地址


}

 
- (void)changQrInfoImgUI{
    WEAKSELF
    [self.qrInfoImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.qrInfoImgV.superview.mas_centerX);
        make.bottom.equalTo(weakSelf.timeDelineShowLabel.mas_top).offset(-10);
        make.top.equalTo(weakSelf.qrInfoImgV.superview).offset(15);
        make.width.equalTo(weakSelf.qrInfoImgV.mas_height).multipliedBy(0.75);//缩小宽度
    }];
    self.qrInfoImgV.contentMode = UIViewContentModeScaleAspectFit;//更改图片展示状态
}
 
@end
