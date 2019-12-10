//
//  ApiBase.m
//  newDuiaApp
//
//  Created by 李名泰 on 2017/7/12.
//  Copyright © 2017年 李名泰. All rights reserved.
//

#import "DAApiBase.h"

static NSArray *ignoreKeyNames = nil;
@implementation DAApiBase

+ (NSDictionary *)modelCustomPropertyMapper{
    //子类实现
    return nil;
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    //子类实现
    return nil;
}

+ (void)initialize
{
    if (!ignoreKeyNames) {
        ignoreKeyNames = [[NSArray alloc] initWithObjects:@"superclass", @"description", @"debugDescription", @"hash", nil];
    }
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


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
    
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
    
}
- (NSUInteger)hash {
    return [self yy_modelHash];
    
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
    
}
- (NSString *)description {
    return [self yy_modelDescription];
    
}

@end
