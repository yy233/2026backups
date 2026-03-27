//
//  PopViewChooseVisitTime.m
//  Community
//
//  Created by 余莹 on 2020/12/4.
//

#import "PopViewChooseVisitTime.h"


@interface PopViewChooseVisitTime ()

@end

@implementation PopViewChooseVisitTime
#pragma mark == 重写
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubAllView];
        [self setUI];
    }
    return self;
}

#pragma mark ==Btn Action
- (void)popViewSubBtnAction:(UIButton *)sender{
    switch (sender.tag) {
        case cancel_Btn_Tag:
        {
            [self dismissThePopView];
        }
            break;
        case ok_Btn_Tag:
        {
            [self okBtnAction:sender];//确定时间
        }
            break;
        case left_Btn_Tag:
        {
            [self lastMonth];//上月
        }
            break;
        case right_Btn_Tag:
        {
            [self nextMonth];//下月
        }
            break;
            
        default:
            break;
    }
}
#pragma mark === okBtnAction
- (void)okBtnAction:(UIButton *)sender{
   NSMutableArray *arrOfOkTime = [self calculateTimeStrArr];
    [self sendDelegateInfo:arrOfOkTime];
    [self dismissThePopView];
}
- (NSMutableArray *)calculateTimeStrArr{
    //时间
    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
    NSInteger beginDayInt = 0;
    NSInteger endDayInt = 0;
    NSString *beginStr = @"";
    NSString *endStr = @"";
    
    if (self.arrOfBtnClik.count==0) {
        //没有选择
    }else if (self.arrOfBtnClik.count==1){
        //单选1天
        beginDayInt = [self.arrOfBtnClik.firstObject integerValue]-days_Btn_Tag;
        beginStr = [NSString stringWithFormat:@"%@-%0.2ld",strOfYearAndMonth,(long)beginDayInt];//两位数据
       
    }else{
        //多选
        //排序
        NSArray *newArr = [self.arrOfBtnClik sortedArrayUsingSelector:@selector(compare:)];
        beginDayInt = [newArr.firstObject integerValue]-days_Btn_Tag;
        endDayInt = [newArr.lastObject integerValue]-days_Btn_Tag;
        beginStr = [NSString stringWithFormat:@"%@-%0.2ld",strOfYearAndMonth,(long)beginDayInt];
        endStr = [NSString stringWithFormat:@"%@-%0.2ld",strOfYearAndMonth,(long)endDayInt];//两位数据
    }
    NSMutableArray *arrOfOkTime = [NSMutableArray arrayWithObjects:beginStr,endStr, nil];
    DLog(@"");
    return arrOfOkTime;
   
}
- (void)sendDelegateInfo:(NSMutableArray *)arrOfChooseTime{
    if (_delegate && [_delegate respondsToSelector:@selector(popViewChooseVisitTimeChooseDayArr:)]) {
        [_delegate popViewChooseVisitTimeChooseDayArr:arrOfChooseTime];
    }
}
#pragma mark === btn click
- (void)daysBtnTouchAction:(UIButton *)sender{
    NSLog(@"daysBtnTouchAction %ld",(sender.tag-days_Btn_Tag));
    // 20211012 处理可选范围
    NSInteger theClickDayInt =  sender.tag -days_Btn_Tag;
    NSString *strOfYearAndMonth = [ToolOfTimeChangeFormat timeGetYearLineMonthFormatWithZnTimeYearMonthStr:self.centerShowMonthBtn.titleLabel.text];
    NSString* theClickDayStr = [NSString stringWithFormat:@"%@-%0.2ld 23:59:00",strOfYearAndMonth,(long)theClickDayInt];//两位数据 2021-10-06
    NSString *theClickDayIv = [ToolOfTimeChangeFormat getTimeStrWithString:theClickDayStr];    //字符串转时间戳@"YYYY-MM-dd HH:mm:ss"
    if ([theClickDayIv integerValue] < [ [ToolOfTimeChangeFormat currentTimeStr] integerValue]) {
        Y_SVP_SHOW_ERR_MES(@"不能选择今天之前的日期！");
        return;
    }
   //
    sender.selected = !sender.selected;
    [self checkThisBtnIsTwoSelectedOrOther:sender];
}
//查看当前days 已经点击的btn 数量。 btn 开始的tag 结束的tag
- (void)checkThisBtnIsTwoSelectedOrOther:(UIButton *)sender{
    if (sender.selected==YES) {//点击状态
        if (self.arrOfBtnClik.count==2) {
            [self.arrOfBtnClik removeObjectAtIndex:0];//删除存的第一个tag
        }
        [self.arrOfBtnClik addObject:@(sender.tag)];//arr总数2 or 1
        if (self.arrOfBtnClik.count==2) {
            //多选状态
            [self changeDaysSubBtnUIWithArr:self.arrOfBtnClik];
        }else{
            //单选状态
            [self chanDaysSubBtnUIWithOneArrElement:self.arrOfBtnClik];
        }
    }else{//取消状态
        if (self.arrOfBtnClik.count==2) {//已多选
            if ([self.arrOfBtnClik containsObject:@(sender.tag)]) {//是已经点击过的btn 处理成为单选UI和数据
                //删除
                for (NSNumber *number in self.arrOfBtnClik.reverseObjectEnumerator) {
                    if ([number intValue] == sender.tag) {
                        [self.arrOfBtnClik removeObject:number];
                    }
                }
                //刷新
                [self chanDaysSubBtnUIWithOneArrElement:self.arrOfBtnClik];
            }
        }else{//本就是单选 UI不处理 数据处理/处理成为单选UI和数据 未选择的
            if ([self.arrOfBtnClik containsObject:@(sender.tag)]) {//删除
                [self.arrOfBtnClik removeAllObjects];
                //刷新
                [self chanDaysSubBtnUIWithNoArrElement:self.arrOfBtnClik];
            }
        }
    }
    
    
    
}
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
#pragma mark == 日历 days view  计算部分
//当月 天数
- (NSInteger)getAllDaysNumOfThisMonth:(NSString *)strOfYearAndMonthStr{
     //days
    NSString *strOfNow = strOfYearAndMonthStr;
    NSArray *arrOfTime = [strOfNow componentsSeparatedByString:@"-"];
    NSInteger daysNum = [ToolOfTimeChangeFormat getSumOfDaysInMonth:arrOfTime.firstObject month:arrOfTime[1]];//当月天数 arrOfTime.last存在时不一定是月份 可能是日期
//    NSLog(@"getAllDaysNumOfThisMonth %@  %ld",strOfYearAndMonthStr,daysNum)
    return daysNum;
}
//第一天是周几
- (NSInteger)getOneDayIsWhatWeakNum:(NSString *)strOfYearAndMonthStr{
     //days
    NSString *strOfNow = strOfYearAndMonthStr;//年月 or 年月日
    NSDate *thisDate  = [ToolOfTimeChangeFormat dateOfYearMonthStr:strOfNow];//中间日期date 以防计算到上月
    NSString *strOfBeginDay = [ToolOfTimeChangeFormat getMonthFirstDayWithDate:thisDate format:@"yyyy-MM-dd"];//第一天daystr
    NSDate *dateOfBeginDay = [ToolOfTimeChangeFormat dateOfYearMonthDayStr:strOfBeginDay];//第一天day Data
    int thisMonthOneDayWhatWeekNum = (int)[ToolOfTimeChangeFormat getWeekDayFromDate:dateOfBeginDay];//第一天周几  //当月01号周几
    return thisMonthOneDayWhatWeekNum;

}

