//
//  ViewController.m
//  scannerPlugin
//
//  Created by Grisha on 3/15/17.
//  Copyright © 2017 PayWithCents. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureMetadataOutput* output;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;

@property UIColor* tintColor;
@property UIImageView* scanShadeView;

@property BOOL scanAnimationFinished;
@property BOOL stopScanAnimationFlag;

-(UIImage*)rotateImage:(UIImage*)src degrees:(float) degrees;

@end

@implementation ScanViewController
{
    BOOL _torchStatus;
    
    float _scanX;
    float _scanY;
    float _scanBottom;
    float _scanW;
    float _scanH;
    
    UIImage* _imgScanShade;
    UIImage* _imgScanShadeFlipped;
}

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated;
{
    if(![self isCameraAvailable]) {
        [self setupNoCameraView];
    }
}

- (void) viewDidAppear:(BOOL)animated;
{
    if([self isCameraAvailable]) {
        //[self initTintLayer];
        [self initScanAnimation];
        [self setupScanner];
    }
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    _torchStatus = NO;
    self.scanAnimationFinished = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)evt
{
    if(self.touchToFocusEnabled) {
        UITouch *touch=[touches anyObject];
        CGPoint pt= [touch locationInView:self.view];
        [self focus:pt];
    }
}

#pragma mark -
#pragma mark NoCamAvailable

- (void) setupNoCameraView;
{
    UILabel *labelNoCam = [[UILabel alloc] init];
    labelNoCam.text = @"No Camera available";
    labelNoCam.textColor = [UIColor whiteColor];
    [self.view addSubview:labelNoCam];
    [labelNoCam sizeToFit];
    labelNoCam.center = self.view.center;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark AVFoundationSetup

- (void) setupScanner;
{
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.session = [[AVCaptureSession alloc] init];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:self.output];
    [self.session addInput:self.input];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    AVCaptureConnection *con = self.preview.connection;
    
    con.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    [self startScanning];
}

#pragma mark -
#pragma mark Helper Methods

- (BOOL) isCameraAvailable;
{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    return [videoDevices count] > 0;
}

- (void)startScanning;
{
    [self.session startRunning];
}

- (void) stopScanning;
{
    [self.session stopRunning];
}

- (void) setTorch:(BOOL) aStatus;
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ( [device hasTorch] ) {
        if ( aStatus ) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
    }
    [device unlockForConfiguration];
}

- (void) focus:(CGPoint) aPoint;
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if([device isFocusPointOfInterestSupported] &&
       [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        //CGRect screenRect = [[UIScreen mainScreen] bounds];
        //double screenWidth = screenRect.size.width;
        //double screenHeight = screenRect.size.height;
        double focus_x = aPoint.x/screenWidth;
        double focus_y = aPoint.y/screenHeight;
        if([device lockForConfiguration:nil]) {
            [device setFocusPointOfInterest:CGPointMake(focus_x,focus_y)];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            if ([device isExposureModeSupported:AVCaptureExposureModeAutoExpose]){
                [device setExposureMode:AVCaptureExposureModeAutoExpose];
            }
            [device unlockForConfiguration];
        }
    }
}

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    @try {
        for(AVMetadataObject *current in metadataObjects) {
            if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.delegate onScanResult:@"1" value:scannedValue];
                }];
                
                //            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Found QR code"
                //                                                                           message:scannedValue
                //                                                                    preferredStyle:UIAlertControllerStyleAlert];
                //
                //            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                //                                                                  handler:^(UIAlertAction * action) {
                //                                                                  }];
                //
                //            [alert addAction:defaultAction];
                //            [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Error %@", [exception description]);
    } @finally {
        
    }
}

#pragma mark Green transparent layer

#define TINT_INSET 3

