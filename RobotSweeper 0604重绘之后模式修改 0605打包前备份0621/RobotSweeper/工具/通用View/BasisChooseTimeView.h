//
//  BasisChooseTimeView.h
//  OA
//
//  Created by yy on 17/6/26.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimeChouseDelegate <NSObject>
- (NSString *)dateOfDidSelect:(NSString *)str;
- (void)removeBasisChooseTimeView;
@end

@interface BasisChooseTimeView : UIView

@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnOfOk;
@property (nonatomic,weak)id <TimeChouseDelegate>delegateOfTime;
@property (nonatomic,copy)NSString *strOftime;
@property (nonatomic,assign)BOOL isPrecision;
@end
