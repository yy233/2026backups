//
//  MyHouseAddSubPerSonSuccessVc.m
//  Community
//
//  Created by 余莹 on 2021/10/19.
//

#import "MyHouseAddSubPerSonSuccessVc.h"
#import "MyHouseAddSubPeronOkShowScanCodeVc.h"
@implementation MyHouseAddSubPerSonSuccessVc

- (void)viewDidLoad{
    [super viewDidLoad];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = YES;
}
 
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden  = NO;
}
- (void)setUISuccess{
    self.centerL.text = @"发送成功，等待对方确认";
    self.centerImgV.image = [UIImage imageNamed:@"success_Face"];
    [self.footerView.footerBtn newAnBtnWithTextStr:@"查看二维码"];
}


- (void)footerBtnAction{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        MyHouseAddSubPeronOkShowScanCodeVc *vc = [[MyHouseAddSubPeronOkShowScanCodeVc alloc]init];
        vc.showScanCodeWebUrlStr = self.showScanCodeWebUrlStr;
        vc.addInfoStr = self.addInfoStr;
        vc.addressStr = self.addressStr;
        [weakSelf pushVc:vc];
        //再删除nav中的编辑页 跳转了再删 不然就nil了
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                if ([weakSelf respondsToSelector:@selector(removeSelfVc)]) {
                    [weakSelf performSelector:@selector(removeSelfVc) withObject:nil];
                }
        });
    });
 
}
- (void)removeSelfVc{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *vcArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in vcArr) {
            if ([vc isKindOfClass:[MyHouseAddSubPerSonSuccessVc class]]) {
                [vcArr removeObject:vc];
                break;
            }
        }
        self.navigationController.viewControllers = vcArr;
    });
}
 
@end
