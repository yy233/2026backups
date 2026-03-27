//
//  IMGroupDetailTopMemberView.m
//  Socialize
//
//  Created by 余莹 on 2023/5/18.
//

#import "IMGroupDetailTopMemberView.h"

@implementation IMGroupDetailTopMemberView

- (UIButton *)bottomMoreBtn{
    if(!_bottomMoreBtn){
        _bottomMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomMoreBtn newAnBtnWithFont:[UIFont systemFontOfSize:14]];
        [_bottomMoreBtn newAnBtnWithTextColor:rgba(102, 102, 102, 1)];
        [_bottomMoreBtn newAnBtnWithTextStr:@"查看更多群成员 >"];
    }
    return _bottomMoreBtn;
}

@end
