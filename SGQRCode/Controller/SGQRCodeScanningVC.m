//
//  SGQRCodeScanningVC.m
//  SGQRCodeExample
//
//  Created by apple on 17/3/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "SGQRCodeScanningView.h"
#import "SGQRCodeConst.h"
#import "UIImage+SGHelper.h"

@interface SGQRCodeScanningVC () <AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/// 会话对象
@property (nonatomic, strong) AVCaptureSession *session;
/// 图层类
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;
@end

@implementation SGQRCodeScanningVC

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationBar];
    [self.view addSubview:self.scanningView];
    [self setupSGQRCodeScanning];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"scan it";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Album" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)rightBarButtonItenAction {
    [self readImageFromAlbum];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // Fence function
    dispatch_barrier_async(queue, ^{
        [self removeScanningView];
    });
}

- (void)readImageFromAlbum {
    
    // 1、 Get the camera device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        // Determine the authorization status
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) { // The user has not made a choice
            // Pixel request user authorization
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    // The user first agreed to access the album permissions
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                        //(Selection type) indicates that only photos are selected from the album
                        imagePicker.delegate = self;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    });
                } else { // The user first denied access to the camera
                    
                }
            }];
            
        } else if (status == PHAuthorizationStatusAuthorized) { // The user allows the current application to access the album
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //(Selection type) indicates that only photos are selected from the album
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        } else if (status == PHAuthorizationStatusDenied) { // The user rejects the current application to access the album
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ Info" message:@"Go to -> [Settings - Privacy - Photo - Open Access Switch" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == PHAuthorizationStatusRestricted) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Tips" message:@"The album can not be accessed due to system reasons" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
}
#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.view addSubview:self.scanningView];
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.view addSubview:self.scanningView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - - - Identify two-dimensional code from the album and interface jump
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // The selection of the photo processing, if the selected picture size is too large, then select the picture compression, or not for processing
    image = [UIImage imageSizeWithScreenImage:image];
    
    //CIDetector (CIDetector can be used for face recognition) for image analysis, so that we can easily get from the album to the two-dimensional code
    // Declare a CIDetector and set the recognition type CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // Get the recognition result
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        // Scanned result
    }
}

- (void)setupSGQRCodeScanning {
    // 1、Get the camera device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 2、Create input stream
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 3、Create an output stream
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、Set the agent to refresh in the main thread
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Set the scan range (each value of 0 to 1, the upper right corner of the screen for the coordinates of the origin)
    // Note: WeChat two-dimensional code scanning range is the entire screen, there is no processing (not set)
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    
    // 5、Initialize the link object (session object)
    self.session = [[AVCaptureSession alloc] init];
    // High quality collection rate
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 5.1 Add session input
    [_session addInput:input];
    
    // 5.2 Add session output
    [_session addOutput:output];
    
    // 6、After setting the output data type, you need to add meta data to the session, in order to specify the type of metadata, otherwise it will error
    // Set the encoding format supported by the sweep code (set bar code and two-dimensional code as follows)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、Instantiate the preview layer and pass _session to tell the layer what to display in the future
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    // 8、Insert the layer into the current view
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
    // 9、Start the session
    [_session startRunning];
}
#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 0、A successful tone after scanning
    [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
    
    // 1、If the scan is complete, stop the session
    [self.session stopRunning];
    
    // 2、Delete the preview layer
    [self.previewLayer removeFromSuperlayer];
    
    // 3、Set the interface to display the scan results
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** Play the sound file */
- (void)SG_playSoundEffect:(NSString *)name {
    // Get sound effects
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    // 1、Get the system sound ID
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 2、Play audio
    AudioServicesPlaySystemSound(soundID); // Play sound effects
}
/** Playback completes the callback function*/
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    //SGQRCodeLog(@"Play done...");
}

@end