- (void)initTintLayer
{
    UIImage* imgFrame = [UIImage imageNamed:@"CenterFrame"];
    float x = (self.view.frame.size.width - imgFrame.size.width) / 2;
    float y = (self.view.frame.size.height - imgFrame.size.height) / 2;
    
    self.tintColor = [UIColor colorWithRed:0.227f green:0.258f blue:0.255f alpha:0.85f];
    
    UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, y+TINT_INSET)];
    v1.backgroundColor = self.tintColor;
    [self.viewTint addSubview:v1];
    
    UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(0, y+imgFrame.size.height-TINT_INSET, self.view.frame.size.width, y+TINT_INSET)];
    v2.backgroundColor = self.tintColor;
    [self.viewTint addSubview:v2];
    
    UIView* v3 = [[UIView alloc] initWithFrame:CGRectMake(0, y+TINT_INSET, x+TINT_INSET, imgFrame.size.height-TINT_INSET*2)];
    v3.backgroundColor = self.tintColor;
    [self.viewTint addSubview:v3];
    
    UIView* v4 = [[UIView alloc] initWithFrame:CGRectMake(x+imgFrame.size.width-TINT_INSET, y+TINT_INSET, x+TINT_INSET, imgFrame.size.height-TINT_INSET*2)];
    v4.backgroundColor = self.tintColor;
    [self.viewTint addSubview:v4];
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:imgFrame];
    imgView.frame = CGRectMake(x, y, imgFrame.size.width, imgFrame.size.height);
    [self.viewTint addSubview:imgView];
    
    _imgScanShade = [UIImage imageNamed:@"ScanShade"];
    _imgScanShadeFlipped = [self rotateImage:_imgScanShade degrees:180];
    _scanX = x+TINT_INSET;
    _scanY = y+TINT_INSET;
    _scanBottom = y + imgFrame.size.height - _imgScanShade.size.height - TINT_INSET;
    _scanW = _imgScanShade.size.width-2;
    _scanH = _imgScanShade.size.height;
    
    self.scanShadeView = [[UIImageView alloc] initWithImage:_imgScanShade];
    self.scanShadeView.frame = CGRectMake(_scanX, y, _scanW, 0);
    [self.viewTint addSubview:self.scanShadeView];
}

#pragma mark scan animation

-(void)initScanAnimation
{
//    float x = (self.view.frame.size.width - self.imgViewCenterFrame.frame.size.width) / 2;
//    float y = (self.view.frame.size.height - self.imgViewCenterFrame.frame.size.height) / 2;
//    
//    _imgScanShade = [UIImage imageNamed:@"ScanShade"];
//    _imgScanShadeFlipped = [self rotateImage:_imgScanShade degrees:180];
//    _scanX = x+TINT_INSET;
//    _scanY = y+TINT_INSET;
//    _scanBottom = y + self.imgViewCenterFrame.frame.size.height - _imgScanShade.size.height - TINT_INSET;
//    _scanW = _imgScanShade.size.width-2;
//    _scanH = _imgScanShade.size.height;
    
    self.scanShadeView = [[UIImageView alloc] initWithImage:_imgScanShade];
    _imgScanShade = [UIImage imageNamed:@"ScanShade"];
    _imgScanShadeFlipped = [self rotateImage:_imgScanShade degrees:180];
    
    _scanX = 0;
    _scanY = 2;
    _scanBottom = self.imgViewCenterFrame.frame.size.height * kDeviceMultiplier-102;
    _scanW = _imgScanShade.size.width-TINT_INSET;
    _scanH = _imgScanShade.size.height;
    
    self.scanShadeView.frame = CGRectMake(_scanX, _scanY, _scanW, 0);
    [self.imgViewCenterFrame addSubview:self.scanShadeView];
    [self startScanAnimation];
}

-(void)startScanAnimation
{
    self.stopScanAnimationFlag = NO;
    [self performSelectorInBackground:@selector(scanAnimationProc) withObject:nil];
}

-(void)stopScanAnimation
{
    if (self.scanAnimationFinished)
        return;
    
    self.stopScanAnimationFlag = YES;
}

