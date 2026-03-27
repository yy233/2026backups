//
//  MyOrderTopSearchView.m
//  Community
//
//  Created by 余莹 on 2021/2/7.
//

#import "MyOrderTopSearchView.h"

@implementation MyOrderTopSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Color_245Gray;
        [self addSubview:self.searchBar];
    }
    return self;
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W-16-50, 32)];
        _searchBar.layer.cornerRadius = 16;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索我的订单";
        _searchBar.tintColor = [UIColor blackColor];
    }
    return _searchBar;
}
@end
