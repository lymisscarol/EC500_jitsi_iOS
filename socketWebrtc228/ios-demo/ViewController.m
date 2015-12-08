//
//  ViewController.m
//  Copyright (c) 2014 &yet, LLC and otalk contributors
//

#import "ViewController.h"
#import "TLKSocketIOSignaling.h"
#import "TLKMediaStream.h"
#import "RTCMediaStream.h"
#import "RTCEAGLVideoView.h"
#import "RTCVideoTrack.h"
#import "RTCAVFoundationVideoSource.h"
#import "loginViewContoller.h"

#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度

@interface ViewController () <TLKSocketIOSignalingDelegate, RTCEAGLVideoViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) TLKSocketIOSignaling* signaling;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet UIView *localView;
@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;
@property (strong, nonatomic) NSArray *streamList;

@property (strong, nonatomic) NSString *RoomID;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController
{
    
//    UIButton *_loginButton;
    UIButton *_StreamButton;
    NSMutableArray *list ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    list = [[NSMutableArray alloc] init];
    
    _RoomID = [[NSString alloc] init];
    _streamList = [[NSArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(captureSessionDidStartRunning)
                                                 name:AVCaptureSessionDidStartRunningNotification
                                               object:nil];

    //RTCEAGLVideoViewDelegate provides notifications on video frame dimensions
    [self.remoteView setDelegate:self];
//    [self.remoteView setFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    
    
//    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _loginButton.frame = CGRectMake(0, kMainScreenHeight-40, kMainScreenWidth, 40);
//    [_loginButton setBackgroundColor:[UIColor clearColor]];
//    [_loginButton setTitle:@"RoomID" forState:UIControlStateNormal];
//    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    _StreamButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _StreamButton.frame = CGRectMake(0, kMainScreenHeight-40, kMainScreenWidth, 40);
//    [_StreamButton setBackgroundColor:[UIColor clearColor]];
//    [_StreamButton setTitle:@"stream" forState:UIControlStateNormal];
//    [_StreamButton addTarget:self action:@selector(streamButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_StreamButton setHidden:YES];
    
//    [self.remoteView addSubview:_StreamButton];
//    [self.remoteView addSubview:_loginButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoomID:) name:@"roomid" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{

    if ([_RoomID isEqualToString:@""]||_RoomID==nil) {
        

        [self roomID];

    }
    
    
}

- (void)captureSessionDidStartRunning {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configureLocalPreview];
    });
}

- (void)configureLocalPreview {
    RTCVideoTrack *videoTrack = [self.signaling.localMediaStream.videoTracks firstObject];
    // There is a chance that this video source is not an RTCAVFoundationVideoSource, but we know it should be from TLKWebRTC
    RTCAVFoundationVideoSource *videoSource = (RTCAVFoundationVideoSource*)videoTrack.source;
    AVCaptureSession *captureSession = [videoSource captureSession];

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    self.previewLayer.frame = self.localView.bounds;

    [self.localView.layer addSublayer:self.previewLayer];
}

#pragma mark - TLKSocketIOSignalingDelegate

- (void)socketIOSignaling:(TLKSocketIOSignaling *)socketIOSignaling addedStream:(TLKMediaStream *)stream {
    NSLog(@"addedStream");
    [list addObject:stream.stream.videoTracks[0]];
    if (list.count == 1) {
        RTCVideoTrack *remoteVideoTrack = stream.stream.videoTracks[0];
        
        if(self.remoteVideoTrack) {
            [self.remoteVideoTrack removeRenderer:self.remoteView];
            self.remoteVideoTrack = nil;
            [self.remoteView renderFrame:nil];
        }
        
        self.remoteVideoTrack = remoteVideoTrack;
        [self.remoteVideoTrack addRenderer:self.remoteView];
        
        
    }else
    {
        [self allocRemotViewWithArray:list];
    }

    
}

-(void)serverRequiresPassword:(TLKSocketIOSignaling*)server{
    NSLog(@"serverRequiresPassword");
}
-(void)removedStream:(TLKMediaStream*)stream{
    NSLog(@"removedStream");
}
-(void)peer:(NSString*)peer toggledAudioMute:(BOOL)mute{
    NSLog(@"toggledAudioMute");
}
-(void)peer:(NSString*)peer toggledVideoMute:(BOOL)mute{
    NSLog(@"toggledVideoMute");
}
-(void)lockChange:(BOOL)locked{
    NSLog(@"locked");
}

