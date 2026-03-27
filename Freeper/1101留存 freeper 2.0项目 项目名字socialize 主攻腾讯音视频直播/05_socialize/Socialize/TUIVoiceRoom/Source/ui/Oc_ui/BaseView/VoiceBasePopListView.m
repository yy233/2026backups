//
//  VoiceListPopView.m
//  AFNetworking
//
//  Created by 余莹 on 2023/5/30.
//

#import "VoiceBasePopListView.h"
#import "VoiceOcFileUse_Header.h"
#define TableView_Hight 280
#define TableViewCel_H 50

@interface VoiceBasePopListView () <UITableViewDelegate,UITableViewDataSource>
 @property (nonatomic,assign) float animationTime;
@end
@implementation VoiceBasePopListView


- (BOOL)isNotNil:(id)obj
{
    return (obj != nil && ![obj isEqual:[NSNull null]] && ![obj isEqual:nil]);
}
- (BOOL)isNil:(id)obj
{
    return (obj == nil || [obj isEqual:[NSNull null]] || [obj isEqual:nil]);
}



- (UIWindow *)toolGetKeyWindow{
    UIWindow *foundWindow = nil;
        NSArray  *windows = [[UIApplication sharedApplication]windows];
        for (UIWindow  *window in windows) {
            if (window.isKeyWindow) {
                foundWindow = window;
                break;
            }
        }
        return foundWindow;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, Screen_W, Screen_H); ;//frame 00范围，点击事件不可响应，会点到父视图
        [self initAttribute];
        [self addSubview:self.backcontentView];
        [self.backcontentView addSubview:self.tableView];
        [self tableViewOtherSet];
     }
    return self;
}
- (void)tableViewOtherSet{
    
}

#pragma mark ===========
/**
 *  展示pop视图 和 数据
 */
- (void)showInView:(UIView *)supview thePopViewTableViewHeight:(float)tableViewHeight WithArray:(NSMutableArray *)array{
    //
    UIWindow *window = [self toolGetKeyWindow];
    supview = window.rootViewController.view;
    //
    if (!supview) {
        return;
    }
    self.tableViewHeight = tableViewHeight;
    [supview addSubview:self];
    [self.backcontentView setFrame:CGRectMake(0, Screen_H, Screen_W, 0)];
    [UIView animateWithDuration:self.animationTime animations:^{
        self.alpha = 1.0;
        self.backcontentView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        
    } completion:^(BOOL finished) {
        if (finished) {
        }else{
        }
    }];
    if ([self isNil:  self.dataSource]  && [self isNotNil:array]) {
        self.dataSource = [[NSMutableArray alloc]initWithArray:array];
    }else{
        self.dataSource = array;
    }
    [self tableViewOtherSetWhenGetArrWithArray:array];
    [self.tableView reloadData];
}
- (void)tableViewOtherSetWhenGetArrWithArray:(NSMutableArray *)array{
}


- (void)dismissThePopView{//  CGPoint center = self.backcontentView.center;
    CGPoint center = self.backcontentView.center;
    [UIView animateWithDuration:self.animationTime
                     animations:^{
        self.alpha = 0.0;
        [self.backcontentView setCenter:CGPointMake(center.x, center.y+Screen_H)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.backcontentView removeFromSuperview];
    }];
}
#pragma mark - UITableViewDataSource
//header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 1;
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
//数据部分
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.separatorInset =  UIEdgeInsetsMake(0, 16, 0, 16);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str= self.dataSource[indexPath.row];
    cell.textLabel.text = str;
    return cell;
}
#pragma mark - UITableViewDelagate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableViewCel_H;
}
#pragma mark == 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(basePopViewTag:OfSubTableViewTouchWithIndexPath:)]) {
        [self dismissThePopView];
        [self.delegate basePopViewTag:0 OfSubTableViewTouchWithIndexPath:indexPath];//base=tag=0
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan");
    [self dismissThePopView];
}
- (void)closeBtnAction:(UIButton *)sender{
    NSLog(@"closeBtnAction");
    [self dismissThePopView];
}
#pragma mark == getter

- (void)initAttribute{
    self.animationTime = 0.3;
    [self setSubMainViewHeight];
}
//***重写高度时使用

- (void)setSubMainViewHeight{
    self.tableViewHeight = TableView_Hight;
}

- (UIView *)backcontentView{
    if (!_backcontentView) {
        _backcontentView = [[UIView alloc]init];
        _backcontentView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
        _backcontentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    }
    return _backcontentView;
}
- (UITableView *)tableView{
    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Screen_H-KNavBarHeight-self.tableViewHeight, Screen_W,self.tableViewHeight) style:UITableViewStylePlain];
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, Screen_H-KNavBarHeight-self.tableViewHeight+10, Screen_W,self.tableViewHeight) style:UITableViewStylePlain];//10圆角 下移动
        CGRect fram =  CGRectMake(0, Screen_H-self.tableViewHeight+10, Screen_W,self.tableViewHeight);//换成window rootvc view 后 knavH去掉
        _tableView = [[UITableView alloc]initWithFrame:fram style:UITableViewStylePlain];
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = YES;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _closeBtn.frame = CGRectMake(Screen_W - 20 - 20, Screen_H-KNavBarHeight-self.tableViewHeight+10, 20, 50);//
        _closeBtn.frame = CGRectMake(Screen_W - 20 - 20, Screen_H-self.tableViewHeight+10, 20, 50);///换成window rootvc view 后 knavH去掉
        [_closeBtn setImage:[UIImage imageNamed:@"close_round_gray"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //[_closeBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    }
    return _closeBtn;
}

@end
