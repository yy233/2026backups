//
//  ZYBannerDetailVc.m
//  Community
//
//  Created by ZY on 2021/4/28.
//

#import "ZYBannerDetailVc.h"

@interface ZYBannerDetailVc () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ZYBannerDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setUI {
    
    self.statusHeightConstraint.constant = status_height;
    [self.contentView addSubview:self.scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView.superview);
    }];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44 - status_height)];
        UIImage *image = [UIImage imageNamed:@"banner_detail"];
        CGSize imageSize = image.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW / imageSize.width * imageSize.height)];
        imageView.image = image;
        [_scrollView addSubview:imageView];
        _scrollView.contentSize = imageView.bounds.size;
    }
    
    return _scrollView;
}

#pragma mark - 处理点击事件
- (IBAction)backButtonClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
