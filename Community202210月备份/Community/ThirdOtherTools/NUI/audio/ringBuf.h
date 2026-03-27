//
//  ring_buf.hpp
//  testNuiUI
//
//  Created by zhouguangdong on 2019/12/4.
//  Copyright © 2019 Songsong Shao. All rights reserved.
//

#ifndef ringBuf_h
#define ringBuf_h

#include <stdio.h>

#define BUFFER_OVERFLOW (-1)

typedef struct {
    unsigned char *buffer;
    unsigned int size;
    unsigned int fill;
    unsigned char *read;
    unsigned char *write;
} RINGBUFFER_T;

#define RINGBUFFER_NEW(name, size) \
static unsigned char ringmem##name[size]; \
RINGBUFFER_T name = {ringmem##name, (size), 0, ringmem##name, ringmem##name};

#define RINGBUFFER_EXTERN(name) extern RINGBUFFER_T name;

int ringbuffer_empty(RINGBUFFER_T *rb);
int ringbuffer_full(RINGBUFFER_T *rb);
int ringbuffer_read(RINGBUFFER_T *rb, unsigned char* buf, unsigned int len);
int ringbuffer_write(RINGBUFFER_T *rb, unsigned char* buf, unsigned int len);
void ringbuffer_reset(RINGBUFFER_T *rb);

#endif /* ring_buf_hpp */
