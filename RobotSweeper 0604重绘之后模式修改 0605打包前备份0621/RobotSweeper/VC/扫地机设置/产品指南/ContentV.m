//
//  ContentV.m
//  分页控件练习
//
//  Created by Joey on 2018/5/16.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ContentV.h"

@implementation ContentV

-(id)initWithFrame:(CGRect)frame atPage:(int)index{
    self = [super initWithFrame:frame];
    
    pageNO = index;
    if (self) {
        CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)@"002.pdf", NULL, NULL);
        //创建CGPDFDocument对象
       pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    }
    
    return self;
}

-(void)drawInContext:(CGContextRef)context atPageNo:(int)page_no{
    //Quartz坐标系和UIView坐标系不一样所致，调整坐标系，使pdf正立
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (pageNO == 0) {
        pageNO = 1;
    }
    [[UIColor whiteColor] set];
    CGContextFillRect(context, self.bounds);//填充背景色，否则为全黑色；
    
    //获取指定页的pdf文档
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, page_no);
    //创建一个仿射变换，该变换基于将PDF页的BOX映射到指定的矩形中。
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.bounds, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    //将pdf绘制到上下文中
    CGContextDrawPDFPage(context, page);
    
}

- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext() atPageNo:pageNO];
}


@end