#pragma mark === 更新days addsubview
- (void)lastMonth{
    NSString *textStr =  self.centerShowMonthBtn.titleLabel.text;
    NSString *oldLineFormatStr =  [ToolOfTimeChangeFormat timeGetLineFormatWithZnTimeStr:textStr];//文本类型 改 分割线类型
    NSString *newStr = [ToolOfTimeChangeFormat getLastMonthWithYearAndMonthStr:oldLineFormatStr];//上月 分割线类型
    NSString *newTextStr =  [ToolOfTimeChangeFormat timeGetZNFormatWithLineTimeStr:newStr];//上月 文本类型
    [self reAddCenterDaysViewWithYearAndMonthStr:newStr];
    [self.centerShowMonthBtn setTitle:newTextStr forState:UIControlStateNormal];
}
- (void)nextMonth{
    NSString *textStr =  self.centerShowMonthBtn.titleLabel.text;
    NSString *oldLineFormatStr =  [ToolOfTimeChangeFormat timeGetLineFormatWithZnTimeStr:textStr];//文本类型 改 分割线类型
    NSString *newStr = [ToolOfTimeChangeFormat getNextMonthWithYearAndMonthStr:oldLineFormatStr];//下月 分割线类型
    NSString *newTextStr =  [ToolOfTimeChangeFormat timeGetZNFormatWithLineTimeStr:newStr];//下月 文本类型
    [self reAddCenterDaysViewWithYearAndMonthStr:newStr];
    [self.centerShowMonthBtn setTitle:newTextStr forState:UIControlStateNormal];
}

