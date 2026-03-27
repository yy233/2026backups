//
//  ResetPasswordViewLast.m
//  Community
//
//  Created by 余莹 on 2021/12/10.
//

#import "ResetPasswordViewLast.h"

@interface ResetPasswordViewLast ()

@end

@implementation ResetPasswordViewLast

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bottomBackView.hidden = YES;
        self.topTitleLabel.text = @"重置密码";
        self.topDetailTitleLabel.text = @"已注册手机号可以重置密码";
        [self.registOkBtn newAnBtnWithTextStr:@"确认修改"];
        self.textFiledPStrArr = [NSMutableArray arrayWithObjects:@"请输入已注册的手机号码",@"请输入验证码",@"请输入新密码",@"请确认新密码", nil];
        [self.tableView reloadData];
    }
    return self;
}
 
@end
