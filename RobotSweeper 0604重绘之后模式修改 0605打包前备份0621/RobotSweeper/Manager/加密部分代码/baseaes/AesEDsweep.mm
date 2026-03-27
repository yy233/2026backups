//
//  AesEDsweep.m
//  xmpp加密demo
//
//  Created by Joey on 2018/9/13.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "AesEDsweep.h"

#include"aes_entry.h"
#include"xmd5.h"
#include<string.h>
#include<stdio.h>
#include<string.h>

#include "mainAes.h"
char str1[]="RobotLeo";
char str2[]="LeoRobot";
@implementation AesEDsweep
 

+(NSString *)aesEorDwithType:(int)isEncryp
            isStrOFSourceStr:(NSString *)dataSource
{
//    char key[80],iv[36];
//    int  ret,enc,buflen,buflen1,buflen2,buflen3,buflen4;
//    char buf[100],buf1[100],buf2[100],buf3[100],buf4[100];
//    static FILE * fd1 = NULL ;
//    static FILE * fd2 = NULL ;
//    int cas;
//    char base64[128];
//    char dedata[128];
//    buflen=strlen(buf);
//    GetMD5OfData ( str1 , (int)strlen(str1) , sizeof(str1) , key , 1 ) ;
//    GetMD5OfData ( str2 , (int)strlen(str2) , sizeof(str2) , iv , 1 ) ;
//    printf("key=%s\niv=%s\n",key,iv);
    
    char key[80],iv[36];
    int  ret,enc,buflen,buflen1,buflen2,buflen3,buflen4;
//    char buf[1000],buf1[1000],buf2[1000],buf3[1000],buf4[1000];
    char *buf;
    char *buf1;
    char *buf2;
    char *buf3;
    char *buf4;
    buf = (char*)malloc(2*[dataSource length]);
    memset(buf, 0, 2*[dataSource length]);//清零
    buf1 = (char*)malloc(2*[dataSource length]);
    memset(buf1, 0, 2*[dataSource length]);//清零
    buf2 = (char*)malloc(2*[dataSource length]);
    memset(buf2, 0, 2*[dataSource length]);//清零
    buf3 = (char*)malloc(2*[dataSource length]);
    memset(buf3, 0, 2*[dataSource length]);//清零
    buf4 = (char*)malloc(2*[dataSource length]);
    memset(buf4, 0, 2*[dataSource length]);//清零
    static FILE * fd1 = NULL ;
    static FILE * fd2 = NULL ;
    int cas;
 
    //
    char *base64em;
    char *base64dm;
    char *dedata;
  
    dedata = (char*)malloc(2*[dataSource length]);//开空间 足够空间
    base64em =  (char*)malloc(2*[dataSource length]);
    base64dm =  (char*)malloc(2*[dataSource length]);
 
    memset(dedata, 0, 2*[dataSource length]);//清零
    memset(base64em, 0, 2*[dataSource length]);
    memset(base64dm, 0, 2*[dataSource length]);
    
    
    buflen=strlen(buf);
    GetMD5OfData ( str1 , (int)strlen(str1) , sizeof(str1) , key , 1 ) ;
    GetMD5OfData ( str2 , (int)strlen(str2) , sizeof(str2) , iv , 1 ) ;
//    printf("key=%s\niv=%s\n",key,iv);
//    printf("————————————————————————————————————————————————————————————————————————————————————");
//
//    printf("**********输入选项，0：解密  1：加密  2：加密后解密***********\n");
//    scanf("%d",&cas);
   
    /**
     加密 1
   
     解密 0
     */
    cas = isEncryp;
    
    if (cas==0) {
//        printf("这是解密");
        /**
         字符串存在则以字符串为源
         否则则已文件路径为源
         */
        if (dataSource==nil) {
            return @"";//没有源时，返回失败的0
        }
        if(dataSource.length==0){
            return @"";//没有源时，返回失败的0
        }

        //解密时：先base解后aes解
        /**
         赋值 base64dm为源dedata为得到的加密数据 dedata用64之后buf2为结果
         */
//        printf("密文地址 = %s",&base64dm);
        memcpy(base64dm, [dataSource UTF8String], [dataSource length]);//此处长度不*2 使用1；1的copy防止未定义数据的copy造成 使用已释放对象的崩溃错误
//        printf("密文为：%s\n",base64dm);
       int res = base64_decode(base64dm, (unsigned char*)dedata);
//        printf("baes64解码后：%s\n",dedata);
        buflen2=strlen(buf2);
        ret=aes_cbc(dedata,res,buf2,&buflen2,key,iv,0,128);
        
        if(!ret)
        {
            buf2[buflen2] = '\0';//结束符
            //打印
            if (buflen2<400) {
                  printf("base64和aes解码后 解密结果:%s\n",buf2);//解密后的明文
            }else{
                  printf("base64和aes解码后 解密结果>=400");//解密后的明文
            }
          
            
            return [NSString stringWithUTF8String:buf2];
        }else{
            return @"";
        }
    }else{
        printf("这是加密");
        /**
         赋值 buf3为源buf4为得到的加密数据 buf4用64之后base64em为结果
         */
        memcpy(buf3, [dataSource UTF8String], [dataSource length]);//有\0
        printf("原文为：%s\n",buf3);
        buflen4=strlen(buf4);
        ret=aes_cbc(buf3,strlen(buf3),buf4,&buflen4,key,iv,1,128);
        if(!ret)
        {
            base64_encode((unsigned char *)buf4, base64em,buflen4);

//            printf("aes和base64编码后：%s\n",base64em);
            return [NSString stringWithUTF8String:base64em];
        }else{
            return @"";
        }
    }
    
    
}
//
/**  NSString *TempString = @"123456cSt";
 char css[100];
 memcpy(css, [TempString cStringUsingEncoding:NSASCIIStringEncoding], 2*[TempString length]);//memcpy函数的功能是从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中。
 NSLog(@"css====%s ",css);
 
 例:char a[100];memset(a, '/0', sizeof(a));
 memset可以方便的清空一个结构类型的变量或数组。
 
 strcpy把从src地址开始且含有'\0'结束符的字符串复制到以dest开始的地址空间，不过oc传来的没有\0换成memcpy方法
 */