-(void)allocRemotViewWithArray:(NSArray *)videoTrackList
{
    
    
    if (videoTrackList.count>1) {
        for (int i =2 ; i<=videoTrackList.count; i++) {
            UIView * videoView=[[UIView alloc] init];
            videoView.frame = [self returnFrame:i];
            
            RTCVideoTrack *videoTrack = [videoTrackList objectAtIndex:i-1];
            // There is a chance that this video source is not an RTCAVFoundationVideoSource, but we know it should be from TLKWebRTC
            
            RTCEAGLVideoView * uiRTCView = [[RTCEAGLVideoView alloc] initWithFrame:CGRectMake(0, 0, videoView.frame.size.width, videoView.frame.size.height)];
            
            [videoTrack addRenderer:uiRTCView];
            
            //RTCAVFoundationVideoSource *videoSource = (RTCAVFoundationVideoSource*)videoTrack.source;
            
            
            [videoView addSubview:uiRTCView];
            
            [self.view addSubview:videoView];
        }
    }
}

-(CGRect )returnFrame:(int)Num
{
    float gapWidth = CGRectGetMinX(self.localView.frame);
    float gapHigth = CGRectGetMinY(self.localView.frame);
    float localMaxWith = CGRectGetWidth(self.localView.frame);
    float localMaxHeight = CGRectGetHeight(self.localView.frame);
    
    int maxNox=kMainScreenHeight/CGRectGetMaxX(self.localView.frame);
    int maxNoy=kMainScreenWidth/CGRectGetMaxY(self.localView.frame);
    
    if (Num<maxNox*maxNoy) {
        if (fmod(Num, maxNox)==0) {
            return CGRectMake((localMaxWith+gapWidth)*(maxNox-1)+gapWidth, (localMaxHeight+gapHigth)*(Num/maxNox-1)+gapHigth, localMaxWith, localMaxHeight);
        }else
        {
            return CGRectMake((localMaxWith+gapWidth)*(fmod(Num, maxNox)-1)+gapWidth,  (localMaxHeight+gapHigth)*(Num/maxNox)+gapHigth, localMaxWith, localMaxHeight);
            
        }
    }else
    {
        return CGRectZero;
    }
}

#pragma mark - RTCEAGLVideoViewDelegate

-(void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size {
    NSLog(@"videoView ?");
}

-(void)roomID
{
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"RoomID" message:@"RoomID" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"RoomID";
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *login = alertController.textFields.firstObject;
        if (login.text.length>0) {
            _RoomID = login.text;
            self.signaling = [[TLKSocketIOSignaling alloc] initWithVideo:YES];
            //TLKSocketIOSignalingDelegate provides signaling notifications
            self.signaling.delegate = self;
            [self.signaling connectToServer:@"signaling.simplewebrtc.com" port:80 secure:NO success:^{
                [self.signaling joinRoom:_RoomID success:^{
                    NSLog(@"join success");
                } failure:^{
                    NSLog(@"join failure");
                    _RoomID = nil;
                }];
                NSLog(@"connect success");
            } failure:^(NSError* error) {
                NSLog(@"connect failure");
                _RoomID = nil;
                
            }];
        }else
        {
            [self errorAlter];
        }
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
//    [self addChildViewController:alertController];
     */
    loginViewContoller  *loginview = [[loginViewContoller alloc] init];
    [self presentViewController:loginview animated:YES completion:nil];
}

-(void)errorAlter
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"connect/join Error" message:@"connect/join Error" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)loginButtonClicked:(id)sender
{
    [self roomID];
}

-(void)getRoomID:(NSNotification*)notify
{
    NSString *roomid = [[notify userInfo] objectForKey:@"roomid"];
    if (roomid.length>0) {
        _RoomID = roomid;
        self.signaling = [[TLKSocketIOSignaling alloc] initWithVideo:YES];
        //TLKSocketIOSignalingDelegate provides signaling notifications
        self.signaling.delegate = self;
        [self.signaling connectToServer:@"signaling.simplewebrtc.com" port:80 secure:NO success:^{
            [self.signaling joinRoom:_RoomID success:^{
                NSLog(@"join success");
            } failure:^{
                NSLog(@"join failure");
                _RoomID = nil;
            }];
            NSLog(@"connect success");
        } failure:^(NSError* error) {
            NSLog(@"connect failure");
            _RoomID = nil;
            
        }];
    }else
    {
        [self errorAlter];
    }
}
@end
