//
//  SucceedSearchGetWifiViewController.h
//  RobotSweeper
//
//  Created by Joey on 2018/1/30.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SucceedSearchGetWifiViewController : UIViewController
@property (nonatomic,strong) NSString *strOfMachineName;

@property (nonatomic,strong) NSString *addressOfTcpStr;
@property (nonatomic,assign) UInt16 portOfTcp;

@property (nonatomic,strong) NSString *wifiOurStr;
@property (weak, nonatomic) IBOutlet UITextField *wifiNameTextF;
@end
