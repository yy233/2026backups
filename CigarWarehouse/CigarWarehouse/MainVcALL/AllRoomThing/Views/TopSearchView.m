//
//  TopSearchView.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/18.
//

#import "TopSearchView.h"

@implementation TopSearchView
 
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_searchBar.superview).offset(-50);
            make.top.bottom.centerX.equalTo(_searchBar.superview);
        }];
    }
    return self;
}
 

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"可在已有列表数据里搜索名字、产地、拥有者";
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.barTintColor = UIColor.whiteColor;
        _searchBar.showsCancelButton =  YES;
        if (@available(iOS 13.0, *)) {
//            _searchBar.searchTextField.backgroundColor = ;
        }
        [self changeCancelUI];
        UITextField  *seachTextFild = [_searchBar valueForKey:@"searchField"];
        //修改字体颜色
        //seachTextFild.textColor = [UIColor redColor];
        //修改字体大小
        seachTextFild.font = [UIFont systemFontOfSize:13];
        
    }
    return _searchBar;
}

- (void)changeCancelUI{
    
    UIButton *cancelButton = (UIButton *)[self findSubViewWithSubClassName:NSStringFromClass([UIButton class]) inMainView:self.searchBar];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton newAnBtnWithFont:FontSize_Nomail(12.0)];
    [cancelButton setTitleColor:CC_Brown_B   forState:UIControlStateNormal];
}


- (UIView *)findSubViewWithSubClassName:(NSString *)className inMainView:(UIView *)view{
    Class specificView = NSClassFromString(className);
    if ([view isKindOfClass:specificView]) {
        return view;
    }
    if (view.subviews.count > 0) {
        for (UIView *subView in view.subviews) {
            UIView *targetView = [self findSubViewWithSubClassName:className inMainView:subView];
            if (targetView != nil) {return targetView;
            }
        }
    }
    return nil;
}

@end
