//
//  AddNewCollectionViewCell.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/29.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AddNewCollectionViewCell.h"

@implementation AddNewCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
      _img.image = nil;
      _img.image = [UIImage imageNamed:[DataManager shareDataManager].homeCellImgNameStr];
      _img.contentMode = UIViewContentModeScaleAspectFit;
    
    _deletBtn.layer.cornerRadius = 15;
}
@end
