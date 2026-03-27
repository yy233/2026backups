//
//  GuestUseTimeChoosePopView.m
//  Community
//
//  Created by 余莹 on 2022/5/20.
//

#import "GuestUseTimeChoosePopView.h"

@implementation GuestUseTimeChoosePopView
 
#pragma mark === btn click
- (void)daysBtnTouchAction:(UIButton *)sender{
    NSLog(@"daysBtnTouchAction %ld",(sender.tag-days_Btn_Tag));
    // 20211012 处理可选范围
    NSInteger theClickDayInt =  sender.tag -days_Btn_Tag;
    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
    NSString* theClickDayStr = [NSString stringWithFormat:@"%@-%0.2ld 23:59:00",strOfYearAndMonth,(long)theClickDayInt];//两位数据 2021-10-06
    NSString *theClickDayIv = [ToolOfTimeChangeFormat getTimeStrWithString:theClickDayStr];    //字符串转时间戳@"YYYY-MM-dd HH:mm:ss"
    if ([theClickDayIv integerValue] < [ [ToolOfTimeChangeFormat currentTimeStr] integerValue]) {
        Y_SVP_SHOW_ERR_MES(@"不能选择今天之前的日期！");//今天可选 所以用到23点59的数据
        return;
    }
    
    sender.selected = !sender.selected;
    [self checkThisBtnIsTwoSelectedOrOther:sender];
}
//查看当前days 已经点击的btn 数量。 btn 开始的tag 结束的tag
- (void)checkThisBtnIsTwoSelectedOrOther:(UIButton *)sender{
    if (sender.selected==YES) {//点击状态
        
        NSLog(@"------两个的旧数据已经处理成单数据｜非两个的旧数据 直接增入")
        if (self.arrOfBtnClik.count==2) {
        BOOL isMin7D =    [self thisNewDayOfOtherDayIs7dBoolWithBtn:sender];//判断是否在7天内
            if (isMin7D) {
                [self.arrOfBtnClik removeObjectAtIndex:0];//删除存的第一个tag
                //[self.saveClickDayIvNum removeObjectAtIndex:0];
            }else{
                Y_SVP_SHOW_INFO_MES(@"不能选择超过7天的时间段！");
                [self refreshNowTimwUI];
                return;
            }
        }else{
            
            BOOL isMin7Day =    [self thisNewDayOfOtherDayIs7dBoolWithBtn:sender];//判断是否在7天内
            if (isMin7Day) {
            }else{
                Y_SVP_SHOW_INFO_MES(@"不能选择超过7天的时间段！");
                [self refreshNowTimwUI];
                return;
            }
        }

        NSLog(@"arrOfBtnClik ===== %@",self.arrOfBtnClik);
        [self.arrOfBtnClik addObject:@(sender.tag)];//arr总数2 or 1
        //[self saveClickDayIvDataAddInfoWithBtn:sender];
        [self refreshNowTimwUI];
    }else{//取消状态
        if (self.arrOfBtnClik.count==2) {//已多选
            if ([self.arrOfBtnClik containsObject:@(sender.tag)]) {//是已经点击过的btn 处理成为单选UI和数据
                //删除
                for (NSNumber *number in self.arrOfBtnClik.reverseObjectEnumerator) {
                    if ([number intValue] == sender.tag) {
                        [self.arrOfBtnClik removeObject:number];
                        //[self saveClickDayIvDataDeletInfoWithBtn:sender];
                    }
                }
                //刷新
                [self chanDaysSubBtnUIWithOneArrElement:self.arrOfBtnClik];
            }
        }else{//本就是单选 UI不处理 数据处理/处理成为单选UI和数据 未选择的
            if ([self.arrOfBtnClik containsObject:@(sender.tag)]) {//删除
                [self.arrOfBtnClik removeAllObjects];
                //[self.saveClickDayIvNum removeAllObjects];
                //刷新
                [self chanDaysSubBtnUIWithNoArrElement:self.arrOfBtnClik];
            }
        }
    }

}
- (void)refreshNowTimwUI{
    if (self.arrOfBtnClik.count==2) {
        //多选状态
        [self changeDaysSubBtnUIWithArr:self.arrOfBtnClik];
    }else{
        //单选状态
        [self chanDaysSubBtnUIWithOneArrElement:self.arrOfBtnClik];
    }
}
#pragma mark == 存储arr 新增动作
- (void)saveClickDayIvDataAddInfoWithBtn:(UIButton *)sender{
    NSInteger theClickDayInt =  sender.tag -days_Btn_Tag;
    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
    NSString* theClickDayStr = [NSString stringWithFormat:@"%@-%0.2ld 00:00:00",strOfYearAndMonth,(long)theClickDayInt];
    NSString *theClickDayIv = [ToolOfTimeChangeFormat getTimeStrWithString:theClickDayStr];    //字符串转时间戳@"YYYY-MM-dd HH:mm:ss"
   // [self.saveClickDayIvNum addObject:@( [theClickDayIv integerValue] )];

}
#pragma mark == 存储arr 删除动作
- (void)saveClickDayIvDataDeletInfoWithBtn:(UIButton *)sender{
    NSInteger theClickDayInt =  sender.tag -days_Btn_Tag;
    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
    NSString* theClickDayStr = [NSString stringWithFormat:@"%@-%0.2ld 00:00:00",strOfYearAndMonth,(long)theClickDayInt];
    NSString *theClickDayIv = [ToolOfTimeChangeFormat getTimeStrWithString:theClickDayStr];    //字符串转时间戳@"YYYY-MM-dd HH:mm:ss"
   // [self.saveClickDayIvNum removeObject:@( [theClickDayIv integerValue] )];
    
}
#pragma mark == 判断是否在7天内 (在內 则可以用这个数据) 暂时用天数来定01-08

