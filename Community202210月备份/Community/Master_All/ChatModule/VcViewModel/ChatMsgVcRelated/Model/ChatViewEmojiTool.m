//
//  ChatViewEmojiTool.m
//  Community
//
//  Created by 余莹 on 2022/6/14.
//

#import "ChatViewEmojiTool.h"

//staic


@implementation ChatViewEmojiTool
#pragma mark ===
//str->attstr
+ (void)getEmjIndexArrWithStr:(NSString *)string withBlock:(ChatSubUseTextViewOfEmjAttributedStringBlock)block{
    if (!([string containsString:k_emj_tip_start] && [string containsString:k_emj_tip_end])) {
        block([[NSMutableAttributedString alloc]initWithString:[TextShowWithModelStr textShowWithModelStr:string]]); 
        return;
    }
    
    
    NSString *editStr = string;
    NSInteger saveOldLoca = 0;
    NSMutableArray *saveIndexArr = [NSMutableArray arrayWithCapacity:0];
  
    for (int i = 0; i < string.length; i++) {
        
        NSRange start = [editStr rangeOfString:k_emj_tip_start];
        NSRange end = [editStr rangeOfString:k_emj_tip_end];

        NSString *sub = [editStr substringWithRange:NSMakeRange(start.location, end.location-start.location+1)];
        if (sub.length<=2) {
            break;
        }
        NSLog(@"start=%@",NSStringFromRange(start));
        NSLog(@"end=%@",NSStringFromRange(end));
        NSLog(@"sub=%@",sub);
        
        [saveIndexArr addObject:@(start.location+saveOldLoca)];
        [saveIndexArr addObject:@(end.location+saveOldLoca)];
        
        NSLog(@"saveIndexArr = %@",saveIndexArr);
        editStr = [editStr substringFromIndex:end.location+1];
        if (i == 0) {//saveIndexArr已经记录 这个给后续累计用
            saveOldLoca +=  end.location+1;
        }else{
            saveOldLoca +=  end.location+1;
        }
       

        NSLog(@"editStr = %@",editStr);
        
        if (end.length == editStr.length || editStr.length<=0 || !([editStr containsString:k_emj_tip_start] && [editStr containsString:k_emj_tip_end])) {//结束循环
            [self getAttributedStringStrWithIndexArr:saveIndexArr withAllStr:string withBlock:block];
            return;
        }else{
//            editStr 再入循环
        }
    }
}

+ (void)getAttributedStringStrWithIndexArr:(NSMutableArray *)saveIndexArr withAllStr:(NSString *)string  withBlock:(ChatSubUseTextViewOfEmjAttributedStringBlock)block{
    
    
    NSInteger saveJianIndex = 0;
    NSMutableAttributedString *editStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSLog(@"begiN -- editStr = %@",editStr);
    NSLog(@"ok saveIndexArr = %@",saveIndexArr);

    for (int i = 0; i < saveIndexArr.count; i++) {
        if (i%2 == 0) {
            NSInteger beginI = [saveIndexArr[i] integerValue];
            NSInteger endI = [saveIndexArr[i+1] integerValue];
            
            if (i == 0) {
                NSAttributedString *sub = [editStr attributedSubstringFromRange:NSMakeRange(beginI, (endI)-(beginI)+1)];
                //NSLog(@"xsub = %@",sub);
                NSAttributedString *tiHanImgStr = [self getOneAttchImgStrWithNameStr:sub];
            
                [editStr replaceCharactersInRange:NSMakeRange(beginI, (endI)-(beginI)+1) withAttributedString:tiHanImgStr];
               // NSLog(@"xeditStr == %@",editStr); //这里就是替换字符串
                
                saveJianIndex = (sub.length -  tiHanImgStr.length) + 0;//总差距给 下次数据使用
                //NSLog(@"xsaveJianIndex = %ld",saveJianIndex);
               
            }else{
                NSAttributedString *sub = [editStr attributedSubstringFromRange:NSMakeRange(beginI-saveJianIndex, (endI)-(beginI)+1)];
                //NSLog(@"xsub = %@",sub);
                
                NSAttributedString *tiHanImgStr = [self getOneAttchImgStrWithNameStr:sub];
                [editStr replaceCharactersInRange:NSMakeRange(beginI-saveJianIndex, (endI)-(beginI)+1) withAttributedString:tiHanImgStr];
                //NSLog(@"xeditStr == %@",editStr); //这里就是替换字符串
                
                saveJianIndex = (sub.length -  tiHanImgStr.length) + saveJianIndex;//总差距  下次数据使用 放在替换本次数据的后面
               // NSLog(@"xsaveJianIndex = %ld",saveJianIndex);

            }
        }
    
    }
    block(editStr);
    NSLog(@"ok Block Str == editStr %@",editStr);

}

