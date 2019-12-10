//
//  ApiBase.m
//  JsonApiDemo
//
//  Created by Eli Zhang on 14-3-4.
//  Copyright (c) 2014年 LEILING. All rights reserved.
//

#import <objc/runtime.h>
#import "ApiBase.h"

static NSArray *ignoreKeyNames = nil;

@interface ApiBase() <NSCoding,NSCopying>

+ (NSArray *)arrayWithJsonArray:(NSArray *)jsonArray class:(Class)class;
- (Class)classForProperty:(NSString *)property;

@end

@implementation ApiBase

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSArray *)mj_ignoredPropertyNames {
    
    return @[@"superclass",@"debugDescription",@"description",@"hash"];
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSString *properyName in [ApiBase propertiesForClass:[self class]]) {
        [aCoder encodeObject:[self valueForKey:properyName] forKey:properyName];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        for (NSString *propertyName in [ApiBase propertiesForClass:[self class]]) {
            if ([aDecoder containsValueForKey:propertyName]) {
                [self setValue:[aDecoder decodeObjectForKey:propertyName] forKeyPath:propertyName];
            }
        }
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ApiBase *copiedObject = [[self class] allocWithZone:zone];
    NSArray *properties = [[self class] propertiesForClass:[self class]];
    if (copiedObject) {
        for (NSString *propertyName in properties) {
            SEL setPropertySelctor = NSSelectorFromString(propertyName);
            if (![ignoreKeyNames containsObject:propertyName] && [self respondsToSelector:setPropertySelctor]) {
                id value = [[self valueForKey:propertyName] copy];
                [self setValue:value forKey:propertyName];
            }
        }
    }
    return copiedObject;
}

+ (void)initialize
{
    if (!ignoreKeyNames) {
        ignoreKeyNames = [[NSArray alloc] initWithObjects:@"superclass", @"description", @"debugDescription", @"hash", nil];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setValueWithObject:(id)obj
{
    NSArray *properties = [[self class] propertiesForClass:[obj class]];
    for (NSString *property in properties) {
        id value = [obj valueForKey:property];
        SEL setPropertySelctor = NSSelectorFromString(property);
        if (value && ![ignoreKeyNames containsObject:property] && [self respondsToSelector:setPropertySelctor]) {
            [self setValue:value forKey:property];
        }
    }
}

+ (NSArray *)arrayWithJsonArray:(NSArray *)jsonArray class:(Class)class
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id jsonObject in jsonArray) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            [array addObject:[[class alloc] initWithJsonDictionary:jsonObject]];
        } else {
            [array addObject:jsonObject];
        }
    }
    return array;
}

+ (id)objectWithJsonData:(NSData *)jsonData
{
    if (jsonData) {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (!error) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                return [[self alloc] initWithJsonDictionary:jsonObject];
            } else if ([jsonObject isKindOfClass:[NSArray class]]) {
                return [self arrayWithJsonArray:jsonObject class:self];
            } else {
                return jsonObject;
            }
        } else {
            NSLog(@"json data error: %@", error.localizedDescription);
            return nil;
        }
    } else {
        return nil;
    }
}

+ (id)objectWithJsonOjbect:(id)jsonObject
{
    if (jsonObject) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            return [[self alloc] initWithJsonDictionary:jsonObject];
        } else if ([jsonObject isKindOfClass:[NSArray class]]) {
            return [self arrayWithJsonArray:jsonObject class:self];
        } else {
            return jsonObject;
        }
    } else {
        return nil;
    }
}

- (id)initWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    self = [self init];
    if (self && jsonDictionary&& [jsonDictionary isKindOfClass:[NSDictionary class]]) {
        NSDictionary *mappingDic = nil;
        if ([self respondsToSelector:@selector(propertyMapping)]) {
            mappingDic = [self propertyMapping];
        }
        
        for (NSString *key in jsonDictionary.allKeys) {
            NSString *selectorKey = key;
            if (mappingDic && [mappingDic objectForKey:key]) {
                selectorKey = [mappingDic objectForKey:key];
            }
            
            SEL setPropertySelctor = NSSelectorFromString(selectorKey);
            if (![ignoreKeyNames containsObject:selectorKey] && [self respondsToSelector:setPropertySelctor]) {
                id value = [jsonDictionary objectForKey:key];
                if ([value isKindOfClass:[NSArray class]]) {
                    NSArray *array = [[self class] arrayWithJsonArray:value class:[self classForArray:selectorKey]];
                    [self setValue:array forKey:selectorKey];
                } else if ([value isKindOfClass:[NSDictionary class]]) {
                    id object = [[[self classForProperty:selectorKey] alloc] initWithJsonDictionary:value];
                    [self setValue:object forKey:selectorKey];
                } else {
                    if (value == [NSNull null]) {
                        value = nil;
                    }
                    [self setValue:value forKey:selectorKey];
                }
            }
        }
    }
    return self;
}

