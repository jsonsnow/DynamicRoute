//
//  Bifrost+Dynamic.m
//  DynamicRoute
//
//  Created by chen liang on 2021/1/26.
//

#import "Bifrost+Dynamic.h"
#import <objc/runtime.h>
#import "DynamicModule.h"
#import <Mediator/WGWebModuleService.h>
//#import <mediato>

@implementation Bifrost (Dynamic)

static NSString *knativeRoute = @"native";
static NSString *kwebRoute = @"web";
static NSString *krnRoute = @"rn";
static NSString *kflutterRoute = @"flutter";

+ (void)load {
    SEL originalSelector = @selector(handleURL:complexParams:completion:);
    SEL swizzledSelector = @selector(dynamic_handleURL:complexParams:completion:);
    Class metalClass = objc_getMetaClass(class_getName(self));
    Method originMethod = class_getClassMethod(metalClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(metalClass, swizzledSelector);
    BOOL didAdd = class_addMethod(metalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAdd) {
        class_replaceMethod(metalClass, swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}

+ (id)dynamic_handleURL:(NSString *)urlStr complexParams:(NSDictionary *)complexParams completion:(BifrostRouteCompletion)completion {
    NSDictionary *configs = [DynamicModule sharedInstance].configs[urlStr];
    NSString *cur = configs[@"cur"];
    if ([self isWeb:cur]) {
        NSString *webPath = configs[@"webPath"];
        NSDictionary *parmas = @{kRouteWebUrlParams: webPath};
        return [self handleURL:kRouteWebPath complexParams:parmas completion:completion];
    }
    if ([self isRn:cur]) {
        NSAssert(0, @"rn route not imp");
    }
    if ([self isFlutter:cur]) {
        NSAssert(0, @"flutter route not imp");
    }
    return [self dynamic_handleURL:urlStr complexParams:complexParams completion:completion];
}

+ (BOOL)isWeb:(NSString *)type {
    if ([type isEqualToString:kwebRoute]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNativ:(NSString *)type {
    if ([type isEqualToString:knativeRoute]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isRn:(NSString *)type {
    if ([type isEqualToString:krnRoute]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isFlutter:(NSString *)type {
    if ([type isEqualToString:kflutterRoute]) {
        return YES;
    }
    return NO;
}

@end
