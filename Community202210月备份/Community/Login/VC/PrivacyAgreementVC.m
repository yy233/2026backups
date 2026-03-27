//
//  PrivacyAgreementVC.m
//  Community
//
//  Created by 余莹 on 2020/11/9.
//

#import "PrivacyAgreementVC.h"

@interface PrivacyAgreementVC ()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailTitleLabel;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UILabel *bottomNameTitleLabel;
@end

@implementation PrivacyAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self setupNavigationBarStyleWithMainColor];
}
//- (void)setupNavigationBarTransparentStyle {
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
//        NSForegroundColorAttributeName:[UIColor whiteColor]
//    }];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTranslucent:YES];
//    
//}

#pragma mark == 主题色 notice
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithMainColor];
     dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].loginModulethemeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
    });
    [self initView];
}
- (void)initView{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.detailTitleLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.bottomNameTitleLabel];
    [self setUI];
}
- (void)setUI{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.superview.mas_top).offset(0);
        make.left.equalTo(_titleLabel.superview.mas_left).offset(16);
        make.right.equalTo(_titleLabel.superview.mas_right).offset(-16);
        make.height.offset(40);
    }];
    [_detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.offset(40);
    }];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(_textView.superview.mas_left).offset(16);
        make.right.equalTo(_textView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_textView.superview.mas_bottom).offset(-50);
    }];
    [_bottomNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).offset(10);
        make.left.equalTo(_textView.superview.mas_left).offset(16);
        make.right.equalTo(_textView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_textView.superview.mas_bottom).offset(-20);
    }];
}
#pragma mark ====
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:32];
        _titleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"隐私政策";
    }
    return _titleLabel;
}
- (UILabel *)detailTitleLabel{
    if (!_detailTitleLabel) {
        _detailTitleLabel = [[UILabel alloc]init];
        _detailTitleLabel.font = [UIFont systemFontOfSize:13];
        _detailTitleLabel.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _detailTitleLabel.textAlignment = NSTextAlignmentLeft;
        _detailTitleLabel.numberOfLines = 2;
        _detailTitleLabel.text = @"《隐私政策》";
    }
    return _detailTitleLabel;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.editable = NO;
        _textView.textColor = [ThemeManager shareManager].loginModuleTextColor;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.text = @"在此特别提醒您（用户）在注册成为用户之前，请认真阅读本《用户协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。您的注册、登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束。本协议约定重庆纵横世纪科技有限公司与用户之间关于“未来物服”软件服务（以下简称“服务“）的权利义务。“用户”是指注册、登录、使用本服务的个人。本协议可由未来物服随时更新，更新后的协议条款一旦公布即代替原来的协议条款，恕不再另行通知，用户可在本APP中查阅最新版协议条款。在修改协议条款后，如果用户不接受修改后的条款，请立即停止使用未来物服提供的服务，用户继续使用服务将被视为接受修改后的协议。";
    }
    return _textView;
}
- (UILabel *)bottomNameTitleLabel{
    if (!_bottomNameTitleLabel) {
        _bottomNameTitleLabel = [[UILabel alloc]init];
        _bottomNameTitleLabel.text = @"重庆纵横世纪科技有限公司";
        _bottomNameTitleLabel.font = [UIFont systemFontOfSize:11];
        _bottomNameTitleLabel.textColor = Y_RGBA(110, 114, 125, 1);
        _bottomNameTitleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _bottomNameTitleLabel;
}
@end
