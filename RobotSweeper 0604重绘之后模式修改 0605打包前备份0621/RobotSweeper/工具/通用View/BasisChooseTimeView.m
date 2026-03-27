//
//  BasisChooseTimeView.m
//  OA
//
//  Created by yy on 17/6/26.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "BasisChooseTimeView.h"

@implementation BasisChooseTimeView

-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setIsPrecision:(BOOL)isPrecision{
    _isPrecision = isPrecision;
    if (isPrecision) {
        _dataPicker.datePickerMode  = UIDatePickerModeDateAndTime;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
        NSString *strOfbeginTime = [NSString stringWithFormat:@"%@ 08:30",[ToolOfBasic nowTime]];
        NSDate *dateOfb = [dateFormatter dateFromString:strOfbeginTime];
        _dataPicker.date = dateOfb;
        _strOftime = strOfbeginTime;
        
    }else{
        _dataPicker.datePickerMode  = UIDatePickerModeDate;
        _strOftime = [ToolOfBasic nowTime];
       
    }
  
    _dataPicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    [ _dataPicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)dateChanged{
    NSDate *theDate = _dataPicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (_isPrecision == YES) {
        //          dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
        dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm";
    }else{
        dateFormatter.dateFormat = @"YYYY-MM-dd";
    }
    NSLog(@"时间＝＝%@",[dateFormatter stringFromDate:theDate]);
    NSString *str = [dateFormatter stringFromDate:theDate];        _strOftime = str;
    
}
- (IBAction)btnOfOkAction:(UIButton *)sender {
    if (_delegateOfTime && [_delegateOfTime respondsToSelector:@selector(dateOfDidSelect:)]) {
        [_delegateOfTime dateOfDidSelect:_strOftime];
    }
 
}

- (IBAction)btnOfRemoveSelf:(UIButton *)sender {
    if (_delegateOfTime && [_delegateOfTime respondsToSelector:@selector(removeBasisChooseTimeView)]) {
        [_delegateOfTime removeBasisChooseTimeView];
    }
}

@end