// 获取某个属性的类型
- (Class)classForProperty:(NSString *)property
{
    NSString* propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(class_getProperty(self.class, property.UTF8String))];
    NSArray* splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
    if ([splitPropertyAttributes count] >= 2)
    {
        return NSClassFromString([splitPropertyAttributes objectAtIndex:1]);
    } else {
        return nil;
    }
}

// 判断该对象是否包含某个属性
- (BOOL)constaintsProperty:(NSString *)propertyName
{
    NSArray *propertyArray = [[self class] propertiesForClass:[self class]];
    return [propertyArray containsObject:propertyName];
}

// 获取一个类的属性列表
+ (NSArray *)propertiesForClass:(Class) aClass
{
    NSMutableArray *propertyNamesArr = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
    for (unsigned int i = 0; i<propertyCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        [propertyNamesArr addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNamesArr;
}

/*
 将对象转换成字典
 */
- (NSDictionary *)toJsonObject
{
    NSMutableDictionary *jsonDic = [[NSMutableDictionary alloc] init];
    for (NSString *propertyName in [ApiBase propertiesForClass:[self class]]) {
        id value = [self valueForKey:propertyName];
        if (!value) {
            continue;
        }
        NSString *needSetDicKey = [self serverKeyForPropertyName:propertyName];
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *array = [ApiBase jsonObjectWithArray:value];
            [jsonDic setObject:array forKey:needSetDicKey];
        }else if ([value isKindOfClass:[ApiBase class]]){
            NSDictionary *valueDic = [value toJsonObject];
            [jsonDic setObject:valueDic forKey:needSetDicKey];
        }else{
            [jsonDic setObject:value forKey:needSetDicKey];
        }
    }
    return jsonDic;
}

+ (NSArray *)jsonObjectWithArray:(NSArray *)dataObject      // 将对象数组转换成字典数组
{
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[dataObject count]];
    for (id dataObj in dataObject) {
        if ([dataObj isKindOfClass:[ApiBase class]]) {
            NSDictionary *dic = [dataObj toJsonObject];
            [jsonArray addObject:dic];
        }else if([dataObj isKindOfClass:[NSArray class]]){
            [jsonArray addObject:[ApiBase jsonObjectWithArray:dataObj]];
        }else{
            [jsonArray addObject:dataObj];
        }
    }
    return jsonArray;
}

//根据属性名 获取服务器返回的字段名  默认的匹配方式为  @"服务器字段":@"属性名"    转换后为 @"属性名":@"服务器字段"
- (NSString *)serverKeyForPropertyName:(NSString *)propertyName
{
    if ([self respondsToSelector:@selector(propertyMapping)]) {
        NSDictionary *mappingDic = [self propertyMapping];
        NSMutableDictionary *reverseMappingDic = [NSMutableDictionary dictionaryWithCapacity:[mappingDic count]];
        for (NSString *key in [mappingDic allKeys]) {
            NSString *value = [mappingDic objectForKey:key];
            if (value) {
                [reverseMappingDic setObject:key forKey:value];
            }
        }
        NSString *serverKey = [reverseMappingDic objectForKey:propertyName];
        if (serverKey) {
            return serverKey;
        }
    }
    return propertyName;
}

- (NSString *)toJsonString
{
    NSDictionary *jsonDic = [self toJsonObject];
    return [ApiBase jsonStringWithJsonObj:jsonDic];
}

+ (NSString *)jsonStringWithArray:(NSArray *)dataArray
{
    NSArray *jsonArray = [ApiBase jsonObjectWithArray:dataArray];
    return [ApiBase jsonStringWithJsonObj:jsonArray];
}

+ (NSString *)jsonStringWithJsonObj:(id)jsonObj
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return @"";
    
}
- (NSString *)description{
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return [self dictionaryWithValuesForKeys:mArray.copy].description;
}

// lihui_FIXME: 未定义的key会崩溃
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"!!!!!!!!!!!!!!!出现异常，该key不存在%@",key);
}

-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"!!!!!!!!!!!!!!!出现异常，该key不存在%@",key);
    return nil;
}
@end