- (BOOL)thisNewDayOfOtherDayIs7dBoolWithBtn:(UIButton *)sender{
    BOOL isMin7D = NO;
    
    
    if (  self.arrOfBtnClik.count == 0 ) {
        isMin7D = YES;
    }else if ( self.arrOfBtnClik.count == 1){
        NSInteger index = sender.tag - [self.arrOfBtnClik.firstObject integerValue];
        if (( index > 7 ) || ( index < -7  ) ) {
            isMin7D = NO;
        }else{
            isMin7D = YES;
        }
        
    }else if( self.arrOfBtnClik.count == 2){//取后一个比较 合理 则在后续会删除旧版firstObj
        NSInteger index = sender.tag - [self.arrOfBtnClik.lastObject integerValue];
        if (( index > 7 ) || ( index < -7  ) ) {
            isMin7D = NO;
        }else{
            isMin7D = YES;
        }
        
    }
    
    
    return isMin7D;
}
//- (BOOL)thisNewDayOfOtherDayIs7dBoolWithBtn:(UIButton *)sender{
//    NSInteger day7Iv = 7*24*60*60*1000;
//    BOOL isMin7D = NO;
//
//    NSInteger theClickDayInt =  sender.tag -days_Btn_Tag;
//    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
//    NSString* theClickDayStr = [NSString stringWithFormat:@"%@-%0.2ld 00:00:00",strOfYearAndMonth,(long)theClickDayInt];
//    NSString *theClickDayIv = [ToolOfTimeChangeFormat getTimeStrWithString:theClickDayStr];    //字符串转时间戳@"YYYY-MM-dd HH:mm:ss"
//
//    NSNumber *saveArrClikFirstObj = self.saveClickDayIvNum.firstObject;
//    NSNumber *saveArrClikLastObj = self.saveClickDayIvNum.lastObject;
//
//
//    //原无数据  yes允许
//    if ((saveArrClikFirstObj == 0 && saveArrClikLastObj == 0) || self.saveClickDayIvNum.count == 0) {
//        return YES;
//    }
//
//    //原只有一个数
//    if (  self.saveClickDayIvNum.count == 1 ) {
//        if ([theClickDayIv integerValue] < [saveArrClikFirstObj integerValue]) {//小于时 对比前7天
//            if ([theClickDayIv integerValue]  < [saveArrClikFirstObj integerValue]-day7Iv) {
//                isMin7D = NO;//时间差距过大 不在7天差距內
//            }else{
//                isMin7D = YES;
//            }
//        }else{//大于时 对比后7天
//            if ([theClickDayIv integerValue]  > [saveArrClikFirstObj integerValue]+day7Iv) {
//                isMin7D = NO;//时间差距过大 不在7天差距內
//            }else{
//                isMin7D = YES;
//            }
//        }
//   //原两个数据
//    }else if( self.saveClickDayIvNum.count == 2 ){
//        NSArray *sortedArray = [[NSMutableArray arrayWithObjects:saveArrClikFirstObj,saveArrClikLastObj,@( [theClickDayIv integerValue] ),nil]
//                                sortedArrayUsingSelector:@selector(compare:)];
//        NSLog(@"排序 sortedArray == %@ ;theClickDayIv = %@ ",sortedArray,theClickDayIv);
//        NSInteger thisClickDayInfoIndex = [sortedArray indexOfObject: @([theClickDayIv integerValue])];
//        NSLog(@"-thisClickDayInfoIndex ---%ld---",thisClickDayInfoIndex);
//
//        //
//        if (thisClickDayInfoIndex == 0) {//下标较小-- 比较第一个
//
//
//
//        }else if (thisClickDayInfoIndex == 1){//下标在中间 -- 比较第二个
//
//
//
//        }else if (thisClickDayInfoIndex == 2){//下标在后 -- 比较第二个
//
//
//
//        }
//
//    }
//
//
//
//    return isMin7D;
//}
 
