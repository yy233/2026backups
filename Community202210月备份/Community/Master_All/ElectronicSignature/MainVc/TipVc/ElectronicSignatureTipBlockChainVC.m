//
//  ElectronicSignatureTipBlockChainVC.m
//  Community
//
//  Created by 余莹 on 2021/1/27.
//

#import "ElectronicSignatureTipBlockChainVC.h"
#import "ElectronicSignatureTipBlockChainTableViewCell.h"
#define  ElectronicSignatureTipBlockChainTableViewCell_Identifier @"ElectronicSignatureTipBlockChainTableViewCell"
@interface ElectronicSignatureTipBlockChainVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *cellRightImgNameArr;
@end

@implementation ElectronicSignatureTipBlockChainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
   
}
- (void)initView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.topTitleImgV.image = [[ZYThemeManager shareManager] themeImageNamed:@"qkl"];
}
- (void)initData{
    self.cellTitleTextArr = [[NSMutableArray alloc]initWithObjects:@"可信时间戳",@"区块链存证",@"数据安全", nil];
    self.cellContentTextArr = [[NSMutableArray alloc]initWithObjects:@"可信时间戳是由权威可信时间戳服务中心签发的一个能证明数据电文(电子文件）在一个时间点是已经存在的、完整的、可验证的，具备法律效力的电子凭证，可信时间戳主要用于电子文件防篡改和事后抵赖，确定电子文件产生的准确时间。",@"区块链数据存证，就是把数据存到区块链上，达到防篡改、可追溯、数据来源可信任的目的。数据可以是文字、视频、音频图片等任何文件形式。",@"区块链合同，有了直通法院的存证，自然既有效又安心。据介绍，使用区块链技术来进行司法存证进行司法存证，用户可以直接通过程序将操作行为为全流程的记录于区块链，比如在线提交电子合同、维权过程、服务流程明细等电子证据，公证处、CA/RA机构、司法鉴定中心以及法院等节点来进行全流程记录，全链路可信，全节点见证。", nil];
    self.cellRightImgNameArr = [[NSMutableArray alloc]initWithObjects:@"时间戳13123",@"3423423",@"123345", nil];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellContentTextArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==2) {
        return 300;
    }else{
        return 210;
    }
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ElectronicSignatureTipBlockChainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureTipBlockChainTableViewCell_Identifier];
    if (!cell) {
        cell = [[ElectronicSignatureTipBlockChainTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ElectronicSignatureTipBlockChainTableViewCell_Identifier];
    }
    if (indexPath.row % 2 == 0) {
        [cell showLeftTextAndRightImgCell];
    }else{
        [cell showRightTextAndLeftImgCell];
    }
    cell.titleL.text = self.cellTitleTextArr[indexPath.row];
    // 设置行间距
    NSString *str = self.cellContentTextArr[indexPath.row];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range: NSMakeRange(0, str.length)];
    cell.detailL.attributedText = attStr;
    cell.rightImg.image = [UIImage imageNamed:self.cellRightImgNameArr[indexPath.row]];
    return cell;
}

- (NSMutableArray *)cellRightImgNameArr{
    
    if (!_cellRightImgNameArr) {
        _cellRightImgNameArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"", nil];
    }
    return _cellRightImgNameArr;
}
@end
