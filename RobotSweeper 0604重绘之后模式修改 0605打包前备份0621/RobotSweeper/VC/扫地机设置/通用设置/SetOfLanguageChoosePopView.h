//
//  SetOfLanguageChoosePopView.h
//  RobotSweeper
//
//  Created by Joey on 2018/12/21.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetOfLanguageChoosePopView : UIView
@property (weak, nonatomic) IBOutlet UIView *btnBackView;

@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOfChooseLanguage;

@property (nonatomic,strong) NSMutableArray *arrOfTableViewData;
@property (nonatomic,strong) NSMutableArray *arrOfTableViewDataNum;

- (void)setDataWithTitleArr:(NSMutableArray *)arrOfPopTitle
                     numArr:(NSMutableArray *)arrOfPopTitleNum;
@end
