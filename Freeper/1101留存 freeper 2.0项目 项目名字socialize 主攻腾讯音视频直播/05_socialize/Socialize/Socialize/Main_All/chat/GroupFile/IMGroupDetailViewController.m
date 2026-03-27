//
//  IMGroupDetailViewController.m
//  Socialize
//
//  Created by 余莹 on 2023/5/18.
//  群详情
 
#import "IMGroupDetailViewController.h"
#import "TUIGroupService_Minimalist.h"
#import "TUIGroupInfoController_Minimalist.h"
 
@interface IMGroupDetailViewController ()

@end

@implementation IMGroupDetailViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    TUIGroupInfoController_Minimalist *vc = [[TUIGroupInfoController_Minimalist alloc]init];
    vc.groupId = self.groupId;
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
    
}
@end
