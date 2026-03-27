
#ifndef HEADER_AES_ENTRY_H
#define HEADER_AES_ENTRY_H

int aes_cbc(char *in, int inlen, char *out, int *outlen, char *key_in, char *iv_in, int enc, int bits);
int aes_cbc_file(char *infile, char *outfile, char *key, char *iv, int enc, int bits);

#endif
