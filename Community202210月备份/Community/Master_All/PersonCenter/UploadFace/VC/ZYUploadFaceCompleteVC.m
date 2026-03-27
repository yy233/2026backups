//
//  ZYUploadFaceCompleteVC.m
//  Community
//
//  Created by ZY on 2021/8/11.
//

#import "ZYUploadFaceCompleteVC.h"
#import "ZYUploadFaceVC.h"
#import "ZYUploadFaceCompleteView.h"
#import "ZYUploadFaceBottomView.h"

@interface ZYUploadFaceCompleteVC ()

@property (nonatomic, strong) ZYUploadFaceCompleteView *uploadFaceCompleteView;

@property (nonatomic, strong) ZYUploadFaceBottomView *uploadFaceBottomView;

@end

@implementation ZYUploadFaceCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传人脸";
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self navigationBarStyleWithThemeColorChanged:[ZYThemeManager shareManager].navigationBarBackgroundThemeColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSMutableArray *mVc = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYUploadFaceVC class]]) {
            [mVc removeObject:vc];
        }
    }
    self.navigationController.viewControllers = [mVc copy];
}

- (void)setUI {
    
    [self.view addSubview:self.uploadFaceBottomView];
    [_uploadFaceBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_uploadFaceBottomView.superview);
        make.bottom.equalTo(_uploadFaceBottomView.superview).offset(-button_bottom_height);
        make.height.offset(90);
    }];
    [self.view addSubview:self.uploadFaceCompleteView];
    [self.uploadFaceCompleteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_uploadFaceCompleteView.superview);
        make.bottom.equalTo(_uploadFaceBottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYUploadFaceCompleteView *)uploadFaceCompleteView {
    if (!_uploadFaceCompleteView) {
        _uploadFaceCompleteView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceCompleteView" owner:nil options:nil].lastObject;
    }
    
    return _uploadFaceCompleteView;
}

- (ZYUploadFaceBottomView *)uploadFaceBottomView {
    if (!_uploadFaceBottomView) {
        _uploadFaceBottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYUploadFaceBottomView" owner:nil options:nil].lastObject;
        [_uploadFaceBottomView.okButton setTitle:@"完成" forState:UIControlStateNormal];
        [_uploadFaceBottomView.okButton addTarget:self action:@selector(okButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadFaceBottomView;
}

#pragma mark - 点击事件
// 确认
- (void)okButtonClicked {
    
    [self popVC];
}

@end
