//
//  ListManager.m
//  扫地机闹钟多表联查
//
//  Created by Joey on 2018/4/12.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ListManager.h"
#import "TimmerModel.h"

@interface ListManager()


@end
@implementation ListManager

+ (BOOL)addTimerWithModel:(TimmerModel*)timmerModel{
   BOOL add = [timmerModel saveToDB];
    return add;
}
+ (BOOL)deleteTimerWithModel:(TimmerModel*)timmerModel{
   
    BOOL delt = [timmerModel deleteToDB];
    return delt;
}
+ (BOOL)changeTimerWithModel:(TimmerModel*)timmerModel
                withNewModel:(TimmerModel *)newTimerModel{
    // 字符串的条件要用''
    NSString *newtimerJsonStr = [NSString stringWithFormat:@"timerJsonStr = '%@'",newTimerModel.timerJsonStr];
    NSString *whereStr = [NSString stringWithFormat: @"robotJid = '%@' and timerJsonStr = '%@'" ,timmerModel.robotJid,timmerModel.timerJsonStr];
    BOOL isUpdate =  [[TimmerModel getUsingLKDBHelper] updateToDB:[TimmerModel class] set:newtimerJsonStr Condtion: whereStr];
    NSLog(@"change======%@  %@",newtimerJsonStr,whereStr);
    if ( isUpdate ) {
        NSLog(@"更新成功");
        return YES;
        
    }else{
        NSLog(@"更新失败");
        return NO;
    }
}
+ (NSMutableArray *)searchTimerWithRobot:(NSString *)robotJid{
        
    NSString *sql1 = [NSString stringWithFormat:@"select * from TimmerModel where robotJid is '%@' ",[ShareUser sharedUserInfo].userMode.nowRobotJid];//06de0 nowJid
    //    NSString *sql1 = [NSString stringWithFormat:@"select * from TimerList"];//06de0 nowJid
    
    NSMutableArray *arrOfListSource = [NSMutableArray array];
     arrOfListSource = [[TimmerModel getUsingLKDBHelper] searchWithSQL:sql1 toClass:[TimmerModel class]];
    
    NSLog(@"********** 查找表TimmerModel所有nowJid记录 \n");
    for (id obj in arrOfListSource) {
        [obj printAllPropertys];
    }
    return arrOfListSource;
}



@end
