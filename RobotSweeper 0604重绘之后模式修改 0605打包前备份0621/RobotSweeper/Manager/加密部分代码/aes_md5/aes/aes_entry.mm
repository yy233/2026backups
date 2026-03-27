/*
 * Copyright 2002-2016 The OpenSSL Project Authors. All Rights Reserved.
 *
 * Licensed under the OpenSSL license (the "License").  You may not use
 * this file except in compliance with the License.  You can obtain a copy
 * in the file LICENSE in the source distribution or at
 * https://www.openssl.org/source/license.html
 */

#include<stdio.h>
#include<stdlib.h>
#include<string.h>	
#include<ctype.h>
#include<stddef.h>
#include "aes.h"
#include "modes.h"
#include "offcut.h"


int aes_cbc(char *in, int inlen, char *out, int *outlen, char *key_in, char *iv_in, int enc, int bits)
{
	unsigned char key[32] = "";
	unsigned char iv[16] = "";
	AES_KEY aesKey;
	int ret;
	
	if((bits != 128 && bits != 192 && bits != 256) || 
		in == NULL || inlen <= 0 || outlen == NULL || key_in == NULL  ||
		set_hex(key_in, key, sizeof(key)) < 0  ||  set_hex(iv_in, iv, sizeof(iv)) < 0)
	{
		printf("aes_cbc: input error\n");
		return -1;
	}

	if(out == NULL)
	{
		out = in;
	}
	if(enc)
	{
		inlen = padding_pkcs5(in, inlen, 16);
		ret = AES_set_encrypt_key(key, bits, &aesKey);
		if(inlen <= 0 || ret < 0)
		{
			printf("aes_cbc: padding=%d, encrypt_key ret = %d\n", inlen, ret);
			return -1;
		}
		AES_cbc_encrypt((const unsigned char *)in, (unsigned char *)out, inlen, &aesKey, iv, 1);
		*outlen = inlen ;
		printf("aes_cbc:enc over success ^.^ ^.^ ^.^ ^.^ ^.^ ^.^\n");
	}
	else
	{
		ret = AES_set_decrypt_key(key, bits, &aesKey);
		if(ret < 0)
		{
			printf("aes_cbc: AES_set_decrypt_key ret = %d\n", ret);
			return -1;
		}
		AES_cbc_encrypt((const unsigned char *)in, (unsigned char *)out, inlen, &aesKey, iv, 0);
		*outlen = padding_pkcs5_remove(out, inlen, 16);
		if(*outlen <= 0)
		{
			printf("aes_cbc: padding_pkcs5_remove ret = %d\n", *outlen);
			return -1;
		}
//        printf("aes_cbc:dec over success ^.^ ^.^ ^.^ ^.^ ^.^ ^.^\n");//20190411注释掉大部分map页的后台打印
	}
	
	return 0;	
}

int aes_cbc_file(char *infile, char *outfile, char *key, char *iv, int enc, int bits)
{
	FILE *fin = NULL, *fout = NULL;
	int inlen, datalen, outlen, ret;
	char *data = NULL;
	
	if(infile == NULL || outfile == NULL || key == NULL ||
	(bits != 128 && bits != 192 && bits != 256))
	{
		printf("aes_cbc_file:input error\n");
		return -1;
	}
	
	fin = fopen(infile, "rb");
	if(!fin)
	{
		printf("aes_cbc_file:input error\n");
		return -1;
	}
	
	fseek(fin, 0, 2);
	inlen = (int)ftell(fin);
	rewind(fin);
	
	data = (char *)malloc(inlen + 128);
	
	if(!data)
	{
		printf("aes_cbc_file:malloc buf to cache file data error\n");
		goto ERR_END;
	}
	
	datalen = (int)fread(data, 1, inlen, fin);
	if(datalen != inlen)
	{
		printf("aes_cbc_file: read from file buf len error\n");
		goto ERR_END;
	}
	fclose(fin);
	fin = NULL;
	
	ret = aes_cbc(data, inlen, data, &outlen, key, iv, enc, bits);
	if(ret)
	{
		printf("aes_cbc_file: aes_cbc ret = %d\n", ret);
		goto ERR_END;
	}
	
	fout = fopen(outfile, "wb");
	datalen = (int)fwrite(data, 1, outlen, fout);
	if(datalen != outlen)
	{
		printf("aes_cbc_file: write to file buf len error\n");
		goto ERR_END;
	}
	
	fclose(fout);
	free(data);
	return 0;
	
ERR_END:
	if(fin)		fclose(fin);
	if(fout)	fclose(fout);
	if(data)		free(data);
	return -1;
}
