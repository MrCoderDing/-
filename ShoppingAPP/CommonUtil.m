//
//  CommonUtil.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/17.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "CommonUtil.h"
#import "LoadingView.h"
#import "WebViewController.h"

@implementation CommonUtil
+ (UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)getRandomColor
{
    return [UIColor colorWithRed:(float)(1+arc4random()%99)/100 green:(float)(1+arc4random()%99)/100 blue:(float)(1+arc4random()%99)/100 alpha:1];
}

/*0--1 : lerp( float percent, float x, float y ){ return x + ( percent * ( y - x ) ); };*/
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax
{
    float result = nMin;
    
    result = nMin + percent * (nMax - nMin);
    
    return result;
}

+ (void)addLoadingViewOn:(UIView *)view{
    //先判断是否加载动画是否存在
    UIView *lView = [view viewWithTag:LoadingView_TAG];
    if (!lView) {
        lView = [[LoadingView alloc] initWithView:view];
        lView.tag = LoadingView_TAG;
        lView.userInteractionEnabled = NO;
        [view addSubview:lView];
    }
}
+ (void)removeLoadingViewOn:(UIView *)view{
    
    UIView *lView = [view viewWithTag:LoadingView_TAG];
    if (lView) {
        [lView removeFromSuperview];
    }
}
+ (void)gotoWebView:(NSString *)url andTitle:(NSString *)title At:(UIViewController *)vc{
    
    WebViewController *web = [[WebViewController alloc] init];
    web.titleName = title;
    web.url = url;
    [vc.navigationController pushViewController:web animated:NO];
}
+ (void)gotoWebView:(NSString *)url andTitle:(NSString *)title andImg:(UIImage *)img At:(UIViewController *)vc{
    WebViewController *web = [[WebViewController alloc] init];
    web.titleName = title;
    web.url = url;
    web.img = img;
    [vc.navigationController pushViewController:web animated:NO];
}




+(void)saveLocalFavouriteTitle:(NSString *)title andUrl:(NSString *)url{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"collection"];
    if (!dic) {
        dic = @{title:url};
    }else{
        NSMutableDictionary *mDict = [dic mutableCopy];
        [mDict setObject:url forKey:title];
        dic = mDict;
    }
    [defaults setObject:dic forKey:@"collection"];
    [defaults synchronize];
    
}

+(NSDictionary *)readLocalFavourite{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defaults objectForKey:@"collection"];
    return dict;
}

+ (void)delectLocalFavouriteByTitle:(NSString *)title{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"collection"];
    if (dic) {
        NSMutableDictionary *mDict = [dic mutableCopy];
        [mDict removeObjectForKey:title];
        dic = mDict;
    }
    [defaults setObject:dic forKey:@"collection"];
    [defaults synchronize];
    
}

+ (CGFloat)folderSizeAtPath:(NSString *)folderPath

{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) {
        
        return 0;
        
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName = nil;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        
    }
    return folderSize/(1024.0*1024.0);
    
}

+ (BOOL)isExistInFavourite:(NSString *)title{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"collection"];
    if (dic) {
        if ([dic objectForKey:title]) {
            return YES;
        }
    }
    return NO;
}

+(NSString *)readUrlByTitle:(NSString *)title{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"collection"];
    if(dic){
        return dic[title];
    }
    return nil;
}
@end
