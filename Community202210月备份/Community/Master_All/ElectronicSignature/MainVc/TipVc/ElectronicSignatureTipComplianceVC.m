//
//  ElectronicSignatureComplianceVC.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureTipComplianceVC.h"
#import "ElectronicSignatureTipComplianceTableViewCell.h"
#define  ElectronicSignatureTipComplianceTableViewCell_Identifier @"ElectronicSignatureTipComplianceTableViewCell"
@interface ElectronicSignatureTipComplianceVC ()  <UITableViewDelegate,UITableViewDataSource>
@end

@implementation ElectronicSignatureTipComplianceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
   
}
- (void)initView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.topTitleImgV.image = [[ZYThemeManager shareManager] themeImageNamed:@"gthg"];
}
- (void)initData{
    self.cellTitleTextArr = [[NSMutableArray alloc]initWithObjects:@"什么是电子合同？",@"具有法律效力吗？",@"为什么使用电子合同？", nil];
    self.cellContentTextArr = [[NSMutableArray alloc]initWithObjects:@"电子合同，又称电子商务合同，根据联合国国际贸易法委员会《电子商务示范法》以及世界各国颁布的电子交易法，同时结合我国《合同法》的有关规定，电子合同可以界定为：电子合同是双方或多方当事人之间通过电子信息网络以电子的形式达成的设立、变更、终止财产",@"根据《电子签名法》的规定，民事活动中的合同或者其他文件、单证等文书，当事人可以约定使用电子签名、数据电文；可靠的电子签名与手写签名或者盖章具有同等的法律效力。明确肯定了符合条件的电子签名与手写签名或盖章具有同等的效力。",@"电子合同拥有传统合同不可以比拟的优势，对企业来说更加方便快捷，安全性也更高，而且优秀的第三方电子合同平台，还能提供完善的法 律服务，可以说是数字化时代不可或缺的工具，对于今年的特殊情况，还可以很大程度避免接触的风险。", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellContentTextArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ElectronicSignatureTipComplianceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureTipComplianceTableViewCell_Identifier];
    if (!cell) {
        cell = [[ElectronicSignatureTipComplianceTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectronicSignatureTipComplianceTableViewCell_Identifier];
    }
    cell.titleL.text = self.cellTitleTextArr[indexPath.row];
    // 设置行间距
    NSString *str = self.cellContentTextArr[indexPath.row];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range: NSMakeRange(0, str.length)];
    cell.detailL.attributedText = attStr;
    cell.detailL.text = self.cellContentTextArr[indexPath.row];
    return cell;
}


@end
