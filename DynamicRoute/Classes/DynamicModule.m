//
//  DynamicModule.m
//  DynamicRoute
//
//  Created by chen liang on 2021/1/26.
//

#import "DynamicModule.h"
#import <WGNet/WGNet-Swift.h>

@interface DynamicModule ()
@property (nonatomic, strong) NSDictionary *configs;

@end

@implementation DynamicModule

+ (void)load {
    [Bifrost registerService:@protocol(BifrostModuleProtocol) withModule:self];
}

+ (instancetype)sharedInstance {
    static DynamicModule *module = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [[DynamicModule alloc] init];
    });
    return module;
}

- (void)setup {
    [self loadConfigData];
}

+ (BOOL)setupModuleSynchronously {
    return YES;
}

+ (NSUInteger)priority {
    return 999;
}

#pragma mark --UIApplication

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    [self requestConfig];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self requestConfig];
}

#pragma mark -- private method

- (NSString *)configPath {
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *configPath = [documentPath stringByAppendingPathComponent:@"routerConfigs"];
    return configPath;
}

- (void)loadConfigData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self configPath]]) {
        self.configs = [NSDictionary dictionaryWithContentsOfFile:[self configPath]];
    } else {
        NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource:@"DynamicRoute" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        NSDictionary *configs = [NSDictionary dictionaryWithContentsOfFile:[bundle pathForResource:@"RoutConfig" ofType:@"plist"]];
         self.configs = configs;
    }
}

- (void)saveConfig:(NSDictionary *)configs {
    [configs writeToFile:[self configPath] atomically:YES];
}

- (void)requestConfig {
    [[NetLayer net] albumRequstWithPath:@"sys/routeConfig" params:nil callback:^(WGConnectData * _Nonnull data) {
        if (data.isSuccess) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self saveConfig:data.result];
                [self loadConfigData];
            });
        }
    }];
}

@end
