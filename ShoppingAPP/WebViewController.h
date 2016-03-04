
#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)UIImage *img;
-(void)request;
@end