- (void)reAddCenterDaysViewWithYearAndMonthStr:(NSString*)strOfYearAndMonth{
    self.arrOfBtnClik = [NSMutableArray array];//更新tag
    [self.centerDaysBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//删除所有
    //days
    NSString *strOfNow = strOfYearAndMonth;
  
    NSInteger daysNum = [self getAllDaysNumOfThisMonth:strOfNow];
    int thisMonthOneDayWhatWeekNum = (int)[self getOneDayIsWhatWeakNum:strOfNow];//strOfNow yyyy-mm
    
    for (int i = thisMonthOneDayWhatWeekNum; i<daysNum+thisMonthOneDayWhatWeekNum; i++) {
        PopTimeSubBtnView *btnView = [[PopTimeSubBtnView alloc]init];
        btnView.btn.selected = NO;
        [btnView.btn setTitle:[NSString stringWithFormat:@"%d",i-thisMonthOneDayWhatWeekNum+1] forState:UIControlStateNormal];
        [btnView.btn setTitle:[NSString stringWithFormat:@"%d",i-thisMonthOneDayWhatWeekNum+1] forState:UIControlStateSelected];
        [btnView.btn addTarget:self action:@selector(daysBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        btnView.btn.tag = (i-thisMonthOneDayWhatWeekNum+1)+days_Btn_Tag;
        if (thisMonthOneDayWhatWeekNum==7) {// i = thisMonthOneDayWhatWeekNum 从星期x开始 星期天7 下移动一排 则y-1个H
            btnView.frame = CGRectMake(Width_WeakShow*((i)%7), Height_One_Day*floor(i/7.0 - 1), Width_WeakShow, Height_One_Day);
        }else{
            btnView.frame = CGRectMake(Width_WeakShow*((i)%7), Height_One_Day*floor((i)/7.0), Width_WeakShow, Height_One_Day);
        }
        [self.centerDaysBackView addSubview:btnView];
    }
}

#pragma mark == UI_add
- (void)addSubAllView{
    [self addSubBackV];
    [self addSubBottom];//底部
    [self addSubTopOne];
    [self addSubTopTwo];
    [self addSubCenterWeak];
    [self addSubCenterDay];

}
- (void)addSubBackV{
    [self.subMainBackView addSubview:self.bottomBackView];//底部提示
    [self.subMainBackView addSubview:self.topOneBackView];//来访时间
    [self.subMainBackView addSubview:self.topTwoBackView];//年月
    [self.subMainBackView addSubview:self.centerWeakBackView];//周
    [self.subMainBackView addSubview:self.centerDaysBackView];//日

}
- (void)addSubTopOne{
    [self.topOneBackView addSubview:self.cancelBtn];
    [self.topOneBackView addSubview:self.okBtn];
    [self.topOneBackView addSubview:self.titleLabel];
}
- (void)addSubTopTwo{
    [self.topTwoBackView addSubview:self.rightMonthBtn];
    [self.topTwoBackView addSubview:self.leftMonthBtn];
    [self.topTwoBackView addSubview:self.centerShowMonthBtn];
}
- (void)addSubCenterWeak{
    for (int i=0; i<7 ; i++) {
        UILabel *weakShowLabel =  [[UILabel alloc]init];
        weakShowLabel.text = [ToolOfTimeChangeFormat getWeakNameWordsWithNum:i];// [ToolOfTimeChangeFormat arrOfWeekStr];
        weakShowLabel.textAlignment = NSTextAlignmentCenter;
        weakShowLabel.font = [UIFont systemFontOfSize:11];
        if (i==0 || i==6) {
            weakShowLabel.textColor = Y_RGBA(255, 168, 43, 1);
        }else{
            weakShowLabel.textColor = Y_RGBA(43, 44, 47, 1);
        }
        weakShowLabel.frame = CGRectMake(i*Width_WeakShow, 0, Width_WeakShow, 20);
        [self.centerWeakBackView addSubview:weakShowLabel];
    }
}
- (void)addSubCenterDay{
    self.arrOfBtnClik = [NSMutableArray array];
    [self.centerDaysBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //days
    NSString *strOfNow = [ToolOfTimeChangeFormat shortStrOfnowTimeWithYearAndMonth];
  
    NSInteger daysNum = [self getAllDaysNumOfThisMonth:strOfNow];
    int thisMonthOneDayWhatWeekNum = (int)[self getOneDayIsWhatWeakNum:strOfNow];
    
    for (int i = thisMonthOneDayWhatWeekNum; i<daysNum+thisMonthOneDayWhatWeekNum; i++) {
        PopTimeSubBtnView *btnView = [[PopTimeSubBtnView alloc]init];
        btnView.btn.selected = NO;
        [btnView.btn setTitle:[NSString stringWithFormat:@"%d",i-thisMonthOneDayWhatWeekNum+1] forState:UIControlStateNormal];
        [btnView.btn setTitle:[NSString stringWithFormat:@"%d",i-thisMonthOneDayWhatWeekNum+1] forState:UIControlStateSelected];
        [btnView.btn addTarget:self action:@selector(daysBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
        btnView.btn.tag = (i-thisMonthOneDayWhatWeekNum+1)+days_Btn_Tag;
        if (thisMonthOneDayWhatWeekNum==7) {// i = thisMonthOneDayWhatWeekNum 从星期x开始 星期天7/7=1 --》（7-1）/7
            btnView.frame = CGRectMake(Width_WeakShow*((i)%7), Height_One_Day*floor(i/7.0 - 1), Width_WeakShow, Height_One_Day);
        }else{
            btnView.frame = CGRectMake(Width_WeakShow*((i)%7), Height_One_Day*floor((i)/7.0), Width_WeakShow, Height_One_Day);
        }
        [self.centerDaysBackView addSubview:btnView];
    }

}
- (void)addSubBottom{
    [self.bottomBackView addSubview:self.bottomTipBtn];
}

#pragma mark == UI_mas
- (void)setUI{
    [self setBackViewUI];
    [self setTopOneUI];
    [self setTopTwoUI];
    [self setCenterWeakUI];
    [self setCeneterDaysUI];
    [self setBottomUI];
   
}
- (void)setBackViewUI{
    [_topOneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topOneBackView.superview.mas_left);
        make.right.equalTo(_topOneBackView.superview.mas_right);
        make.top.equalTo(_topOneBackView.superview.mas_top);
        make.height.offset(40);
    }];
    [_topTwoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topTwoBackView.superview.mas_left);
        make.right.equalTo(_topTwoBackView.superview.mas_right);
        make.top.equalTo(_topOneBackView.mas_bottom);
        make.height.offset(40);
    }];
    [_centerWeakBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerWeakBackView.superview.mas_left).offset(16);
        make.right.equalTo(_centerWeakBackView.superview.mas_right).offset(-16);
        make.top.equalTo(_topTwoBackView.mas_bottom);
        make.height.offset(20);//weakLabel_h 20
    }];
    [_bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_bottomBackView.superview.mas_left);
//        make.right.equalTo(_bottomBackView.superview.mas_right);
        make.centerX.equalTo(_bottomBackView.superview);
        make.width.equalTo(_bottomBackView.superview).multipliedBy(0.5);
        make.height.offset(50);
        make.bottom.equalTo(_bottomBackView.superview.mas_bottom).offset(-30);
    }];
    //day
    [_centerDaysBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerDaysBackView.superview.mas_left).offset(16);
        make.right.equalTo(_centerDaysBackView.superview.mas_right).offset(-16);
        make.top.equalTo(_centerWeakBackView.mas_bottom);
        make.bottom.equalTo(_bottomBackView.mas_top);
    }];
}

