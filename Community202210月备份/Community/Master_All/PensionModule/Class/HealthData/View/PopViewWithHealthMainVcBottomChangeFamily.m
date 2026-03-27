//
//  PopViewWithHealthMainVcBottomChangeFamily.m
//  Community
//
//  Created by 余莹 on 2021/11/26.
//

#import "PopViewWithHealthMainVcBottomChangeFamily.h"
#import "PopViewWithChangeFamilyTableViewCell.h"
#define PopViewWithChangeFamilyTableViewCell_IndexPath     @"PopViewWithChangeFamilyTableViewCell"
static NSInteger noChooseIndex = 9999;
@interface PopViewWithHealthMainVcBottomChangeFamily () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)  UILabel *headerLabel;
@property (nonatomic,strong)  BaseTableViewFooterView *footerBtnView;
@property (nonatomic,strong) NSMutableArray *saveChooseBoolArr;
@end

@implementation PopViewWithHealthMainVcBottomChangeFamily
 
- (NSMutableArray *)saveChooseBoolArr{
    if (!_saveChooseBoolArr) {
        _saveChooseBoolArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveChooseBoolArr;
}
- (void)setSubMainViewHeight{
    self.tableViewHeight = Screen_H*0.5;
}
- (void)tableViewOtherSet{
    self.tableView.tableFooterView = self.footerBtnView;
    [_footerBtnView.footerBtn newAnBtnWithTextColor:[UIColor whiteColor] withBackColor:Y_ColorWith16FromRGB(0x36C8C1) withFont: [PensionThemeManager shareManager].Pension_TextFont_B15 withLayerCorNerNum:0 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
}
- (void)tableViewOtherSetWhenGetArrWithArray:(NSMutableArray *)array{
    NSLog(@"basePOPV fram  tabv= %@  btn=%@  arr.couny=%ld" ,NSStringFromCGRect(self.tableView.frame) ,NSStringFromCGRect(self.closeBtn.frame),array.count);
    //选择数据
    [self.saveChooseBoolArr removeAllObjects];
    for (int i = 0; i < array.count; i++) {
        [self.saveChooseBoolArr addObject: @(0)];
    }
}
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   return self.headerLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PopViewWithChangeFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PopViewWithChangeFamilyTableViewCell_IndexPath];
   if (!cell) {
       cell = [[PopViewWithChangeFamilyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PopViewWithChangeFamilyTableViewCell_IndexPath];
   }
    ZYFamilyArchiveModel *model = self.dataSource[indexPath.row];
    [cell fillDataWithModel:model];
    cell.rightBtn.selected = [self.saveChooseBoolArr[indexPath.row] boolValue];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //单选只做did后判断选中 不做当前row的取消选中
    //附带其他row的取消选中
     for (int i = 0;  i < self.saveChooseBoolArr.count; i ++) {
        if (i==indexPath.row) {//选中
            [self.saveChooseBoolArr replaceObjectAtIndex:i withObject:@(1)];
        }else{//置0
            [self.saveChooseBoolArr replaceObjectAtIndex:i withObject:@(0)];
        }
    }
    [tableView reloadData];
}
#pragma mark === headerLabel
- (UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.backgroundColor = [UIColor clearColor];
        _headerLabel.text = @"选择切换的家人";
        _headerLabel.textColor = [UIColor blackColor];
        _headerLabel.font =  [PensionThemeManager shareManager].Pension_TextFont_B15;
        _headerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerLabel;
}
#pragma mark ===  footerBtn
- (BaseTableViewFooterView *)footerBtnView{
    if (!_footerBtnView) {
        _footerBtnView = [[BaseTableViewFooterView alloc]initWithFrame: CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerBtnView.footerBtn newAnBtnWithTextStr:@"确定"];
        [_footerBtnView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerBtnView;
}

- (void)footerBtnAction{
    NSInteger idex = noChooseIndex;
    for (int i = 0; i < self.saveChooseBoolArr.count; i++) {
        if ([self.saveChooseBoolArr[i] boolValue] == YES) {
            idex = i;
        }
    }
    if (idex == noChooseIndex) {
        [self dismissThePopView];
        return;
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idex inSection:0];
        if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
            [self dismissThePopView];
            [self.delegate basePopViewTag:0  OfSubTableViewTouchWithIndexPath:indexPath];
        }
    }
  
}
@end
