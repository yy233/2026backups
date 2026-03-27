//
//  TrajectoryViewData.m
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/16.
//  Copyright © 2019 余莹. All rights reserved.
//

static NSString *kNoticeNameWithUpdateTrajectView=@"kNoticeNameWithUpdateTrajectView";

@implementation TrajectoryViewData
//轨迹数据变化 
+ (void)changeTrajectoryPointArrWithXmppinfoStr:(NSString *)xmppstr
                                       mapScale:(CGFloat)mapScaleFloat{//倍数关系暂时没有使用
    if (xmppstr.length>0) {
        if([xmppstr isEqualToString:kNoticeNameWithUpdateTrajectView]){
            [self postNoticeUpTrajV];
            return;
        }
    }else{
        return;
    }
    NSMutableArray *arrOfMsg = [[xmppstr componentsSeparatedByString:@" "] mutableCopy];
    [arrOfMsg removeObjectAtIndex:0];//协议头
    int numOfTrajectXmppinfo = [arrOfMsg.firstObject intValue];//序号
    [arrOfMsg removeObjectAtIndex:0];//只保留轨迹pxpy数据
  
    
    if(numOfTrajectXmppinfo==0){
        [DataManager shareDataManager].trajectoryNum = 0;//置空
        [DataManager shareDataManager].trajectorySourceArr = [NSMutableArray array];
        [TrajectoryViewData getDataSourceArrOfXmppTrajectArr:arrOfMsg];  //处理数据
        [DataManager shareDataManager].trajectoryNum += 1;//自增
         NSLog(@"轨迹 0 ");
    }else if ([DataManager shareDataManager].trajectoryNum == numOfTrajectXmppinfo) {
        [TrajectoryViewData getDataSourceArrOfXmppTrajectArr:arrOfMsg];  //处理数据
        [DataManager shareDataManager].trajectoryNum += 1;
         NSLog(@"轨迹 连续 %d",numOfTrajectXmppinfo);
    }else{
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
        NSLog(@"轨迹 不连续 请求地图request_map");
    }
}

+(void)getDataSourceArrOfXmppTrajectArr:(NSMutableArray *)arrOfxmppTrajectInfo{//x y x y...
    
    NSMutableArray *newTrajectPointArr = [NSMutableArray array];//元素为pvalue
    if (newTrajectPointArr.count%2 != 0) {
        [[XmppManager shareXmppManager]sendMessageToRobotWithMessage:@"request_map"];
          NSLog(@"轨迹 数据错误 请求地图request_map");
        return;//错误的数据 缺少y 不能匹配成点
    }
    
    /**在绘画时处理成新数据 当前只保留得到的xmpp对应值？ 因为x y 00 原点会变化
      */
    //得到新数据
    for (int i = 0; i < arrOfxmppTrajectInfo.count; i++) {
        if (i%2==0) {
            CGFloat  x = [arrOfxmppTrajectInfo[i] floatValue];
            CGFloat  y = [arrOfxmppTrajectInfo[i+1] floatValue];
            [newTrajectPointArr addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
    }
    [[DataManager shareDataManager].trajectorySourceArr addObjectsFromArray: newTrajectPointArr];
    
    //p1(xy) p2(xy)....
    //trajectorySourceArr加入新元素
    [self postNoticeUpTrajV];
}
#pragma mark -----------------------------------------通知更新--------
+ (void)postNoticeUpTrajV{
    
    //通知更新UI
//    NSLog(@"轨迹 allArr.count=%ld ",[DataManager shareDataManager].trajectorySourceArr.count);
    [[NSNotificationCenter defaultCenter]postNotificationName:kTrajectNoticeStr object:nil];
}


@end
