
#import "WebViewController.h"
#import "Masonry.h"
#import "CommonUtil.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

@interface WebViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
{
    NSString *_oldTitle;
    BOOL _like;
}
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation WebViewController


#pragma mark - 设置webvc 标题
-(void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    _titleLabel.text = _titleName;
}

- (void)viewDidLoad {
    
    //隐藏系统的navigationController
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    [super viewDidLoad];
//    
    [self createControl];
    [self createCustomBar];
    [self layout];
    
    
}

#pragma mark - 隐藏tabBar
- (void)createControl{
 
    self.navigationController.tabBarController.tabBar.hidden = YES;

}
#pragma mark - 添加自定义的navigationBar 和 自定义toolbar
- (void)createCustomBar{
    
    

    //navBar
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = COLOR;
    //navBar
    UIView *myBar       = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.origin.x, SCREEN_SIZE.origin.y, SCREEN_SIZE.size.width, 64)];
    [myBar setBackgroundColor:COLOR];
    [self.view addSubview:myBar];
    
    
    UIButton *btn       = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame           = CGRectMake(10, 30, 15, 25);
    UIImage *btnImg = [UIImage imageNamed:@"ic_back"];
    [btn setImage:btnImg forState:UIControlStateNormal];
    [myBar addSubview:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2       = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame           = CGRectMake(SCREEN_SIZE_WIDTH-25, 30, 15, 25);
    btn2.transform = CGAffineTransformMakeScale(-1, 1);
    [btn2 setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [myBar addSubview:btn2];
    [btn2 addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    [myBar addSubview:btn2];
    
    
    _titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _titleLabel.center        = myBar.center;
    _titleLabel.textColor     = [UIColor whiteColor];
    _titleLabel.text          = _titleName
    ;
    _titleLabel.font          = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [myBar addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(myBar.mas_bottom).offset(-10);
        make.centerX.equalTo(myBar.mas_centerX);
    }];
    
    
    
    
    
    UIView *toolbar1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE_HEIGHT-BAR_TOOL_HEIGHT, SCREEN_SIZE_WIDTH, BAR_TOOL_HEIGHT)];
    UIView *toolbar2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_SIZE_HEIGHT-BAR_TOOL_HEIGHT, SCREEN_SIZE_WIDTH, BAR_TOOL_HEIGHT)];
    toolbar2.backgroundColor = [UIColor whiteColor];
    toolbar2.alpha = 0.8;
//    toolbar1.backgroundColor = COLOR;
    [self.view addSubview:toolbar2];
    [self.view addSubview:toolbar1];
 
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.tag = 101;
    collectBtn.frame = CGRectMake(5, 0, BAR_TOOL_HEIGHT, BAR_TOOL_HEIGHT);
    collectBtn.userInteractionEnabled = NO;
    [collectBtn setImage:[UIImage imageNamed:@"ic_community_group_detail_like"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"ic_community_group_detail_liked"] forState:UIControlStateSelected];
    UIView *like = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, BAR_TOOL_HEIGHT)];
//    like.backgroundColor = [UIColor yellowColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap:)];
    [like addGestureRecognizer:tap];
    [toolbar1 addSubview:collectBtn];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 110, BAR_TOOL_HEIGHT)];
    label.text = @"收藏到本地";
    label.font = [UIFont systemFontOfSize:14];
    [toolbar1 addSubview:label];
    [toolbar1 addSubview:like];
    
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE_WIDTH-160, 0, 160, BAR_TOOL_HEIGHT)];
    label2.text = @"将此链接分享到";
    label2.backgroundColor = [UIColor yellowColor];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    UIView *share = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE_WIDTH-160, 0, 160, BAR_TOOL_HEIGHT)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareTap:)];
    [share addGestureRecognizer:tap1];
    [toolbar1 addSubview:label2];
    [toolbar1 addSubview:share];
}
#pragma mark - 分享按钮
- (void)shareTap:(UITapGestureRecognizer *)tap{
    NSString *shareText = nil;
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *url = self.webView.request.URL.absoluteString;
    if (self.webView.canGoBack) {
        shareText = [NSString stringWithFormat:@"%@:%@  来自购乐美.\"购乐美,怎么买都买不够!\"",title,url];
        //如果是热拍 收藏titleName
    }else{
       shareText = [NSString stringWithFormat:@"%@ 来自购乐美.\"购乐美,怎么买都买不够!\"",_titleName];
    }
    
    
    
    [UMSocialWechatHandler setWXAppId:@"wx4cfb90803b47d2ab" appSecret:@"29ca5404eb6d6c062fff1ce4b0f8df42" url:url];
    [UMSocialQQHandler setQQWithAppId:@"1105198270" appKey:@"BTDXe0aISBZQGJ27" url:url];

    WeakSelf(weakSelf);
    [UMSocialSnsService presentSnsIconSheetView:weakSelf
                                         appKey:YouMeng_KEY
                                      shareText:shareText
                                     shareImage:weakSelf.img
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToEmail,UMShareToSms,UMShareToSina,UMShareToWechatSession,UMShareToQQ,nil]
                                       delegate:weakSelf];
}

