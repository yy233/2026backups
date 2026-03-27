//
//  BaseDrawView.m
//  Community
//
//  Created by 余莹 on 2021/2/2.
//

#import "BaseDrawView.h"

@implementation BaseDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _move = CGPointMake(0, 0);
        _start = CGPointMake(0, 0);
        _lineWidth = 3;
        _color = [UIColor blackColor];
        _pathArray = [NSMutableArray array];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawPicture:context]; //画图
}

- (void)drawPicture:(CGContextRef)context {
    for (NSArray * attribute in _pathArray) {
        //将路径添加到上下文中
        CGPathRef pathRef = (__bridge CGPathRef)(attribute[0]);
        CGContextAddPath(context, pathRef);
        //设置上下文属性
        [attribute[1] setStroke];
        CGContextSetLineWidth(context, [attribute[2] floatValue]);
        //绘制线条
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    //创建路径
    _path = CGPathCreateMutable();
    NSArray *attributeArry = @[(__bridge id)(_path),_color,[NSNumber numberWithFloat:_lineWidth]];
    //路径及属性数组数组
    [_pathArray addObject:attributeArry];
    //起始点
    _start = [touch locationInView:self];
    CGPathMoveToPoint(_path, NULL,_start.x, _start.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //释放路径
    CGPathRelease(_path);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _move = [touch locationInView:self];
    //将点添加到路径上
    CGPathAddLineToPoint(_path, NULL, _move.x, _move.y);
    [self setNeedsDisplay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseDrawViewDrawRect)] && _pathArray.count > 0) {
        [self.delegate baseDrawViewDrawRect];
    }
}

/**
 获取签名图片

 @return image
 */
-(UIImage *)getDrawingImg{
    if (_pathArray.count) {
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, size.width, size.height));
        // view生成image
        [self.layer renderInContext:context];
        self.layer.contents = nil;
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        // 将图片保存到相册
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return nil;
}

/**
 撤销
 */
-(void)undo {
    [_pathArray removeLastObject];
    [self setNeedsDisplay];
}
/**
 清空
 */
-(void)clear {
    if (_pathArray.count > 0) {
        [_pathArray removeAllObjects];
        [self setNeedsDisplay];
    }
}

// 销毁
- (void)dealloc {

    // 关闭绘图
    UIGraphicsEndImageContext();
}

#pragma mark ===


- (void)changColor:(UIColor *)color{
    DLog(@"");
    self.color = color;
    [self setNeedsDisplay];
}
- (void)changFontWidth:(NSInteger)fontW{
    DLog(@"");
    self.lineWidth = fontW;
    [self setNeedsDisplay];
}
@end
