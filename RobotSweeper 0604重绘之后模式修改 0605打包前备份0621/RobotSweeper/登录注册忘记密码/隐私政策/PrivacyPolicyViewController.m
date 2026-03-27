//
//  PrivacyPolicyViewController.m
//  RobotSweeper
//
//  Created by Joey on 2018/8/21.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()
@property (nonatomic,strong)NSString *strOfContent;
@property (nonatomic,strong)UITextView *textViewOfP;

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"权限详情", nil);//Permissions for details
    [self initData];
    [self initView];
}
- (void)initData{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"用户许可使用协议和隐私政策" ofType:@"txt"];
//    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    if (self.title.length<5) {//中文 0103
        NSError *error;
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"用户许可使用协议和隐私政策1.0" ofType:@"txt"];
        
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"====%@",error.localizedDescription);
            _strOfContent = error.localizedDescription;
        } else {
            
        }
        _strOfContent = content;
    }else{//EN
        NSError *errorEN;
        NSString *pathEN = [[NSBundle mainBundle]pathForResource:@"userprivacyagreement_en" ofType:@"txt"];
        NSString *contentEN = [NSString stringWithContentsOfFile:pathEN encoding:NSUTF8StringEncoding error:&errorEN];
        
        if (errorEN) {
            NSLog(@"====%@",errorEN.localizedDescription);
            _strOfContent = errorEN.localizedDescription;
        }
        _strOfContent = contentEN;
    }
}
- (void)initView{

    [self.view addSubview:self.textViewOfP];
    _textViewOfP.text = _strOfContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- getter
- (UITextView *)textViewOfP{
    if (!_textViewOfP) {
        _textViewOfP = [[UITextView alloc]init];
        _textViewOfP.frame = self.view.frame;
    }
    return _textViewOfP;
}

@end