#pragma mark ===  处理单个表情文本转图片
//带[]的名字传入 返回一个图片str
+ (NSAttributedString *)getOneAttchImgStrWithNameStr:(NSAttributedString *)nameStr{
    NSString *onlyChineseNameStr = [NSString stringWithFormat:@"%@",[nameStr.string substringWithRange:NSMakeRange(1, nameStr.length-2)]];
    NSLog(@" nameStr = %@ 将要处理图片文本 == %@",nameStr,onlyChineseNameStr);
  
    if (isNil([ChatViewEmojoNameShare share].emjAllNameArr) || [ChatViewEmojoNameShare share].emjAllNameArr.count <= 0 ) {
        [[ChatViewEmojoNameShare share] initFileArr];
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat: @"SELF CONTAINS [cd] %@",onlyChineseNameStr];
    NSArray *resultPieArr = [[ChatViewEmojoNameShare share].emjAllNameArr  filteredArrayUsingPredicate:pred];
    //NSLog(@"resultPie匹配的表情数组总 allArr=%@  \n  匹配 == %@",[ChatViewEmojoNameShare share].emjAllNameArr,resultPieArr);

    if (resultPieArr.count == 0) {
        //图片_无
        NSString *fileNameStr = [NSString stringWithFormat:@"%@/%@.png",kEmj_BuildleFileName,@"未知图片"];
        NSTextAttachment *attchImg = [[NSTextAttachment alloc]init];
        attchImg.image = [UIImage imageNamed:fileNameStr];
        attchImg.bounds = CGRectMake(0, 0, kTextViewUseEmjImg_HW, kTextViewUseEmjImg_HW);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attchImg];
        //NSLog(@"imgStr.length == %lu",(unsigned long)imgStr.length);
        return imgStr;
        
    }else if(resultPieArr.count == 1){
        //图片唯一
        NSString *fileNameStr = [NSString stringWithFormat:@"%@/%@.png",kEmj_BuildleFileName,resultPieArr.firstObject];
        NSTextAttachment *attchImg = [[NSTextAttachment alloc]init];
        attchImg.image = [UIImage imageNamed:fileNameStr];
        attchImg.bounds = CGRectMake(0, 0, kTextViewUseEmjImg_HW, kTextViewUseEmjImg_HW);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attchImg];
        //NSLog(@"imgStr.length == %lu",(unsigned long)imgStr.length);
        return imgStr;
        
    }else{
        //图片名字包含关系不唯一 ｜ 用这arr内的几个元素做匹配 取 匹配度最高的
        NSMutableArray *pipeiFloatSaveArr = [[NSMutableArray alloc]initWithCapacity:0];
        NSInteger saveMaxIndex = 0;
        
        for (int i = 0; i < resultPieArr.count ; i++) {
            NSString *useQueDingStr = [NSString stringWithFormat:@"%@",resultPieArr[i]];
            float pipeiFloat = [self likePercentByCompareOriginText:onlyChineseNameStr targetText:useQueDingStr];
            [pipeiFloatSaveArr addObject:@(pipeiFloat)];
            if (i==0) {
                saveMaxIndex = 0;
            }else{
                if (pipeiFloat > [pipeiFloatSaveArr[saveMaxIndex] floatValue]) {//比较之前记录的最大的 如果大于则记录
                    saveMaxIndex = i;//记录最大值的下标
                }
            }
           // NSLog(@"用这arr内的几个元素做匹配 确定筛选 == %@ , %ld, %f ",useQueDingStr,saveMaxIndex,pipeiFloat);
        }
        NSString *okName =  [NSString stringWithFormat:@"%@",resultPieArr[saveMaxIndex]];
        NSString *fileNameStr = [NSString stringWithFormat:@"%@/%@.png",kEmj_BuildleFileName,okName];
        NSTextAttachment *attchImg = [[NSTextAttachment alloc]init];
        attchImg.image = [UIImage imageNamed:fileNameStr];
        attchImg.bounds = CGRectMake(0, 0, kTextViewUseEmjImg_HW, kTextViewUseEmjImg_HW);
        NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attchImg];
        //NSLog(@"imgStr.length == %lu",(unsigned long)imgStr.length);
        return imgStr;
        
    }
    
  
}

#pragma mark ==  匹配度

static inline int min(int a, int b) {
    return a < b ? a : b;
}

