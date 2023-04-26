/********* CordovaPluginPaymev2.m Cordova Plugin Implementation *******/

#import "CordovaPluginPaymev2.h"

@implementation CordovaPluginPaymev2

@synthesize responsePayCallbackId = _responsePayCallbackId;

CordovaPluginPaymev2 *cordovaPluginPayme;

+ (CordovaPluginPaymev2 *) cordovaPluginPayme {
    return cordovaPluginPayme;
}

/*- (void)pluginInitialize {
    NSLog(@"CordovaPluginPaymev2 - Starting plugin");
    cordovaPluginPayme = self;
}*/

- (void)initPayme:(CDVInvokedUrlCommand*)command
{
    
    self.responsePayCallbackId = command.callbackId;
    NSLog(@"callback %@",self.responsePayCallbackId);
    if (self.responsePayCallbackId != nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableString *jsonString = [command.arguments objectAtIndex:0];
            NSError *jsonError;
            NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:&jsonError];
        
            PaymeViewControllerv2 *pvc = [PaymeViewControllerv2 sharedHelper:jsonData callback:self.responsePayCallbackId];
            pvc.request = [[NSDictionary alloc] initWithDictionary:jsonData copyItems:YES];
            [pvc presentPayMeControllerWithDelegate:jsonData];
        });
        
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}


- (void)sendResponsePay:(NSString *)responseText callbackId:(NSString *)callbackId
{
    if (callbackId != nil) {
        NSLog(@"In response = %@",callbackId);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseText];
        [pluginResult setKeepCallbackAsBool:NO];
        NSLog(@"In response = %@",pluginResult);
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackId];
        NSLog(@"In response fin");
    }
}

@end
