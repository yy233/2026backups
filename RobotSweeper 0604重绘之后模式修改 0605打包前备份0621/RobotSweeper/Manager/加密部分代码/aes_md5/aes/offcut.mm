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
#include "aes.h"
#include "modes.h"


int hex_char2int(unsigned char c)
{
	switch(c)
	{
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			return c - '0';
		case 'a':
		case 'A':
			  return 0x0A;
		case 'b':
		case 'B':
			  return 0x0B;
		case 'c':
		case 'C':
			  return 0x0C;
		case 'd':
		case 'D':
			  return 0x0D;
		case 'e':
		case 'E':
			  return 0x0E;
		case 'f':
		case 'F':
			  return 0x0F;
	}
	return 0;
}
int set_hex(char *in, unsigned char *out, int size)
{
	int i,j,len;
	
	if(out)
	{
		memset(out, 0, size);
	}
	if(in == NULL )
	{
		return 0;
	}
	if(out == NULL || size <= 0)
	{
		printf("set_hex: in == NULL || out == NULL || size <= 0\n");
		return -1;
	}
	len = (int)strlen(in);
	if(len > 2*size)
	{
		printf("set_hex: in len is too long\n");
		return -1;
	}
    
    for (i = 0; i < len; i++) {
        j = (unsigned char)in[i];
        if (j == 0)
            break;
        if (!isxdigit(j)) {
            printf("set_hex: non-hex digit\n");
            return (0);
        }
        j = (unsigned char)hex_char2int(j);
        if (i & 1)
            out[i / 2] |= j;
        else
            out[i / 2] = (j << 4);
    }
	return 0;
}

int padding_pkcs5(char *in, int len, int block_size)
{
	int lack_size;
	
	if(in == NULL  ||  len <= 0  ||  block_size <= 0)
	{
		return -1;
	}
	
	lack_size = block_size - len % block_size;
	if(!lack_size) lack_size = block_size;
	
	memset(in + len, lack_size, lack_size);
	return len + lack_size;
}

int padding_pkcs5_remove(char *in, int len, int block_size)
{
	char end;
	int i = 0;
	if(in == NULL  ||  len <= 0  ||  block_size <= 0)
	{
		printf("args error\n");
		return -1;
	}
	if(len < block_size  ||  len % block_size != 0)
	{
		printf("len error\n");
		return -2;
	}
	
	end = in[len - 1];
	if((end == block_size  &&  len < block_size * 2) ||
		end < 1 || end > block_size || end >= len)
	{
		printf("format error\n");
		return -3;
	}
	
	while(i++ < end)
	{
		if(in[len - i] != end)
		{
			printf("format error\n");
			return -3;
		}
	}
	
	return len - end;
}

