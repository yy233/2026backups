//
//  MachineModel.h
//  RobotSweeper
//
//  Created by Joey on 2018/1/31.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MachineModel : NSObject
//@{@"name":@"lmc@robotleo",@"pass":@"123456",@"nameOfM":@"1"}];
/*list =     (
 {
 eqCreateTime = "2018-02-24 10:43:50.0";
 eqGuID = 9b92fc2406b349eab7ec4a20c29fce52;
 eqHardwareSerial = qwert;
 eqOpfJid = qwert;
 id = 6;
 }
 );*/

//@property (nonatomic,copy) NSString *name;
//@property (nonatomic,copy) NSString *pass;
//@property (nonatomic,copy) NSString *nameOfM;


@property (nonatomic,copy) NSString *eqHardwareSerial;
@property (nonatomic,copy) NSString *eqCreateTime;
@property (nonatomic,copy) NSString *eqGuID;
@property (nonatomic,copy) NSString *eqOpfJid;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *nickName;
@end
