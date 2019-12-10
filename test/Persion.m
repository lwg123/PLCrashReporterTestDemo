//
//  Persion.m
//  test
//
//  Created by weiguang on 2019/9/27.
//  Copyright © 2019 duia. All rights reserved.
//

#import "Persion.h"

@implementation Persion

- (void)dealloc {
    NSLog(@"thread:%@ Persion:%s",[NSThread currentThread],__func__);
}

@end
