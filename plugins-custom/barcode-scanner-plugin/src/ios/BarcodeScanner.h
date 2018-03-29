#import <Cordova/CDV.h>
#import "ScanViewController.h"

@interface BarcodeScanner : CDVPlugin <UIAlertViewDelegate, ScanViewControllerDelegate>

- (void)onScanResult:(NSString*)code value:(NSString*)value;

@end
