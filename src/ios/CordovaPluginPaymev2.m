/********* CordovaPluginPaymev2.m Cordova Plugin Implementation *******/

#import "CordovaPluginPaymev2.h"

@implementation CordovaPluginPaymev2

@synthesize responsePayCallbackId = _responsePayCallbackId;

CordovaPluginPaymev2 *cordovaPluginPayme;

+ (CordovaPluginPaymev2 *) cordovaPluginPayme {
    return cordovaPluginPayme;
}

- (void)pluginInitialize {
    NSLog(@"CordovaPluginPaymev2 - Starting plugin");
    cordovaPluginPayme = self;
}

- (void)initPayme:(CDVInvokedUrlCommand*)command
{
    
    self.responsePayCallbackId = command.callbackId;
    if (self.responsePayCallbackId != nil) {
        NSMutableString *jsonString = [command.arguments objectAtIndex:0];
        NSError *jsonError;
        NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:objectData
                                      options:0
                                        error:&jsonError];

        PayViewControllerv2 *pvc = [PayViewControllerv2 sharedHelper:jsonData callback:self.responsePayCallbackId];
        pvc.request = [[NSDictionary alloc] initWithDictionary:jsonData copyItems:YES];
        [pvc presentPayMeControllerWithDelegate:jsonData];
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } else {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}


- (void)sendResponsePay:(NSString *)responseText callbackId:(NSString *)callbackId
{
    if (callbackId != nil) {
        NSLog(@"In response = %@",self.responsePayCallbackId);
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:responseText];
        [pluginResult setKeepCallbackAsBool:NO];
       [self.commandDelegate sendPluginResult:pluginResult callbackId:self.responsePayCallbackId];
    }
}

@end