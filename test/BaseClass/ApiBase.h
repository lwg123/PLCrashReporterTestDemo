//
//  ApiBase.h
//  JsonApiDemo
//
//  Created by Eli Zhang on 14-3-4.
//  Copyright (c) 2014年 LEILING. All rights reserved.
//

#import <Foundation/Foundation.h>

// 此文件为所有实体类的基类 用以处理实体类的数据持久化 JSON解析

@protocol ApiBase <NSObject>

@optional

- (Class)classForArray:(NSString *)arrayKey;

- (NSDictionary *)propertyMapping;

@end

@interface ApiBase : NSObject <ApiBase>

+ (id)objectWithJsonData:(NSData *)jsonData;
+ (id)objectWithJsonOjbect:(id)jsonObject;
- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

+ (NSArray *)propertiesForClass:(Class) aClass;

- (void)setValueWithObject:(id)obj;

- (NSString *)toJsonString;

+ (NSString *)jsonStringWithArray:(NSArray *)dataArray;

@end
