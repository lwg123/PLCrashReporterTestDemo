//
//  GCDDemo.m
//  test
//
//  Created by weiguang on 2020/3/11.
//  Copyright © 2020 duia. All rights reserved.
//

#import "GCDDemo.h"
#import <dispatch/dispatch.h>
#include <mach/mach.h>
#include <mach/std_types.h>
#include <mach/mig.h>
#include <mach/mach_types.h>
#include <sys/types.h>

@interface GCDDemo()


@end


@implementation GCDDemo

/**
 在读取较大文件时，如果将文件分成合适的大小并使用Global Dispatch Queue 并发读取的话，应该会比一般的读取速度快不少
 */
- (void)disptach {
    
    dispatch_io_t pipe_channel;
}

static int
_asl_auxiliary(aslmsg msg, const char *title, const char *uti, const char *url, int *out_fd)
{
       // asl_msg_t *merged_msg;
//        asl_msg_aux_t aux;
//        asl_msg_aux_0_t aux0;
//        fileport_t fileport;
        kern_return_t kstatus;
        uint32_t outlen, newurllen, len, where;
        int status, fd, fdpair[2];
        caddr_t out, newurl;
        dispatch_queue_t pipe_q;
        dispatch_io_t pipe_channel;
        dispatch_semaphore_t sem;
    
    // 创建串行队列
    pipe_q = dispatch_queue_create("PipeQ", NULL);
    // 创建 Dispatch I／O
    pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, pipe_q, ^(int error) {
        close(fd);
    });
    
    *out_fd = fdpair[1];
    // 该函数设定一次读取的大小（分割大小）
    dispatch_io_set_low_water(pipe_channel, SIZE_MAX);
    
    dispatch_io_read(pipe_channel, 0, SIZE_MAX, pipe_q, ^(bool done, dispatch_data_t  pipedata, int error) {
        if (error == 0) {
            // 读取完“单个文件块”的大小
            size_t len = dispatch_data_get_size(pipedata);
            if (len > 0) {
                // 定义一个字节数组bytes
                const char *bytes = NULL;
                char *encoded;
                
                dispatch_data_t md = dispatch_data_create_map(pipedata, (const void **)&bytes, &len);
                encoded = asl_core_encode_buffer(bytes, len);
//                asl_set((aslmsg)merged_msg, ASL_KEY_AUX_DATA, encoded);
//                free(encoded);
//                _asl_send_message(NULL, merged_msg, -1, NULL);
//                asl_msg_release(merged_msg);
//                dispatch_release(md);
                
               
            }
        }
    });
   
}

@end
