//
//  LifeCostAccountGroupAddVc.m
//  Community
//
//  Created by 余莹 on 2021/3/24.
//

#import "LifeCostAccountGroupAddVc.h"
#import "LifeCostGroupViewModel.h"
@interface LifeCostAccountGroupAddVc ()

@end

@implementation LifeCostAccountGroupAddVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增分组";
    [self.footerView.footerBtn newAnBtnWithTextStr:@"确定"];
}

#pragma mark ==
- (void)footerNextAction{
    if (self.thisGroupNameStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"组名不能为空!");
        return;
    }
    BOOL haveChooseIndex = NO;
    NSInteger inde =[self.isChooseTypeArr indexOfObject:@(1)];
    if (inde != NSNotFound) {
        haveChooseIndex = YES;
    }
    if (self.thisGroupNameStr.length<=0 && !haveChooseIndex) { //名字做新增 选中的组做pop+notice
        Y_SVP_SHOW_ERR_MES(@"新增时组名不能为空!\n选择时为选择已有组!");
        return;
    }
   if (self.thisGroupNameStr.length>10) {
       Y_SVP_SHOW_ERR_MES(@"组名长度 不能超过10!");
       return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObject:self.thisGroupNameStr forKey:@"name"];
    WEAKSELF
    [LifeCostGroupViewModel addGroupWithParms:parms withblock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"新增分组成功");
                [weakSelf initData];
                weakSelf.thisGroupNameStr = @"";//滞空
                
            });
        }
    }];

}
#pragma mark ==
#pragma mark - Table view data source

- (void)cellRightBtnShowOrHidden:(UIButton *)sender{
    sender.hidden = YES;
}

@end
