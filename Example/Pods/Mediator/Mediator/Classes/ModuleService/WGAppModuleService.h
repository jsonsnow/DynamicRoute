//
//  WGAppModuleService.h
//  Mediator
//
//  Created by chen liang on 2021/1/6.
//

// 主APP过渡层，承建暂时不拆分，但子pod会依赖的模块,后续从主模块中移除到对应pod的时候，从这里拆依赖
#ifndef WGAppModuleService_h
#define WGAppModuleService_h

#import <WGRouter/BifrostHeader.h>

NS_ASSUME_NONNULL_BEGIN

//common

typedef void (^AppModuleRequestCompletionHandler)(id result,NSError *error);

@protocol AppCommonModuleService <NSObject>

- (nullable NSString *)mediator_base_url;
- (NSString *)conact_customer_link;


- (void)authWechatCurrentViewController:(UIViewController *)from completion:(AppModuleRequestCompletionHandler)completion;

- (BOOL)um_wechat_Social_isInstall;

- (void)configUMAlias:(NSString *)uidkey;

- (void)removeUMAlias;

- (void)logModule:(NSString *)module verbose:(NSString *)verbose;

- (NSString *)localizedStringForKey:(NSString *)key;
@end


NS_ASSUME_NONNULL_END

#endif /* WGAppModuleService_h */