#pragma mark -- 试试分开写


+(NSString *)aesEorDwithTypeIsE:(int)isEncryp
               isStrOFSourceStr:(NSString *)dataSource{
    char key[80],iv[36];
    int  ret,enc,buflen,buflen1,buflen2,buflen3,buflen4;
    //    char buf[1000],buf1[1000],buf2[1000],buf3[1000],buf4[1000];
    
    if ( dataSource==NULL) {
        return @"";
    }
    float lenofData = 3*[dataSource length]+1;//2倍+1 改成3倍+1不崩100次测试了 fno-objc-arc添加了的
    char *buf = NULL;
    buf = (char*)malloc(lenofData);
    memset(buf, 0, lenofData);//清零
    
    char *buf1 = NULL;
    buf1 = (char*)malloc(lenofData);
    memset(buf1, 0, lenofData);//清零
    
    char *buf2 = NULL;
    buf2 = (char*)malloc(lenofData);
    memset(buf2, 0, lenofData);//清零
    
    char *buf3 = NULL;
    buf3 = (char*)malloc(lenofData);
    memset(buf3, 0, lenofData);//清零
    
    char *buf4 = NULL;
    buf4 = (char*)malloc(lenofData);
    memset(buf4, 0, lenofData);//清零
    
    char *dedata = NULL;
    dedata = (char*)malloc(lenofData);//开空间 足够空间
    memset(dedata, 0, lenofData);//清零
    
   
    char *base64em = NULL;
    base64em =  (char*)malloc(lenofData);
    memset(base64em, 0,lenofData);
    
    
    char *base64dm = NULL;
    base64dm =  (char*)malloc(lenofData);
    memset(base64dm, 0, lenofData);
    
    //
   
    
    static FILE * fd1 = NULL ;
    static FILE * fd2 = NULL ;
    int cas;
    
    
    buflen=strlen(buf);
    GetMD5OfData ( str1 , (int)strlen(str1) , sizeof(str1) , key , 1 ) ;
    GetMD5OfData ( str2 , (int)strlen(str2) , sizeof(str2) , iv , 1 ) ;
    
//    NSLog(@"%d _sendmsgOfoneSq or get  thread = %@  dataS = %@",isEncryp,[NSThread currentThread],dataSource);
    cas = isEncryp;
    
    if (cas==0) {
        printf("这是解密");
        //释放
        [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
        return @"调用错误";
        
    }else{
        printf("这是加密");
        /**
         赋值 buf3为源buf4为得到的加密数据 buf4用64之后base64em为结果
         */
        memcpy(buf3, [dataSource UTF8String], [dataSource length]);//有\0
        printf("原文为：%s\n",buf3);
        buflen4=strlen(buf4);
        ret=aes_cbc(buf3,strlen(buf3),buf4,&buflen4,key,iv,1,128);
        if(!ret)
        {
            base64_encode((unsigned char *)buf4, base64em,buflen4);
            NSString *strOfBase64em = [NSString stringWithUTF8String:base64em];
            //            printf("aes和base64编码后：%s\n",base64em);
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            
            
            return strOfBase64em;
        }else{
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            
            return @"";
        }
    }
    
    
    
}

+(NSString *)aesEorDwithTypeNotE:(int)isEncryp
                isStrOFSourceStr:(NSString *)dataSource{
    
    
    char key[80],iv[36];
    int  ret,enc,buflen,buflen1,buflen2,buflen3,buflen4;
    //    char buf[1000],buf1[1000],buf2[1000],buf3[1000],buf4[1000];
    
    if ( dataSource==NULL) {
        return @"";
    }
    float lenofData = 3*[dataSource length]+1;//2倍+1 改成3倍+1不崩100次测试了 fno-objc-arc添加了的
    char *buf = NULL;
    buf = (char*)malloc(lenofData);
    memset(buf, 0, lenofData);//清零
    
    char *buf1 = NULL;
    buf1 = (char*)malloc(lenofData);
    memset(buf1, 0, lenofData);//清零
    
    char *buf2 = NULL;
    buf2 = (char*)malloc(lenofData);
    memset(buf2, 0, lenofData);//清零
    
    char *buf3 = NULL;
    buf3 = (char*)malloc(lenofData);
    memset(buf3, 0, lenofData);//清零
    
    char *buf4 = NULL;
    buf4 = (char*)malloc(lenofData);
    memset(buf4, 0, lenofData);//清零
    
    char *dedata = NULL;
    dedata = (char*)malloc(lenofData);//开空间 足够空间
    memset(dedata, 0, lenofData);//清零
    
    
    char *base64em = NULL;
    base64em =  (char*)malloc(lenofData);
    memset(base64em, 0,lenofData);
    
    
    char *base64dm = NULL;
    base64dm =  (char*)malloc(lenofData);
    memset(base64dm, 0, lenofData);
    
    //
    
    int cas;
    buflen=strlen(buf);
    GetMD5OfData ( str1 , (int)strlen(str1) , sizeof(str1) , key , 1 ) ;
    GetMD5OfData ( str2 , (int)strlen(str2) , sizeof(str2) , iv , 1 ) ;
    
//    NSLog(@"%d _sendmsgOfoneSq or get  thread = %@  dataS = %@",isEncryp,[NSThread currentThread],dataSource);
    cas = isEncryp;
    
    if (cas==0) {
        printf("这是解密");
        /**
         字符串存在则以字符串为源
         否则则已文件路径为源
         */
        if (dataSource==nil) {
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            return @"";//没有源时，返回失败的0
        }
        if(dataSource.length==0){
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            return @"";//没有源时，返回失败的0
        }
        
        //解密时：先base解后aes解
        /**
         赋值 base64dm为源dedata为得到的加密数据 dedata用64之后buf2为结果
         */
        //        printf("密文地址 = %s",&base64dm);
        memcpy(base64dm, [dataSource UTF8String], [dataSource length]);//此处长度不*2 使用1；1的copy防止未定义数据的copy造成 使用已释放对象的崩溃错误
        //        printf("密文为：%s\n",base64dm);
        int res = base64_decode(base64dm, (unsigned char*)dedata);
        //        printf("baes64解码后：%s\n",dedata);
        buflen2=strlen(buf2);
        ret=aes_cbc(dedata,res,buf2,&buflen2,key,iv,0,128);
        
        if(!ret)
        {
            buf2[buflen2] = '\0';//结束符
//            printf("base64和aes解码后 解密结果:%s\n",buf2);//解密后的明文
            //打印
            if (buflen2<400) {
                printf("base64和aes解码后 解密结果:%s\n",buf2);//解密后的明文
            }else{
                printf("base64和aes解码后 解密结果>=400");//解密后的明文
            }
            NSString *strOfbuf2 = [NSString stringWithUTF8String:buf2];
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            
            return strOfbuf2;
        }else{
            //释放
            [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
            
            return @"";
        }
    }else{
        printf("这是加密");
        //释放
        [self freeAllBuf:buf buf1:buf1 buf2:buf2 buf3:buf3 buf4:buf4 base64em:base64em base64dm:base64dm dedata:dedata];
        
        return @"调用错误";
    }
    
}

+ (void)freeAllBuf:(char *)buf
              buf1:(char *)buf1
              buf2:(char *)buf2
              buf3:(char *)buf3
              buf4:(char *)buf4
          base64em:(char *)base64em
          base64dm:(char *)base64dm
            dedata:(char *)dedata{
    //释放
    if(buf){
        free(buf);
    }
    if(buf1){
       free(buf1);
    }
    if (buf2) {
        free(buf2);
    }
    if (buf3) {
        free(buf3);
    }
    if (buf4) {
        free(buf4);
    }
    if (base64em) {
        free(base64em);
    }
    if (base64dm) {
        free(base64dm);
    }
    if (dedata) {
        free(dedata);
    }
    
   
    buf = NULL;
    buf1 = NULL;
    buf2 = NULL;
    buf3 = NULL;
    buf4 = NULL;
    base64em = NULL;
    base64dm = NULL;
    dedata = NULL;
    
    
}
@end
