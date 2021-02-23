//
//  GCDWebServerViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/20.
//

#import "GCDWebServerViewController.h"

#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import "GCDWebDAVServer.h"
#import "GCDWebUploader.h"

@interface GCDWebServerViewController () <GCDWebServerDelegate, GCDWebUploaderDelegate>

@end

@implementation GCDWebServerViewController
{
    GCDWebServer * _webServer;
    GCDWebDAVServer * _davServer;
    GCDWebUploader * _webUploader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self gcdUploader];
}

-(void)gcdUploader {
//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
//    _davServer = [[GCDWebDAVServer alloc] initWithUploadDirectory:documentsPath];
//    [_davServer start];
//    NSLog(@"Visit %@ in your WebDAV client", _davServer.serverURL);
    
    NSString * documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    _webUploader.delegate = self;
    _webUploader.title = @"Dan App";
    _webUploader.footer = @"323";
    [_webUploader start];
    
    NSArray * files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsPath error:nil];
    NSLog(@"%@", files);
}

-(void)gcdServer {
    // Create server
    _webServer = [[GCDWebServer alloc] init];
    
    _webServer.delegate = self;
    
    // Add a handler to respond to GET requests on any URL
    [_webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hello World 1</p></body></html>"];
        
    }];
    
    // Start server on port 8080
    [_webServer startWithPort:8080 bonjourName:@"s"];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - GCDWebUploaderDelegate
/**
 *  This method is called whenever a file has been downloaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDownloadFileAtPath:(NSString*)path {
    
}

/**
 *  This method is called whenever a file has been uploaded.
 */
- (void)webUploader:(GCDWebUploader*)uploader didUploadFileAtPath:(NSString*)path {
    
}

/**
 *  This method is called whenever a file or directory has been moved.
 */
- (void)webUploader:(GCDWebUploader*)uploader didMoveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath {
    
}

/**
 *  This method is called whenever a file or directory has been deleted.
 */
- (void)webUploader:(GCDWebUploader*)uploader didDeleteItemAtPath:(NSString*)path {
    
}

/**
 *  This method is called whenever a directory has been created.
 */
- (void)webUploader:(GCDWebUploader*)uploader didCreateDirectoryAtPath:(NSString*)path {
    
}

#pragma mark - GCDWebServerDelegate

- (void)webServerDidStart:(GCDWebServer *)server {
    NSLog(@"Visit %@ in your web browser %@", server.serverURL, server.bonjourServerURL);
}

- (void)webServerDidCompleteBonjourRegistration:(GCDWebServer *)server {
    NSLog(@"Visit %@ in your web browser %@", server.serverURL, server.bonjourServerURL);
}

@end
