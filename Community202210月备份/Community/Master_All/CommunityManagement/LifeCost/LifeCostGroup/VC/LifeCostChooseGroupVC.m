//
//  LifeCostChooseGroupVC.m
//  Community
//
//  Created by 余莹 on 2021/1/12.
//  选择分组

#import "LifeCostChooseGroupVC.h"
#import "LifeCostAccountManageVc.h" //户号管理
//
#import "LifeCostNumalGroupNameTableViewCell.h"
#define  LifeCostNumalGroupNameTableViewCell_Identifier    @"LifeCostNumalGroupNameTableViewCell"

#import "LifeCostAddGroupNameTableViewCell.h"
#define  LifeCostAddGroupNameTableViewCell_Identifier      @"LifeCostAddGroupNameTableViewCell"
//
#import "LifeCostGroupViewModel.h"

#define H_Bottom_View   90
#define H_cell          50
#define H_sectionHeader 10
@interface LifeCostChooseGroupVC () <UITextFieldDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *customGroupNameBtnView;
@property (nonatomic,strong) UIView *footerBackViwe;

@end

@implementation LifeCostChooseGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reDic = [[NSDictionary alloc]init];
    self.keyArr = [[NSMutableArray alloc]init];
    self.isChooseTypeArr = [[NSMutableArray alloc]init];
    self.title = @"选择分组";
    self.thisGroupNameStr = @"";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = self.footerView;
    [self initData];
}
#pragma mark ==
- (void)footerNextAction{
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
    if (self.thisGroupNameStr.length>0) {
        [self addNewGroupAction];
    }
    if (haveChooseIndex) {
        [self chooseOneGroupAction:inde];
    }
}
- (void)addNewGroupAction{
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObject:self.thisGroupNameStr forKey:@"name"];
    WEAKSELF
    [LifeCostGroupViewModel addGroupWithParms:parms withblock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"新增分组成功");
                self.thisGroupNameStr = @"";
                [weakSelf initData];
            });
        }
    }];
}
- (void)chooseOneGroupAction:(NSInteger)index{
    //notice
    NSString *groupName =  self.keyArr[index];
    NSMutableDictionary *useInfo = [NSMutableDictionary dictionaryWithObject:groupName forKey:Notice_UserInfo_Key];
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(LifeCose_Group_ChooseOneGroup_Notice_Name, useInfo);
    [self popVC];
}
#pragma mark ==
- (void)initData{
    WEAKSELF
    [LifeCostGroupViewModel getHuHaoManageWithGroupList:^(NSDictionary * dic, BOOL success) {
        if (success) {
            weakSelf.reDic = dic.mutableCopy;
            weakSelf.keyArr = [dic allKeys].mutableCopy;
            weakSelf.isChooseTypeArr = [[NSMutableArray alloc]init];
            for (int i = 0; i <weakSelf.keyArr.count; i++) {
                [weakSelf.isChooseTypeArr addObject:@(0)];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];

}

#pragma mark ==
#pragma mark ==== textFieldDelegate

- (void)textFieldDidChangeSelection:(UITextField *)textField{
      self.thisGroupNameStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //选择功能不可选
    if (self.thisGroupNameStr.length>0) {
        for (int i = 0;  i < self.isChooseTypeArr.count; i++) {
           [self.isChooseTypeArr replaceObjectAtIndex:i withObject:@(0)];
         
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
- (void)didSelectedCellIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",self.keyArr[indexPath.row]);
    //
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
  
        //此项切换
        NSNumber *typeNum = [self.isChooseTypeArr[indexPath.row] isEqual: @(0)] ? @(1) :@(0);
        [self.isChooseTypeArr replaceObjectAtIndex:indexPath.row withObject:typeNum];
        if ([typeNum isEqual:@(1)]){  //单选 其他项滞空
            for (int i = 0;  i < self.isChooseTypeArr.count; i++) {
                if (i != indexPath.row) {
                    [self.isChooseTypeArr replaceObjectAtIndex:i withObject:@(0)];
                }
            }
        }
        //总刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thisGroupNameStr = @"";
            [self.tableView reloadData];
        });
    });
}
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self didSelectedCellIndexPath:indexPath];
    }else{
        NSLog(@" 自定义分组   ");
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.keyArr.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return H_sectionHeader;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return H_cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        LifeCostNumalGroupNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostNumalGroupNameTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostNumalGroupNameTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostNumalGroupNameTableViewCell_Identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.nameL.text = self.keyArr[indexPath.row];
        cell.chooseTypeBtn.selected = [self.isChooseTypeArr[indexPath.row] boolValue];
        [self cellRightBtnShowOrHidden:cell.chooseTypeBtn];
        return cell;
    }else{
        LifeCostAddGroupNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostAddGroupNameTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostAddGroupNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LifeCostAddGroupNameTableViewCell_Identifier];
        }
        cell.textField.text = self.thisGroupNameStr;//用于刷新
        cell.textField.delegate = self;
        return cell;
    }

}
- (void)cellRightBtnShowOrHidden:(UIButton *)sender{
    sender.hidden = NO;
}
#pragma mark ==
//- (void)tableView:(UITableView* )tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    [tableView setSeparatorColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.1]];
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    //
//    if (indexPath. section == 0 && indexPath. row != 3 ) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10000000)];
//    }
//}
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2];//分割线颜色
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            separatoColor =  [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.01];//分割线颜色
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = separatoColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
#pragma mark ==
//- (BaseTableViewFooterView *)customGroupNameBtnView{
//    if (!_customGroupNameBtnView) {
//        _customGroupNameBtnView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 90)];
//        [_customGroupNameBtnView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
//        [_customGroupNameBtnView.footerBtn setTitle:@"自定义分组名称" forState:UIControlStateNormal];
//        [_customGroupNameBtnView.footerBtn setTitleColor:[[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
//        _customGroupNameBtnView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
//
//    }
//    return _customGroupNameBtnView;
//}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.origin.y, Screen_W, H_Bottom_View)];
        [_footerView setBtnFram:CGRectMake(16, 0, Screen_W-32, 50)];
        [_footerView.footerBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _footerView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [_footerView.footerBtn addTarget:self action:@selector(footerNextAction) forControlEvents:UIControlEventTouchUpInside];;
    }
    return _footerView;
}
@end
