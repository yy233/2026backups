//
//  BasisChooseRegionView.h
//  OA
//
//  Created by yy on 17/6/26.
//  Copyright © 2017年 yy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RegionDelegate <NSObject>

- (NSString *)regionOfdidSelect:(NSString *)strOfArea;
- (void)removeRegionView;
@end
@interface BasisChooseRegionView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,strong)NSArray *arrOfData;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic,weak)id<RegionDelegate>delegateOfRegion;
@property (nonatomic,copy)NSString *strOfNewSelect;
@property (weak, nonatomic) IBOutlet UIButton *btnOfOk;

@end