-(void)scanAnimationProc
{
    self.scanAnimationFinished = NO;
    
    BOOL __block loopRunning = YES;
    
    NSCondition* cond = [[NSCondition alloc] init];
    
    [cond lock];

    while (1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

        // phase 1
        [UIView animateWithDuration:0.3
                  delay:0
                options:UIViewAnimationOptionCurveLinear
             animations:^ {
                 self.scanShadeView.frame = CGRectMake(_scanX, _scanY, _scanW, _scanH);
             }completion:^(BOOL finished) {
                 if (self.stopScanAnimationFlag)
                 {
                     loopRunning = NO;
                     [cond signal];
                     return;
                 }
                 // phase 2
                 [UIView animateWithDuration:0.6
                           delay:0
                         options:UIViewAnimationOptionCurveLinear
                      animations:^ {
                          self.scanShadeView.frame = CGRectMake(_scanX, _scanBottom, _scanW, _scanH);
                      } completion:^(BOOL finished) {
                          if (self.stopScanAnimationFlag)
                          {
                              loopRunning = NO;
                              [cond signal];
                              return;
                          }
                          // phase 3
                          [UIView animateWithDuration:0.3
                                    delay:0
                                  options:UIViewAnimationOptionCurveLinear
                               animations:^ {
                                   self.scanShadeView.frame = CGRectMake(_scanX, _scanBottom+_scanH, _scanW, 0);
                               } completion:^(BOOL finished) {
                                   if (self.stopScanAnimationFlag)
                                   {
                                       loopRunning = NO;
                                       [cond signal];
                                       return;
                                   }
                                   // phase 4
                                   self.scanShadeView.image = _imgScanShadeFlipped;
                                   [UIView animateWithDuration:0.3
                                             delay:0
                                           options:UIViewAnimationOptionCurveLinear
                                        animations:^ {
                                            self.scanShadeView.frame = CGRectMake(_scanX, _scanBottom, _scanW, _scanH);
                                        } completion:^(BOOL finished) {
                                            if (self.stopScanAnimationFlag)
                                            {
                                                loopRunning = NO;
                                                [cond signal];
                                                return;
                                            }
                                            // phase 5
                                            [UIView animateWithDuration:0.6
                                                      delay:0
                                                    options:UIViewAnimationOptionCurveLinear
                                                 animations:^ {
                                                     self.scanShadeView.frame = CGRectMake(_scanX, _scanY, _scanW, _scanH);
                                                 } completion:^(BOOL finished) {
                                                     if (self.stopScanAnimationFlag)
                                                     {
                                                         loopRunning = NO;
                                                         [cond signal];
                                                         return;
                                                     }
                                                     // phase 6
                                                     [UIView animateWithDuration:0.3
                                                               delay:0
                                                             options:UIViewAnimationOptionCurveLinear
                                                          animations:^ {
                                                              self.scanShadeView.frame = CGRectMake(_scanX, _scanY, _scanW, 0);
                                                          } completion:^(BOOL finished) {
                                                              // finishing loop
                                                              self.scanShadeView.image = _imgScanShade;
                                                              [cond signal];
                                                          }];
                                                 }];
                                        }];
                               }];
                      }];
             }];
        });
        
        [cond wait];

        if (self.stopScanAnimationFlag)
            break;
    }
    
    self.scanAnimationFinished = YES;
}

#pragma mark events

- (IBAction)onBtnFlash:(id)sender {
    _torchStatus = !_torchStatus;
    [self setTorch:_torchStatus];
}
- (IBAction)onBtnBank:(id)sender {
    @try {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate onScanResult:@"2" value:@""];
        }];
    } @catch (NSException *exception) {
        NSLog(@"Error %@", [exception description]);
    } @finally {
        
    }
}
- (IBAction)onBtnRewards:(id)sender {
    @try {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate onScanResult:@"3" value:@""];
        }];    } @catch (NSException *exception) {
        NSLog(@"Error %@", [exception description]);
    } @finally {
        
    }
}

#pragma mark utils

static inline double radians (double degrees) {return degrees * M_PI/180;}
-(UIImage*)rotateImage:(UIImage*)src degrees:(float) degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,src.size.width, src.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, radians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-src.size.width / 2, -src.size.height / 2, src.size.width, src.size.height), [src CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;

}


@end