+(float)likePercentByCompareOriginText:(NSString *)originText targetText:(NSString *)targetText{
    
    //length
    int n = (int)originText.length;
    int m = (int)targetText.length;
    if (n == 0 || m == 0) {
        return 0.0;
    }
    
    //Construct a matrix, need C99 support
    int N = n+1;
    int **matrix;
    matrix = (int **)malloc(sizeof(int *)*N);
    
    int M = m+1;
    for (int i = 0; i < N; i++) {
        matrix[i] = (int *)malloc(sizeof(int)*M);
    }
    
    for (int i = 0; i<N; i++) {
        for (int j=0; j<M; j++) {
            matrix[i][j]=0;
        }
    }
    
    for(int i=1; i<=n; i++) {
        matrix[i][0]=i;
    }
    for(int i=1; i<=m; i++) {
        matrix[0][i]=i;
    }
    for(int i=1;i<=n;i++)
    {
        unichar si = [originText characterAtIndex:i-1];
        for(int j=1;j<=m;j++)
        {
            unichar dj = [targetText characterAtIndex:j-1];
            int cost;
            if(si==dj){
                cost=0;
            }
            else{
                cost=1;
            }
            const int above = matrix[i-1][j]+1;
            const int left = matrix[i][j-1]+1;
            const int diag = matrix[i-1][j-1]+cost;
            matrix[i][j] = min(above, min(left,diag));
        }
    }
    return 100.0 - 100.0*matrix[n][m]/MAX(m,n);
}
#pragma mark===
//attstr-->str
//+ (void)changeAttStrWithMutStrWithInfo:(NSMutableAttributedString *)attributedText{
//    NSInteger count = 0
//    self.attributedText.enumerateAttribute(NSAttachmentAttributeName, in : NSMakeRange(0, self.attributedText.length), options: [], using: { attribute, range, _ in
//        if let attachment = attribute as? NSTextAttachment,
//            let image = attachment.image{
//                count = count + 1
//            }
//            })
//    return count
//
//    //第二：与字符串替换NSTextAttachment并计算改变后的范围。 < - 重复
//
//    for i in 0..<self.countOfNSTextAttachment(){
//        let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
//        var count = 0
//        attributedString.enumerateAttribute(NSAttachmentAttributeName, in : NSMakeRange(0, attributedString.length), options: [], using: { attribute, range, _ in
//            if let attachment = attribute as? NSTextAttachment,
//                let image = attachment.image{
//                    let str = "[img src=\(image.accessibilityIdentifier!)]"
//
//                    if count == 0{
//                        attributedString.beginEditing()
//                        attributedString.replaceCharacters(in: range, with: NSAttributedString(string : str))
//                        attributedString.endEditing()
//                        self.attributedText = attributedString
//                    }else{
//                        return
//                    }
//                    count = count + 1
//                }
//                })
//    }
//
//    return self.attributedText.string
//
//}

#pragma mark ==
/**
 
 //test
 + (void)getIndexArr:(NSMutableArray *)saveIndexArr withAllStr:(NSString *)string{
     //截取
     
     //替换
     
     //得到总的
     NSInteger saveJianIndex = 0;
     NSString *editStr = [string mutableCopy];
     NSString *strTH = @"";
     for (int i = 0; i < saveIndexArr.count; i++) {
         if (i%2 == 0) {
             NSInteger beginI = [saveIndexArr[i] integerValue];
             NSInteger endI = [saveIndexArr[i+1] integerValue];
             
       
             if (i == 0) {
                 NSString *sub = [editStr substringWithRange:NSMakeRange(beginI, (endI)-(beginI)+1)];
                 NSLog(@"sub = %@",sub);
                 strTH = [editStr stringByReplacingOccurrencesOfString:sub withString: @"❤️"];
                 saveJianIndex = (sub.length -  @"❤️".length) + 0;//总差距
                 NSLog(@"saveJianIndex = %ld",saveJianIndex);
                 //这里就是替换字符串
             }else{
                 NSString *sub = [strTH substringWithRange:NSMakeRange(beginI-saveJianIndex+1,  (endI)-(beginI)+1)];

                 NSLog(@"sub = %@",sub);
                 strTH = [strTH stringByReplacingOccurrencesOfString:sub withString: @"❤️"];//这里就是替换字符串
                 
                 NSLog(@"strTH = %@",strTH);
                 saveJianIndex = (sub.length -  @"❤️".length) + saveJianIndex;//总差距
                 NSLog(@"saveJianIndex = %ld",saveJianIndex);
             }
      
             
         }
     
     }
     NSLog(@"okstr == strTH %@",strTH);
  
 //  @"12[微笑a]3[微笑b][微笑c]56[微笑d]0";--->  strTH = 12❤️3❤️❤️56❤️0
 }

 */
@end
