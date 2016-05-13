//
//  MyWebVC.m
//  cmm
//
//  Created by ilikeido on 16/3/25.
//
//

#import "MyWebVC.h"
#import "SliderVC.h"

@interface MyWebVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MyWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    _webView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUrl:(NSString *)url{
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.absoluteString isEqual:@"native://left"]) {
        [[SliderVC shareSliderVC]showLeftViewController];
        return NO;
    }
    if ([request.URL.absoluteString isEqual:@"native://close"]) {
       [self dismissViewControllerAnimated:YES completion:^{
           
       }];
       return NO;
    }
    return YES;
}

@end