#pragma mark === 多选 单选 没有选
//刷新多选UI
- (void)changeDaysSubBtnUIWithArr:(NSMutableArray *)arrOfClickTypeTag{
    //排序 取min max
    NSArray *newArr = [arrOfClickTypeTag sortedArrayUsingSelector:@selector(compare:)];
    NSInteger beginTagNum = [newArr.firstObject intValue];
    NSInteger endTagNum = [newArr.lastObject intValue];
 
//    [arrOfClickTypeTag removeAllObjects];
//    [arrOfClickTypeTag addObjectsFromArray:@[@(beginTagNum),@(endTagNum)]];//重新更新 以防多余数据 + 排序后的数据和原数据顺序不一样了 刷新的时候会保留新顺序 不建议
//    self.arrOfBtnClik = arrOfClickTypeTag;
    
    for (PopTimeSubBtnView *subBtnView in self.centerDaysBackView.subviews) {
        for (UIView *sub in subBtnView.subviews.firstObject.subviews) {//firstObject=backv
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                if (btn.tag<beginTagNum || btn.tag>endTagNum) {//nomal
                    btn.selected = NO;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Nomal];
                }else if(btn.tag==beginTagNum){//点击状态
                    btn.selected = YES;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Seleced_Begin];
                 }else if(btn.tag==endTagNum){//点击状态
                    btn.selected = YES;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Seleced_End];
                 }else{//在begin 和 end 之间的btn
                    btn.selected = NO;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_HeightLight];
                }
            }
        }
    }
}
//刷新单选
- (void)chanDaysSubBtnUIWithOneArrElement:(NSMutableArray *)arrOfClickTypeTag{
    NSInteger oneTagNum = [arrOfClickTypeTag.firstObject intValue];
    [arrOfClickTypeTag removeAllObjects];
    [arrOfClickTypeTag addObject:@(oneTagNum)];//重新更新 以防多余数据
    self.arrOfBtnClik = arrOfClickTypeTag;
    for (PopTimeSubBtnView *subBtnView in self.centerDaysBackView.subviews) {
        for (UIView *sub in subBtnView.subviews.firstObject.subviews) {//firstObject=backv
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                if (btn.tag<oneTagNum || btn.tag>oneTagNum) {//nomal
                    btn.selected = NO;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Nomal];
                }else if(btn.tag==oneTagNum){//点击状态
                    btn.selected = YES;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Seleced_Begin];
                }else{//预防多余数据
                    btn.selected = NO;
                    [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Nomal];
                }
            }
        }
    }
}
//刷新没有选择的 UI
- (void)chanDaysSubBtnUIWithNoArrElement:(NSMutableArray *)arrOfClickTypeTag{
    [arrOfClickTypeTag removeAllObjects];//重新更新 以防多余数据
    self.arrOfBtnClik = arrOfClickTypeTag;
    for (PopTimeSubBtnView *subBtnView in self.centerDaysBackView.subviews) {
        for (UIView *sub in subBtnView.subviews.firstObject.subviews) {//firstObject=backv
            if ([sub isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sub;
                btn.selected = NO;
                [subBtnView setBtnViewType:PopTimeSubBtnView_Type_Nomal];
                
            }
        }
    }
}
 
@end