- (void)setTopOneUI{
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelBtn.superview.mas_centerY);
        make.height.equalTo(_cancelBtn.superview.mas_height);
        make.left.equalTo(_cancelBtn.superview.mas_left).offset(16);
        make.width.offset(35);
    }];
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_cancelBtn.superview.mas_centerY);
        make.height.equalTo(_cancelBtn.superview.mas_height);
        make.right.equalTo(_cancelBtn.superview.mas_right).offset(-16);
        make.width.offset(35);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.superview.mas_centerY);
        make.height.equalTo(_titleLabel.superview.mas_height);
        make.left.equalTo(_cancelBtn.mas_right);
        make.right.equalTo(_okBtn.mas_left);
     }];
}
- (void)setTopTwoUI{
    [_leftMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftMonthBtn.superview.mas_centerY);
        make.height.equalTo(_leftMonthBtn.superview.mas_height);
        make.left.equalTo(_leftMonthBtn.superview.mas_left).offset(16);
        make.width.offset(35);
    }];
    [_rightMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightMonthBtn.superview.mas_centerY);
        make.height.equalTo(_rightMonthBtn.superview.mas_height);
        make.right.equalTo(_rightMonthBtn.superview.mas_right).offset(-16);
        make.width.offset(35);
    }];
    [_centerShowMonthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_centerShowMonthBtn.superview.mas_centerY);
        make.height.equalTo(_centerShowMonthBtn.superview.mas_height);
        make.left.equalTo(_leftMonthBtn.mas_right);
        make.right.equalTo(_rightMonthBtn.mas_left);
    }];
}
- (void)setCenterWeakUI{
    
}
- (void)setCeneterDaysUI{
   
}
- (void)setBottomUI{
    [_bottomTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomTipBtn.superview.mas_centerY);
        make.centerX.equalTo(_bottomTipBtn.superview.mas_centerX);
        make.height.offset(35);
        make.width.offset(120);
    }];
}
#pragma mark == getter
// top 1
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.tag = cancel_Btn_Tag;
    }
    return _cancelBtn;
}
- (UIButton *)okBtn{
    if (!_okBtn) {
        _okBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_okBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _okBtn.tag = ok_Btn_Tag;
    }
    return _okBtn;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"选择来访时间";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
// top 2
- (UIButton *)leftMonthBtn{
    if (!_leftMonthBtn) {
        _leftMonthBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftMonthBtn setImage:[ThemeImg themeImageWithBaseName:@"Visitingtime_Popup_Left_night"] forState:UIControlStateNormal];
        [_leftMonthBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftMonthBtn.tag = left_Btn_Tag;
    }
    return _leftMonthBtn;
}
- (UIButton *)rightMonthBtn{
    if (!_rightMonthBtn) {
        _rightMonthBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightMonthBtn setImage:[ThemeImg themeImageWithBaseName:@"Visitingtime_Popup_Right_night"] forState:UIControlStateNormal];
        [_rightMonthBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightMonthBtn.tag = right_Btn_Tag;
    }
    return _rightMonthBtn;
}

- (UIButton *)centerShowMonthBtn{//年月
    if (!_centerShowMonthBtn) {
        _centerShowMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_centerShowMonthBtn setTitle:[ToolOfTimeChangeFormat shortStrOfNowTimeWithYearAndMonthCN] forState:UIControlStateNormal];
        [_centerShowMonthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _centerShowMonthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _centerShowMonthBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_centerShowMonthBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerShowMonthBtn;
}
// bottom
- (UIButton *)bottomTipBtn{
    if (!_bottomTipBtn) {
        _bottomTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomTipBtn setTitle:@"可单选和多选" forState:UIControlStateNormal];
        [_bottomTipBtn setBackgroundColor:[UIColor grayColor]];
        _bottomTipBtn.layer.cornerRadius = 5;
        _bottomTipBtn.layer.masksToBounds = YES;
        [_bottomTipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomTipBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomTipBtn addTarget:self action:@selector(popViewSubBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomTipBtn;
}
#pragma mark == backv
- (UIView *)topOneBackView{
    if (!_topOneBackView) {
        _topOneBackView = [[UIView alloc]init];
    }
    return _topOneBackView;
}
- (UIView *)topTwoBackView{
    if (!_topTwoBackView) {
        _topTwoBackView = [[UIView alloc]init];
    }
    return _topTwoBackView;
}
- (UIView *)centerWeakBackView{
    if (!_centerWeakBackView) {
        _centerWeakBackView = [[UIView alloc]init];
    }
    return _centerWeakBackView;
}
- (UIView *)centerDaysBackView{
    if (!_centerDaysBackView) {
        _centerDaysBackView = [[UIView alloc]init];
    }
    return _centerDaysBackView;
}
- (UIView *)bottomBackView{
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc]init];
    }
    return _bottomBackView;
}

#pragma mark == 内容高度 重写
- (void)initSubMainHeight{
//    self.subMainViewHeight  = Screen_H*0.8;
//    self.subMainViewHeight  = 30+30+20+50+300+5;
    //1027 高度增加 最多6行 时 和bottom同一水平线 不好点击
    self.subMainViewHeight  = 30+30+20+50+300+5+kGHSafeAreaBottomHeight;
}

- (NSMutableArray *)arrOfBtnClik{
    if (!_arrOfBtnClik) {
        _arrOfBtnClik = [NSMutableArray arrayWithCapacity:0];
    }
    return _arrOfBtnClik;
}
- (NSMutableArray *)saveClickDayIvNum{
    if (!_saveClickDayIvNum) {
        _saveClickDayIvNum = [NSMutableArray arrayWithCapacity:0];
    }
    return _saveClickDayIvNum;
}
@end
