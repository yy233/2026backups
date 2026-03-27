//
//  CopyrightInfoViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/11/5.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "CopyrightInfoViewController.h"

@interface CopyrightInfoViewController ()
@property (nonatomic,strong)UITextView *textViewOfCopyrightInfo;
@property (nonatomic,strong)NSString *strOfdataS;
@end

@implementation CopyrightInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"版权信息",nil);
    self.view.backgroundColor = [DataManager shareDataManager].colorOfGroupGrayBack;
    [self initData];
    [self initView];
   
}
- (void)initData{
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle]pathForResource:NSLocalizedString(@"版权信息1.0", nil) ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"====%@",error.localizedDescription);
        _strOfdataS = error.localizedDescription;
    } else {
        
    }
    _strOfdataS = content;
   
    
    /**
     {Copyright © 2019 Beijing Robotleo Intelligent Technology Co,.Ltd. All rights reserved.}
     
     
     本应用的所有内容，包括但不限于文字、图片、音频、视频、软件、程序、以及版式设计等来源为搜集和原创。
     
     使用者可将本应用提供的内容或服务用于个人学习、研究或欣赏，以及其他非商业性或非盈利性用途，但同时应遵守著作权法及其他相关法律的规定，不得侵犯本公司及相关权利人的合法权利，包括但不限于：擅自复制、链接、非法使用或转载，或以任何方式建立镜像。除此以外，将本应用任何内容或服务用于其他用途时，须征得本公司及相关权利人的书面许可，并支付报酬。
     
     电子邮箱: leidongyunhe@robotleo.com*/
}
- (void)initView{
    [self.view addSubview:self.textViewOfCopyrightInfo];
    _textViewOfCopyrightInfo.text = _strOfdataS;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITextView *)textViewOfCopyrightInfo{
    if (!_textViewOfCopyrightInfo) {
        _textViewOfCopyrightInfo = [[UITextView alloc]init];
        _textViewOfCopyrightInfo.frame = self.view.frame;
//        _textViewOfCopyrightInfo.frame = CGRectMake(20, 20, Y_mainW-40, Y_mainH-40);
        _textViewOfCopyrightInfo.textContainerInset = UIEdgeInsetsMake(10, 20, 20, 10);
        _textViewOfCopyrightInfo.editable = NO;
        _textViewOfCopyrightInfo.font = [UIFont systemFontOfSize:14];
        _textViewOfCopyrightInfo.backgroundColor = [UIColor clearColor];
    }
    return _textViewOfCopyrightInfo;
}
@end
