//
//  ZYMedicalMainFunctionHealthCollectionViewCell.m
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import "ZYMedicalMainFunctionHealthCollectionViewCell.h"

@implementation ZYMedicalMainFunctionHealthCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.goButton.layer.borderWidth = 0.5;
    self.goButton.layer.cornerRadius = 8.5;
    self.goButton.layer.masksToBounds = YES;
}

@end
