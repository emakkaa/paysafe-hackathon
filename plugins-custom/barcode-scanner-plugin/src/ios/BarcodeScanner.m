#import "BarcodeScanner.h"

@implementation BarcodeScanner
{
    CDVInvokedUrlCommand* _command;
}

- (void)pluginInitialize
{
}

- (void)scan:(CDVInvokedUrlCommand*)command
{
//  NSString* callbackId = command.callbackId;
//  NSString* title = @"iOS title";
//  NSString* message = @"iOS message";
//  NSString* button = @"iOS button";
//
//  MyAlertView *alert = [[MyAlertView alloc]
//                        initWithTitle:title
//                        message:message
//                        delegate:self
//                        cancelButtonTitle:button
//                        otherButtonTitles:nil];
//                        alert.callbackId = callbackId;
//  [alert show];
    
    _command = command;
    ScanViewController *scanVc = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
    scanVc.delegate = self;
    [self.viewController presentViewController:scanVc animated:YES completion:nil];
}

-(void)onScanResult:(NSString*)code value:(NSString*)value
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", value, @"value", nil];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:result callbackId:_command.callbackId];
    
}

@end

