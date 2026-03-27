//
//  SetOfLanguageChoosePopView.m
//  RobotSweeper
//
//  Created by Joey on 2018/12/21.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "SetOfLanguageChoosePopView.h"

@interface SetOfLanguageChoosePopView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation SetOfLanguageChoosePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
    [self initData];
    
}
- (void)setDataWithTitleArr:(NSMutableArray *)arrOfPopTitle
                       numArr:(NSMutableArray *)arrOfPopTitleNum{
    
    _arrOfTableViewData = arrOfPopTitle;
    _arrOfTableViewDataNum = arrOfPopTitleNum;
   
    [self initData];
}
- (void)initView{
    [_yesBtn setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[DataManager shareDataManager].colorOfMainType forState:UIControlStateNormal];
    _titleBackView.layer.cornerRadius = 5;
    _btnBackView.layer.cornerRadius = 5;
    [_yesBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [_cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
}

- (void)initData{
    _tableViewOfChooseLanguage.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewOfChooseLanguage.tableFooterView = [UIView new];
    _tableViewOfChooseLanguage.dataSource = self;
    _tableViewOfChooseLanguage.delegate = self;
    if (_arrOfTableViewData.count>0) {
        _tableViewOfChooseLanguage.hidden = NO;
        [_tableViewOfChooseLanguage reloadData];
    }else{
        _tableViewOfChooseLanguage.hidden = YES;
    }
}
#pragma mark --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrOfTableViewData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = _arrOfTableViewData[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (_arrOfTableViewDataNum.count>0) {//单选num组
        if ([_arrOfTableViewDataNum[indexPath.row] intValue]==0) {
            cell.imageView.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuanxin"];
        }else{
          cell.imageView.image = [SkinManager skin_imageWithTypeAndNameWithImageName:@"yuanxin_an"];//使用了预约的week图
        }
        //img大小
        CGSize itemSize = CGSizeMake(20, 20);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        /***
         AppointmentWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentWeekTableViewCell"];
         if (!cell) {
         cell = [[AppointmentWeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppointmentWeekTableViewCell"];
         }
         if (indexPath.row==7) {//第8行
         cell.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.selected = NO;
         }else if(indexPath.row == 8){
         cell.backgroundColor = [UIColor whiteColor];
         cell.selectionStyle = UITableViewCellSelectionStyleDefault;
         cell.textL.text = NSLocalizedString(_arrOfWeakTitlesource[indexPath.row-1], nil) ;
         cell.strOfSelected = _arrOfselected[indexPath.row-1];
         */
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_arrOfTableViewDataNum.count>0) {//单选num组数据不为空 有效
        
        if ([_arrOfTableViewDataNum[indexPath.row] intValue]==0) {//0->1 其余变0
            [self getNewArrDataNumWithIndex:indexPath.row strA:@"1" strB:@"0"];
//        }else{//不处理数据为1的 即点击已存在的不置为0  点击1 不做操作
//             [self getNewArrDataNumWithIndex:indexPath.row strA:@"0" strB:@"1"];
        }
    }
}

- (void)getNewArrDataNumWithIndex:(NSInteger)index
                             strA:(NSString *)strA
                             strB:(NSString *)strB{
    NSMutableArray *newArr = [NSMutableArray array];
    for (int i = 0 ; i<_arrOfTableViewDataNum.count; i++) {
        if (i == index) {//int
            [newArr addObject:strA];//a
        }else{
            [newArr addObject:strB];//b
        }
    }
    _arrOfTableViewDataNum = [NSMutableArray arrayWithArray:newArr];
    [_tableViewOfChooseLanguage reloadData];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hidden = YES;
    
}
@end
