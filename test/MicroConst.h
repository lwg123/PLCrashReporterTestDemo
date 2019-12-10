//
//  MicroConst.h
//  test
//
//  Created by weiguang on 2019/9/19.
//  Copyright © 2019 duia. All rights reserved.
//

#ifndef MicroConst_h
#define MicroConst_h

#define LOGGER_TARGET 0

// 常用的宏定义
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

# define GALLog(fmt, ...) NSLog((@"[路径:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), [[NSString stringWithFormat:@"%s", __FILE__].lastPathComponent UTF8String], __FUNCTION__, __LINE__, ##__VA_ARGS__);


#endif /* MicroConst_h */
