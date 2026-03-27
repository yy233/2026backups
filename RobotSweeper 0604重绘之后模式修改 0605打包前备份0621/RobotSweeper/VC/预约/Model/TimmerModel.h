//
//  TimmerModel.h
//  扫地机闹钟多表联查
//
//  Created by Joey on 2018/4/12.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimmerModel : NSObject
@property (nonatomic,assign) int ID;
@property (nonatomic, copy) NSString *robotJid;
@property (nonatomic, copy) NSString *timerJsonStr;
+ (LKDBHelper *)getUsingLKDBHelper;
@end