#pragma mark - 收藏按钮
- (void)likeTap:(UITapGestureRecognizer *)tap{
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *url = self.webView.request.URL.absoluteString;
    if (!_like) {
        //如果是淘宝页 收藏网站title
        if (self.webView.canGoBack) {
            [CommonUtil saveLocalFavouriteTitle:title andUrl:url];
        //如果是热拍 收藏titleName
        }else{
            [CommonUtil saveLocalFavouriteTitle:_titleName andUrl:url];
        }
    }else{
        if (self.webView.canGoBack) {
            [CommonUtil delectLocalFavouriteByTitle:title];
            //如果是热拍 收藏titleName
        }else{
            [CommonUtil delectLocalFavouriteByTitle:_titleName];
        }
    }
    _like = !_like;
    [self collectClick];
}


#pragma mark - 红心

- (void)collectClick{
    UIButton  *btn = (UIButton *)[self.view viewWithTag:101];
    if (btn.selected == YES) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}


#pragma mark - 向前跳转页面
- (void)forward{
    if (self.webView.canGoForward) {
        [self.webView stopLoading];
        [self.webView goForward];
    }
}
#pragma mark - 按钮点击返回
- (void)back{
    
    //删除加载动画
    [CommonUtil removeLoadingViewOn:self.view];
    
    if(self.webView.canGoBack){
        [self.webView stopLoading];
        [self.webView goBack];
        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if([title isEqualToString:_oldTitle]){
             [self.webView goBack];
             [self.webView goBack];
        }

    }else {
        //视图跳转
        [self.navigationController popViewControllerAnimated:YES];
      
    }
}
#pragma mark - 创建webView 视图
-(void)layout
{
 
    //添加浏览器空间
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-64-BAR_TOOL_HEIGHT)];

//    //数据监测
    self.webView.delegate=self;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.webView addGestureRecognizer:swipe];
    [self.view addSubview:self.webView];
    
    [self request];
    
}
#pragma mark - 轻扫动作返回
- (void)swipeClick:(UISwipeGestureRecognizer *)swip{
    if (swip.direction == UISwipeGestureRecognizerDirectionRight) {
        [self back];
    }
}


#pragma mark －浏览器请求
-(void)request
{
   
    //创建请求
    NSURLRequest * request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    //加载请求页面
    [self.webView loadRequest:request];
    
    //重置红心和收藏
    
}
#pragma mark - 重置收藏红心
- (void)resetLike{
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    NSLog(@"%@",title);
    if (self.webView.canGoBack) {
        if ([CommonUtil isExistInFavourite:title]) {
            _like = YES;
            UIButton  *btn = (UIButton *)[self.view viewWithTag:101];
            btn.selected = YES;
        }else{
            _like = NO;
            UIButton  *btn = (UIButton *)[self.view viewWithTag:101];
            btn.selected = NO;
        }
    }else{
        if ([CommonUtil isExistInFavourite:_titleName]) {
            _like = YES;
            UIButton  *btn = (UIButton *)[self.view viewWithTag:101];
            btn.selected = YES;
        }else{
            _like = NO;
            UIButton  *btn = (UIButton *)[self.view viewWithTag:101];
            btn.selected = NO;
        }
    }
}
#pragma mark －webView的代理方法
#pragma mark－开始加载
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示网络加载
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        [CommonUtil addLoadingViewOn:self.view];

}
#pragma mark －加载完毕
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //删除加载动画
    [CommonUtil removeLoadingViewOn:self.view];
    //隐藏加载网络请求图标
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    
    //保存标题
    _oldTitle = [NSString stringWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    [self resetLike];
    
}


#pragma mark－加载失败
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error detail:%@",error.localizedDescription);
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"系统提示" message:@"网络连接发生错误!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
}

//截取 UIWebView的页面跳转,返回YES 加载页面,返回NO 不加载页面(已经跳转)
// 扩展应用:在软件开发如果使用第三方跨平台操作比较麻烦,用该方法可以完成简单的本地与Web页面的交互操作,(与web开发人员定义一套url协议,规定web点击穿过来的url本地解析字符,然后做本地操作)
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
