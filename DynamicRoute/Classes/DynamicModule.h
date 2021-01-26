//
//  DynamicModule.h
//  DynamicRoute
//
//  Created by chen liang on 2021/1/26.
//

#import <Foundation/Foundation.h>
#import <WGRouter/BifrostHeader.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicModule : NSObject<BifrostModuleProtocol>
@property (nonatomic, strong, readonly) NSDictionary *configs;

@end

NS_ASSUME_NONNULL_END
