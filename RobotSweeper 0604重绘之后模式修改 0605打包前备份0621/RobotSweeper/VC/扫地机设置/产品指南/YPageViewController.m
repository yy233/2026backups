//
//  YPageViewController.m
//  分页控件练习
//
//  Created by Joey on 2018/5/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "YPageViewController.h"
#import "ContentViewController.h"

@interface YPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic,strong) UIPageViewController *pageViewCtrl;//是iOS 5.0之后提供的一个分页控件可以实现图片轮播效果和翻书效果
@property (nonatomic, strong) NSArray *pageContentArray;
@end

@implementation YPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品指南";
    self.view.backgroundColor = [UIColor whiteColor];
    [self pagevcCreat];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pagevcCreat{

  
     /*     设置UIPageViewController的配置项
      
       1 过渡样式style :UIPageViewControllerTransitionStylePageCurl卷轴
                     UIPageViewControllerTransitionStyleScroll滚动
      
       2 导航方向navigationOrientation： 水平方向UIPageViewControllerNavigationOrientationHorizontal
                垂直 UIPageViewControllerNavigationOrientationVertical
       3 options 可选的 配置组成的字典  或用属性doubleSided
      */
//    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};//滚动效果时候才有作用 两个页面之间的间距
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};//Curl的时候才有作用, 它定义的是书脊的位置 UIPageViewControllerSpineLocationMid这个选项,效果是翻开的书这样屏幕展示的就是两个页面,doubleSided这个属性就必须设置为YES了. 📖这种样子的两个页面时  _pageViewCtrl.doubleSided = YES;setViewControllers viewControllers这个参数至少包含两个页面
    
   
    _pageViewCtrl = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
  
    _pageViewCtrl.delegate = self;
    _pageViewCtrl.dataSource = self;
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
//    ContentViewController *initialViewControllerMidType = [self viewControllerAtIndex:1];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObjects:initialViewController,nil];
    
    [_pageViewCtrl setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewCtrl.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewCtrl];
    [self.view addSubview:_pageViewCtrl.view];

}

#pragma mark - DataSource Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;//第一个页面不可以向前滚动或翻页
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return [self viewControllerAtIndex:index];
    
    
}
#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContentArray count]) {
        return nil;//后一个页面不可以向后滚动或翻页
    }
    return [self viewControllerAtIndex:index];
    
    
}

//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
//    return self.pageContentArray.count;
//}
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
//    return 8;
//}


#pragma mark - 根据index得到对应的UIViewController

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    ContentViewController *contentVC = [[ContentViewController alloc] init];
    contentVC.content = [self.pageContentArray objectAtIndex:index];
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController {
    //arr indexOfObject 得到元素在arr中的下标
    return [self.pageContentArray indexOfObject:viewController.content];
}



#pragma mark -- pageContentArray getter

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)@"002.pdf", NULL, NULL);
        //创建CGPDFDocument对象
        CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
        long maxNumPage =  CGPDFDocumentGetNumberOfPages(pdfDocument);
        for (int i = 1; i < maxNumPage; i++) {
            NSString *contentString = [[NSString alloc] initWithFormat:@"%d",i];
            [arrayM addObject:contentString];
        }
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}
@end
