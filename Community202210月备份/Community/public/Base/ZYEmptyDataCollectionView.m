//
//  ZYEmptyDataCollectionView.m
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import "ZYEmptyDataCollectionView.h"

@interface ZYEmptyDataCollectionView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation ZYEmptyDataCollectionView

#pragma mark -  无数据占位协议
- (void)emptyDataDelegate {
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
}

#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
// 标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyTitle;
    if (self.emptyTitle.length > 0) {
        emptyTitle = self.emptyTitle;
    }else {
        emptyTitle = @"暂无数据";
    }
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[UIColor zy_colorWithHexString:@"#6e727d"]
    };
    
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}

// 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    NSString *emptyImageName;
    if (self.emptyImageName.length > 0) {
        emptyImageName = self.emptyImageName;
    }else {
        emptyImageName = @"Nomal_ZeroWidthIcon";
    }
    
    return [UIImage imageNamed:emptyImageName];
}

// 垂直方向
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{

    return -50;
}

// 各个子控件垂直间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.emptyTitle.length > 0) {
        return 12;
    }else {
        return -10;
    }
}

// 是否允许滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

@end
