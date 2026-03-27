//
//  MainAllTypeInformationSubPayMoneyTypeListVC.m
//  Community
//
//  Created by 余莹 on 2021/9/6.
//

#import "MainAllTypeInformationSubPayMoneyTypeListVC.h"
#import "MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell.h"
#define MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier         @"MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell"

#import "MainAllTypeInformationSubPayMoneyTypeSubDataModel.h"

@interface MainAllTypeInformationSubPayMoneyTypeListVC ()

@end

@implementation MainAllTypeInformationSubPayMoneyTypeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==1) {
        MainImInfoSubMsgModel *model = self.dataSourceArr[indexPath.section];//section
        //公众号类型 + 且为支付类型
        if ([model.msg_type  isEqualToString: kWebSocketMsgTypeObj_appmsg])  {
            NSDictionary *dic = [Tool dictionaryWithJsonString:model.data];
            MainAllTypeInformationSubPayMoneyTypeSubDataModel *subDataModel = [MainAllTypeInformationSubPayMoneyTypeSubDataModel mj_objectWithKeyValues:dic];
            if (subDataModel.type == 2) { 
                NSString *url = [TextShowWithModelStr textShowWithModelStr:subDataModel.url];
                
                DLog(@"//公众号类型 + 且为支付类型 %@",url);
            }
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 160;
    } else {
        return 30;
    }
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //支付类型
    if (indexPath.row == 0) {
        MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier];
        if (!cell) {
            cell = [[MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MainAllTypeInformationSubPayMoneyTypeListVcTableViewCell_Identifier];
        }
        [cell fillPayMoneyTypeDataWithModel:self.dataSourceArr[indexPath.section]];
        return cell;
        
    }else { //if (indexPath.row == 1)
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"desc"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"desc"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.text = @"    查看详情";
        return cell;
    }
}
#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.5];//分割线颜色
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
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor=[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
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
 
@end
