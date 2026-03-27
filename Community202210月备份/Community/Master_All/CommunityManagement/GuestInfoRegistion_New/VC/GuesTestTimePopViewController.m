//
//  GuesTestTimePopViewController.m
//  Community
//
//  Created by 余莹 on 2022/5/20.
//

#import "GuesTestTimePopViewController.h"
#import "GuestUseTimeChoosePopView.h"



@interface GuesTestTimePopViewController () <PopViewChooseVisitTimeDelegate>

@property (nonatomic,strong) GuestUseTimeChoosePopView *timePopView;

@end

@implementation GuesTestTimePopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"test";
    self.view.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.3];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.timePopView showInView:self.view thePopViewSubViewHeight:0.0 WithArray:@[].mutableCopy];
}

- (GuestUseTimeChoosePopView *)timePopView{
    _timePopView = [[GuestUseTimeChoosePopView alloc]init];
    _timePopView.delegate = self;
    return _timePopView;
}

- (void)popViewChooseVisitTimeChooseDayArr:(NSMutableArray *)timeStrArr{
    DLog(@"test timeStrArr == %@ ",timeStrArr);
    /***
     
     timeStrArr == (
         "2022-05-23",
         "2022-05-26"
     )
     */
}

@end
