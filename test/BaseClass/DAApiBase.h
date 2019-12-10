//
//  ApiBase.h
//  newDuiaApp
//
//  Created by 李名泰 on 2017/7/12.
//  Copyright © 2017年 李名泰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAApiBase : NSObject <YYModel,NSCoding,NSCopying>

/**
 model解析的映射字典，key是Model的属性的名称，value是接口数据key的名称，容器类的属性也需要映射
 */
+ (NSDictionary *)modelCustomPropertyMapper;
/**
 model解析时容器类对象存放的model类型 key是容器类对象的属性名，value是存放的model类型
 */
+ (NSDictionary *)modelContainerPropertyGenericClass;

/**
 使用一个model给另一个model赋值
 */
- (void)setValueWithObject:(id)obj;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
- (id)copyWithZone:(NSZone *)zone;
- (NSUInteger)hash;
- (BOOL)isEqual:(id)object;
- (NSString *)description; 
+ (NSArray *)propertiesForClass:(Class) aClass;



@end
