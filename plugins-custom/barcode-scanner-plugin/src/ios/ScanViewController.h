//
//  ViewController.h
//  scannerPlugin
//
//  Created by Grisha on 3/15/17.
//  Copyright © 2017 PayWithCents. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define screenWidth                           [[UIScreen mainScreen] bounds].size.width
#define screenHeight                          [[UIScreen mainScreen] bounds].size.height
#define kDeviceMultiplier                     screenWidth / 375

@protocol ScanViewControllerDelegate
-(void)onScanResult:(NSString*)code value:(NSString*)value;
@end

@interface ScanViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (assign, nonatomic) BOOL touchToFocusEnabled;
@property (weak, nonatomic) IBOutlet UIView *viewTint;
@property (weak, nonatomic) IBOutlet UIButton *btnFlash;
@property (weak, nonatomic) id<ScanViewControllerDelegate> delegate;
@property (weak, nonatomic) NSString* pluginCallbackId;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCenterFrame;

- (BOOL) isCameraAvailable;
- (void) startScanning;
- (void) stopScanning;
- (void) setTorch:(BOOL) aStatus;

@end

