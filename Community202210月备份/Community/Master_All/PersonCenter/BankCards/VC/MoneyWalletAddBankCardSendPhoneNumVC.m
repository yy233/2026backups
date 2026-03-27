//
//  MoneyWalletAddBankCardSendPhoneNumVC.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletAddBankCardSendPhoneNumVC.h"
#import "MoneyWalletAddBankCardInfoTableViewCell.h"
#define  MoneyWalletAddBankCardInfoTableViewCell_Identifier       @"MoneyWalletAddBankCardInfoTableViewCell"
#import "MoneyWalletAddBankCardPhoneNumTableViewCell.h"
#define  MoneyWalletAddBankCardPhoneNumTableViewCell_Identifier   @"MoneyWalletAddBankCardPhoneNumTableViewCell"

@interface MoneyWalletAddBankCardSendPhoneNumVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MoneyWalletAddBankCardSendPhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
}
#pragma mark ==
- (void)footerAgreeBtnAction{
    DLog(@"")
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 70;
    }else if (indexPath.row==1){
        return 60;
    }else{
        return 0;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MoneyWalletAddBankCardInfoTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletAddBankCardInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoneyWalletAddBankCardInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletAddBankCardInfoTableViewCell_Identifier];
        }
        cell.detailL.text = [NSString stringWithFormat:@"卡类型：%@（%@）",self.bankCardTypeStr,self.bankCardNumStr];
        return cell;
    }else {
        MoneyWalletAddBankCardPhoneNumTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletAddBankCardPhoneNumTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoneyWalletAddBankCardPhoneNumTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletAddBankCardPhoneNumTableViewCell_Identifier];
        }
        return cell;
    }
}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"同意协议并提交"];
        [_footerView.footerBtn addTarget:self action:@selector(footerAgreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        //
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn newAnBtnWithTextStr:@"暂不添加"];
        [cancelBtn newAnBtnWithTextColor:Color_153GrayColor];
        [cancelBtn newAnBtnWithFont:FontSize_MoneyWallet_Nomail(12)];
        cancelBtn.frame = CGRectMake((Screen_W*0.5-50*0.5),(120-20), 50, 20);//50——w
        //
        UIButton *lookAgreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lookAgreementBtn.frame = CGRectMake(16,0, 100, 20);
        NSString *str = @"查看《服务协议》";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        NSUInteger length = [str length];
        //设置字体
        UIFont *baseFont = FontSize_MoneyWallet_Nomail(12);
        [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
        // 设置颜色
        UIColor *colorG = Color_153GrayColor;
        UIColor *colorO =  Y_RGBA(255, 123, 16, 1);
        //  NSForegroundColorAttributeName字体色 NSBackgroundColorAttributeName背景色
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:colorG
                           range:[str rangeOfString:@"查看"]];
        [attrString addAttribute:NSForegroundColorAttributeName value:colorO
                           range:[str rangeOfString:@"《服务协议》"]];
        [lookAgreementBtn setAttributedTitle:attrString forState:UIControlStateNormal];
        //
        [_footerView addSubview:lookAgreementBtn];
        [_footerView addSubview:cancelBtn];
    }
    return _footerView;
}
 
 
@end
