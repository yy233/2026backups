//
//  CreateQrCodeViewController.m
//  二维码相关添加扫地机demo
//
//  Created by Joey on 2018/5/9.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "CreateQrCodeViewController.h"
//屏幕宽高
#define Y_mainW [UIScreen mainScreen].bounds.size.width
#define Y_mainH [UIScreen mainScreen].bounds.size.height

@interface CreateQrCodeViewController ()

@property (nonatomic, strong) NSString *strOfThisRobotInfo;

@property (nonatomic, strong) NSString *strOfThisRobotNickName;
@property (nonatomic, strong) UIImageView * qrCodeImageView;
@property (nonatomic, strong) UILabel *qrCodeLabel;
@end

@implementation CreateQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"设备分享", nil) ;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initView];
}
- (void)initData{
    NSString *strOfRobotJid = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    NSString *nickNmae = @"";
    NSString *typeStr  = @"";
//     NSString *strOfRobotJid = @"010101001006e0500722b";
//      NSString *nickNmae = @"722b的扫地机";
    NSMutableArray *arrOflist = [NSMutableArray arrayWithArray: [UserTool sharedUserTool].listOfRobotsArr];
    for ( NSDictionary *dicOfRobot in arrOflist) {
        if ([[dicOfRobot objectForKey:@"eqOpfJid"]  isEqualToString:strOfRobotJid]) {
            nickNmae = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"nickName"]];
            typeStr = [NSString stringWithFormat:@"%@",[dicOfRobot objectForKey:@"eqType"]];
        }
    }
    if([nickNmae isEqualToString: @""]||nickNmae==nil){
        nickNmae = @"";
    }
    if ([typeStr isEqualToString:@""]||typeStr==nil) {
        typeStr = @"00";
    }
    if(typeStr.length==1 && [typeStr intValue]<=9){
        typeStr = [NSString stringWithFormat:@"0%@",typeStr];
    }
    _strOfThisRobotNickName = nickNmae;
    if ([_strOfThisRobotNickName isEqualToString: @""]) {
        nickNmae = [ShareUser sharedUserInfo].userMode.nowRobotJid;
    }
//    _strOfThisRobotInfo = [NSString stringWithFormat:@"ROBOTJID %@ nickNmae %@",strOfRobotJid,nickNmae];//协议修改之前的二维码数据
    
    /**当前二维码协议
     ROBOTJID:jid;NICKNAME:昵称;TYPE:01
     */
    _strOfThisRobotInfo = [NSString stringWithFormat:@"ROBOTJID:%@;NICKNAME:%@;TYPE:%@",strOfRobotJid,nickNmae,typeStr];
    NSLog(@"_strOfThisRobotInfo999999 ===%@",_strOfThisRobotInfo);
}
- (void)initView{
     [self.view addSubview:self.qrCodeImageView];
     [self.view addSubview:self.qrCodeLabel];
     [self logoQrCode];
}
//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@",filters);
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    //    字符串可以随意换成网址等
    NSData *qrImageData = [_strOfThisRobotInfo dataUsingEncoding:NSUTF8StringEncoding];
    
    //我们可以打印,看过滤器的 输入属性.这样我们才知道给谁赋值
    NSLog(@"%@",qrImageFilter.inputKeys);
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
//    UIImage *sImage = [UIImage imageNamed:@"Snip20160715_4"];
//    
//    CGFloat sImageW = 100;
//    CGFloat sImageH= sImageW;
//    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
//    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
//    
//    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    //设置图片
    self.qrCodeImageView.image = finalyImage;
}

-(UIImageView *)qrCodeImageView{
    if(_qrCodeImageView == nil){
        
        _qrCodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Y_mainW-60, Y_mainW-60)];
        _qrCodeImageView.center = self.view.center;
        
    }
    return _qrCodeImageView;
}
- (UILabel *)qrCodeLabel{
    if (!_qrCodeLabel) {
        _qrCodeLabel = [[UILabel alloc]init];
        _qrCodeLabel.frame = CGRectMake(0, 0, Y_mainW-60, 80);
        _qrCodeLabel.center = CGPointMake(Y_mainW*0.5, Y_mainH*0.5+Y_mainW*0.5+45);
        _qrCodeLabel.numberOfLines = 4;
        NSString *strofone = NSLocalizedString(@"扫描二维码，即可绑定这台设备", nil) ;
        _qrCodeLabel.text = [NSString stringWithFormat:@"%@\n%@",strofone,_strOfThisRobotNickName];
        _qrCodeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _qrCodeLabel;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
