
#include<string.h>
#include<stdio.h>
#include<string.h>
// 全局常量定义
const char * base64char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
const char padding_char = '=';
 

/*base64编码
* const unsigned char * sourcedata， 源数组
* char * base64 ，码字保存
*/
int base64_encode(const unsigned char * sourcedata, char * base64,int len)
{
    int i=0, j=0;
    unsigned char trans_index=0;    // 索引是8位，但是高两位都为0
    //    const int datalength = strlen((const char*)sourcedata);
    const int datalength = len;
    for (; i < datalength; i += 3){
        // 每三个一组，进行编码
        // 要编码的数字的第一个
        trans_index = ((sourcedata[i] >> 2) & 0x3f);
        base64[j++] = base64char[(int)trans_index];
        // 第二个
        trans_index = ((sourcedata[i] << 4) & 0x30);
        if (i + 1 < datalength){
            trans_index |= ((sourcedata[i + 1] >> 4) & 0x0f);
            base64[j++] = base64char[(int)trans_index];
        }else{
            base64[j++] = base64char[(int)trans_index];

            base64[j++] = padding_char;

            base64[j++] = padding_char;

            break;   // 超出总长度，可以直接break
        }
        // 第三个
        trans_index = ((sourcedata[i + 1] << 2) & 0x3c);
        if (i + 2 < datalength){ // 有的话需要编码2个
            trans_index |= ((sourcedata[i + 2] >> 6) & 0x03);
            base64[j++] = base64char[(int)trans_index];

            trans_index = sourcedata[i + 2] & 0x3f;
            base64[j++] = base64char[(int)trans_index];
        }
        else{
            base64[j++] = base64char[(int)trans_index];

            base64[j++] = padding_char;

            break;
        }
    }

    base64[j] = '\0'; 

    return j;
}
/** 在字符串中查询特定字符位置索引
* const char *str ，字符串
* char c，要查找的字符
*/
inline int num_strchr(const char *str, char c) // 
{
    const char *pindex = strchr(str, c);
    if (NULL == pindex){
        return -1;
    }
    return pindex - str;
}
/* base64解码
* const char * base64 码字
* unsigned char * dedata， 解码恢复的数据
*/
int base64_decode(const char * base64, unsigned char * dedata)
{
    int i = 0, j=0;
    int trans[4] = {0,0,0,0};
    for (;base64[i]!='\0';i+=4){
        // 每四个一组，译码成三个字符
        trans[0] = num_strchr(base64char, base64[i]);
        trans[1] = num_strchr(base64char, base64[i+1]);
        // 1/3
        dedata[j++] = ((trans[0] << 2) & 0xfc) | ((trans[1]>>4) & 0x03);

        if (base64[i+2] == '='){
            continue;
        }
        else{
            trans[2] = num_strchr(base64char, base64[i + 2]);
        }
        // 2/3
        dedata[j++] = ((trans[1] << 4) & 0xf0) | ((trans[2] >> 2) & 0x0f);

        if (base64[i + 3] == '='){
            continue;
        }
        else{
            trans[3] = num_strchr(base64char, base64[i + 3]);
        }

        // 3/3
        dedata[j++] = ((trans[2] << 6) & 0xc0) | (trans[3] & 0x3f);
    }

    dedata[j] = '\0';

//    return 0;
    return j;
}
//int main(int argc,char *argv[])
//{
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
//    printf("**********输入选项，0：解密  1：加密  2：加密后解密***********\n");
//    scanf("%d",&cas);
//    switch(cas)
//    {
//        case 0:
//            memset(base64,0,sizeof(base64));
//            memset(dedata,0,sizeof(dedata));
//            memset(buf2,0,sizeof(buf2));
//            printf("请输入密文："); scanf("%s",base64);
//            printf("密文为：%s\n",base64);
//            base64_decode(base64, (unsigned char*)dedata);
//            printf("baes64解码后：%s\n",dedata);
//            buflen2=strlen(buf2);
//            ret=aes_cbc(dedata,strlen(dedata),buf2,&buflen2,key,iv,0,128);
//            if(!ret)printf("base64和aes解码后：%s\n",buf2);
//            break;
//        case 1:
//            memset(buf3,0,sizeof(buf3));
//            memset(buf4,0,sizeof(buf4));
//            memset(base64,0,sizeof(base64));
//            printf("请输入原文：");scanf("%s",buf3);
//            printf("原文为：%s\n",buf3);
//            buflen4=strlen(buf4);
//            ret=aes_cbc(buf3,strlen(buf3),buf4,&buflen4,key,iv,1,128);
//            if(!ret)                                                  
//            {   
//                base64_encode((unsigned char *)buf4, base64);
//                printf("aes和base64编码后：%s\n",base64);
//            }
//            break;
//        case 2:
//            memset(buf3,0,sizeof(buf3));
//            memset(buf4,0,sizeof(buf4));
//            memset(base64,0,sizeof(base64));
//            printf("请输入原文："); scanf("%s",buf3);
//            printf("原文为：%s\n",buf3);
//            buflen4=strlen(buf4);
//            ret=aes_cbc(buf3,strlen(buf3),buf4,&buflen4,key,iv,1,128);
//            if(!ret)                                                  
//            {
//                base64_encode((unsigned char *)buf4, base64);
//                printf("aes和base64编码后：%s\n",base64);
//            }
//            memset(buf2,0,sizeof(buf2));
//            memset(dedata,0,sizeof(dedata));
//            buflen2=strlen(buf2);
//            base64_decode(base64, (unsigned char*)dedata);
//            printf("base解码后%s\n",dedata);
//            ret=aes_cbc(buf4,strlen(buf4),buf2,&buflen2,key,iv,0,128);
//            if(!ret)printf("base64和aes解码后：%s\n",buf2);
//            break;
//    }
//    return 0;
//}

