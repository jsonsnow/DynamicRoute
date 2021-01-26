//
//  WGWebModuleService.h
//  Mediator
//
//  Created by chen liang on 2021/1/7.
//

#ifndef WGWebModuleService_h
#define WGWebModuleService_h

#import <WGRouter/BifrostHeader.h>
#import <WebKit/Webkit.h>
//webview
static NSString * const kRouteWebPath = @"//web/open";
static NSString * const kRouteMQWebPath = @"//web/openMQ";
static NSString * const kRouteWebUrlParams = @"url";
static NSString * const kRouteWebScriptsParams = @"scripts";
static NSString * const kRouteMQWebShareItemsParams = @"shareItems";
static NSString * const kkRouteWebIsRegParams = @"isReg";


@protocol WebModuleService <NSObject>
@property (nonatomic, weak, readonly) WKWebView *webview;

- (WKWebView *)webView;

@end

#endif /* WGWebModuleService_h */
