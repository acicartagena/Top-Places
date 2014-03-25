//
//  PhotoViewController.m
//  Top Places
//
//  Created by Aci Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"


@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation PhotoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scrollView addSubview:self.imageView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self autoZoom];
}

- (UIImageView *)imageView
{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    
    // had to add these two lines in Shutterbug to fix a bug in "reusing" ImageViewController's MVC
    self.scrollView.zoomScale = 1.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // self.scrollView could be nil on the next line if outlet-setting has not happened yet
    self.scrollView.contentSize = image ? image.size : CGSizeZero;
    [self autoZoom];
    
}

- (void)autoZoom
{
    
    float scaleFactor;
    CGRect zoomRect;
    //landscape orientation
    if (self.view.frame.size.width > self.view.frame.size.height){
        
        zoomRect = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
        
        scaleFactor = self.view.frame.size.width/self.imageView.frame.size.width;
        if (self.imageView.frame.size.width > self.view.frame.size.width){
            zoomRect = CGRectMake(0.0f, 0.0f, self.imageView.frame.size.width, self.imageView.frame
                                  .size.height*scaleFactor);
        }else{
            zoomRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.imageView.frame
                                  .size.height*scaleFactor);
        }

    }else{
        
        scaleFactor = self.view.frame.size.height/self.imageView.frame.size.height;
        if (self.imageView.frame.size.height > self.view.frame.size.height){
            zoomRect = CGRectMake(0.0f, 0.0f, self.imageView.frame.size.width*scaleFactor, self.imageView.frame
                                  .size.height);
        }else{
            zoomRect = CGRectMake(0.0f, 0.0f, self.imageView.frame.size.width*scaleFactor, self.view.frame
                                  .size.height);
        }

    }
    [self.scrollView zoomToRect:zoomRect animated:YES];
    NSLog(@"frame: width: %f height: %f",self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // next three lines are necessary for zooming
    _scrollView.minimumZoomScale = 0.01;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    
    // next line is necessary in case self.image gets set before self.scrollView does
    // for example, prepareForSegue:sender: is called before outlet-setting phase
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (void)setPhoto:(Photo *)photo
{
    _photo = photo;
    [self startDownloadingImage];
}

- (void)startDownloadingImage
{
    self.image = nil;
    
    if (self.photo)
    {
        self.progressView.hidden = NO;
        self.progressView.progress = 0.0f;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.photo.photoUrl];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
        
        [task resume];
    }
}

#pragma mark - NSURLSessionDownload Delegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = image;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.progressView.hidden = YES;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
    
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

#pragma mark - UIScrollViewDelegate

// mandatory zooming method in UIScrollViewDelegate protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end