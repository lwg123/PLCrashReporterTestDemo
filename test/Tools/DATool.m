//
//  DATool.m
//  test
//
//  Created by weiguang on 2019/9/19.
//  Copyright © 2019 duia. All rights reserved.
//

#import "DATool.h"

@implementation DATool

#pragma mark - 日志收集
+ (void)saveLogToLocalFile
{
    NSString * localFolder = [kDocumentPath stringByAppendingPathComponent:@"APPLog"];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:localFolder]){
        [[NSFileManager defaultManager] createDirectoryAtPath:localFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 日期作为文件名
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    NSString *fileName = [NSString stringWithFormat:@"LOG-%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString * logFilePath = [localFolder stringByAppendingPathComponent:fileName];
    NSLog(@"保存日志路径:%@",logFilePath);
    // 文件夹大于10M 清除
    if([self folderSizeAtPath:localFolder]>1024.0*1024.0*10){
        [self deleteFilesAtPath:localFolder];
    }
    
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
}

// 获取单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSDictionary *attributes = [manager attributesOfItemAtPath:filePath error:nil];
        return [attributes fileSize];
    }
    return 0;
}

// 遍历文件夹获得文件夹大小，返回多少byte
+ (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

// 删除文件夹文件
+ (void)deleteFilesAtPath:(NSString *)folderPath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
        NSLog(@"files :%lu",(unsigned long)[files count]);
        for (NSString *p in files) {
            
            NSString *path = [folderPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    });
    
}


@end
