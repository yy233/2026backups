
#ifndef HEADER_AES_OFFCUT_H
#define HEADER_AES_OFFCUT_H

int hex_char2int(unsigned char c);
int set_hex(char *in, unsigned char *out, int size);
int padding_pkcs5(char *in, int len, int block_size);
int padding_pkcs5_remove(char *in, int len, int block_size);

#endif
