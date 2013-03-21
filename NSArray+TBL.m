//
//  NSArray+TBL.m
//  TeamStream
//
//  Created by Todd Huss on 3/11/13.
//  Copyright (c) 2013 Two Bit Labs. All rights reserved.
//

#import "NSArray+TBL.h"

@implementation NSArray (TBL)

-(id)objectAtIndex:(NSUInteger)index kindOfClass:(Class)aClass {
    id object = [self objectAtIndex:index];
    if (![object isKindOfClass:aClass]) {
        return nil;
    }
    return object;
}

-(BOOL)boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue {
    NSNumber *numValue = [self numberAtIndex:index];
    if (numValue == nil) {
        return defaultValue;
    }
    return [numValue boolValue];
}

-(NSNumber *)numberAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index kindOfClass:[NSNumber class]];
}

// returns a string or nil
-(NSString *)stringAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index kindOfClass:[NSString class]];
}

// returns a string or empty string, never nil
-(NSString *)stringOrEmptyStringAtIndex:(NSUInteger)index {
    NSString *aString = [self stringAtIndex:index];
    if (aString == nil) {
        return @"";
    }
    return aString;
}

// returns a string or nil, or if the string is empty returns nil
-(NSString *)stringOrNilIfEmptyStringAtIndex:(NSUInteger)index {
    NSString *aString = [self stringAtIndex:index];
    if (aString != nil && [aString length] == 0) {
        return nil;
    }
    return aString;
}

// converts the underlying object to a string or returns nil
-(NSString *)stringFromObjectAtIndex:(NSUInteger)index {
    id object = [self objectAtIndex:index];
	if (object == nil || [object isEqual:[NSNull null]]) {
		return nil;
	} else if ([object isKindOfClass:[NSString class]]) {
		return object;
	} else if ([object respondsToSelector:@selector(stringValue)]){
		return [object stringValue];
	}
    return [object description];
}

// converts the underlying object to a string or empty string, never nil
-(NSString *)stringFromObjectOrEmptyStringAtIndex:(NSUInteger)index {
    NSString *aString = [self stringFromObjectAtIndex:index];
    if (aString == nil) {
        return @"";
    }
    return aString;
}

-(NSArray *)arrayAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index kindOfClass:[NSArray class]];
}

-(NSDictionary *)dictionaryAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index kindOfClass:[NSDictionary class]];
}

// returns nil if index is outside of bounds
-(NSArray *)subarrayFromIndex:(NSUInteger)index {
    if (index > [self count]) {
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(index, [self count] - index)];
}

// returns the whole array if index is outside of bounds
-(NSArray *)subarrayToIndex:(NSUInteger)index {
    if (index > [self count]) {
        return self;
    }
    return [self subarrayWithRange:NSMakeRange(0, index + 1)];
}

@end
