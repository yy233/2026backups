//
//  ringBuf.cpp
//  NuiDemo
//
//  Created by zhouguangdong on 2019/12/4.
//  Copyright © 2019 Alibaba idst. All rights reserved.
//

#include "ringBuf.h"
#include <assert.h>
#include <string.h>
#include <mutex>

static std::mutex lock;

int ringbuffer_empty(RINGBUFFER_T *rb)
{
    std::unique_lock<decltype(lock)> auto_lock(lock);
    /* It's empty when the read and write pointers are the same. */
    if (0 == rb->fill) {
        return 1;
    }else {
        return 0;
    }
}

int ringbuffer_full(RINGBUFFER_T *rb)
{
    std::unique_lock<decltype(lock)> auto_lock(lock);
    /* It's full when the write ponter is 1 element before the read pointer*/
    if (rb->size == rb->fill) {
        return 1;
    }else {
        return 0;
    }
}

int ringbuffer_get_write_index(RINGBUFFER_T *rb) {
    return rb->write - rb->buffer;
}

int ringbuffer_get_read_index(RINGBUFFER_T *rb) {
    return rb->read - rb->buffer;
}

int ringbuffer_get_filled(RINGBUFFER_T *rb) {
    int r = ringbuffer_get_read_index(rb);
    int w = ringbuffer_get_write_index(rb);
    if (w >= r) {
        return w - r;
    } else {
        return w + rb->size - r;
    }
}

int ringbuffer_read(RINGBUFFER_T *rb, unsigned char* buf, unsigned int len)
{
    std::unique_lock<decltype(lock)> auto_lock(lock);
//    printf("audioplayer write %d read %d len %d fill %d\n", ringbuffer_get_write_index(rb), ringbuffer_get_read_index(rb), len, rb->fill);
    assert(len>0);
    if (rb->fill < len) {
        len = rb->fill;
    }
    if (rb->fill >= len) {
        // in one direction, there is enough data for retrieving
        if (rb->write > rb->read) {
            memcpy(buf, rb->read, len);
            rb->read += len;
        }else if (rb->write < rb->read) {
            int len1 = rb->buffer + rb->size - 1 - rb->read + 1;
            if (len1 >= len) {
                memcpy(buf, rb->read, len);
                rb->read += len;
            } else {
                int len2 = len - len1;
                memcpy(buf, rb->read, len1);
                memcpy(buf + len1, rb->buffer, len2);
                rb->read = rb->buffer + len2; // Wrap around
            }
        }
        rb-> fill -= len;
        return len;
    } else    {
        return 0;
    }
}

int ringbuffer_write(RINGBUFFER_T *rb, unsigned char* buf, unsigned int len)
{
    std::unique_lock<decltype(lock)> auto_lock(lock);
//    printf("ringbuffer_write write %d read %d len %d fill %d\n", ringbuffer_get_write_index(rb), ringbuffer_get_read_index(rb), len, rb->fill);
    assert(len > 0);
    if (rb->size - rb->fill <= len) {
        return 0;
    }
    else {
        if (rb->write >= rb->read) {
            int len1 = rb->buffer + rb->size - rb->write;
            if (len1 >= len) {
                memcpy(rb->write, buf, len);
                rb->write += len;
            } else {
                int len2 = len - len1;
                memcpy(rb->write, buf, len1);
                memcpy(rb->buffer, buf+len1, len2);
                rb->write = rb->buffer + len2; // Wrap around
            }
        } else {
            memcpy(rb->write, buf, len);
            rb->write += len;
        }
        rb->fill += len;
        return len;
    }
}

void ringbuffer_reset(RINGBUFFER_T *rb) {
    std::unique_lock<decltype(lock)> auto_lock(lock);
    rb->fill = 0;
    rb->write = rb->buffer;
    rb->read = rb->buffer;
    memset(rb->buffer, 0, rb->size);
    return;
}
