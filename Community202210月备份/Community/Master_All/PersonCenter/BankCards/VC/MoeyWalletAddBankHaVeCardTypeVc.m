//
//  MoeyWalletAddBankHaVeCardTypeVc.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoeyWalletAddBankHaVeCardTypeVc.h"
#import "MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell.h"
#define  MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell_Identifier       @"MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell"
#import "MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell.h"
#define  MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell_Identifier @"MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell"

#import "MoeyWalletAddBankPersonFaceRecognitionVC.h"

@interface MoeyWalletAddBankHaVeCardTypeVc () <MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCellDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MoeyWalletAddBankHaVeCardTypeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
    [self initData];
}
- (void)initData{
//    self.bankTypeStr; 
}
#pragma mark ==
- (void)footerAgreeBtnAction{
    DLog(@"")
    //
    MoeyWalletAddBankPersonFaceRecognitionVC *vc = [[MoeyWalletAddBankPersonFaceRecognitionVC alloc]init];
    [self pushVc:vc];
}
- (void)cellChooseChuXuKa{
    DLog(@"");
}
- (void)cellChooseXinYongKa{
    DLog(@"");
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
        return 80;
    }else{
        return 120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoeyWalletAddBankHaVeCardTypeVcBankTableViewCell_Identifier];
        }
        cell.titleL.text = self.bankTypeStr;
        //
        cell.imgV.image = [UIImage imageNamed:@"Addbankcard_CCB_logo"];
        UIColor *beginColor =  Y_RGBA(34, 162, 255, 1);
        UIColor *endColor = Y_RGBA(7, 139, 233, 1);
        CGSize size = CGSizeMake(Screen_W-32, 70);//h
        cell.backView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:beginColor endColor:endColor];
        return cell;
    }else{
        MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoeyWalletAddBankHaVeCardTypeVcTwoTypeBtnTableViewCell_Identifier];
        }
        cell.delegate = self;
        return cell;
    }
    
}
 

#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"同意协议并下一步"];
        [_footerView.footerBtn addTarget:self action:@selector(footerAgreeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
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
    
    }
    return _footerView;
}
 

@end
