//
//  ContentV.h
//  分页控件练习
//
//  Created by Joey on 2018/5/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentV : UIView
{
    CGPDFDocumentRef pdfDocument;
    int pageNO;
}

-(id)initWithFrame:(CGRect)frame atPage:(int)index;

@end
