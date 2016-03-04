//
//  BaseTableViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/16.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TopicModel.h"
#import "TopicCell.h"
#import "UIImageView+WebCache.h"
#import "CommonUtil.h"

@interface BaseTableViewController ()
{
    NSArray *_dataArray;

}
@end

@implementation BaseTableViewController
-(instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        [self initTabView];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
       //视图出现时加载网络数据
    if(!_dataArray){
        [self loadDataBy:_tabID];
        [CommonUtil addLoadingViewOn:self.parentViewController.view];

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)setTabID:(NSNumber *)tabID{
    _tabID = tabID;
    
}
- (void)initTabView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 100)];
    [self.tableView registerClass:[TopicCell class] forCellReuseIdentifier:@"cellName"];
}

-(void)loadDataBy:(NSNumber *)tabID{
    WeakSelf(wself);
    [TopicModel arrayWithTopicModels:^(NSArray *models) {
        if (models) {
            _dataArray = models;
            [wself.tableView reloadData];
        }else{
            [wself creatAlertView:@"无更多数据,或网络错误"];
        }
        [CommonUtil removeLoadingViewOn:self.parentViewController.view];
    } bytabId:tabID];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 提示
-(void)creatAlertView:(NSString *)string{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction代表具有按钮外观及按钮动作的类型
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:action1];
    [self  presentViewController:alert animated:YES completion:nil ];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName" forIndexPath:indexPath];
    Topic *top = _dataArray[indexPath.row];
    [cell loadData:top];
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_SIZE_WIDTH/2.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Topic *topic = _dataArray[indexPath.row];
    NSString * encodingString = [topic.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:SHOPING_API_DETAIL,topic.topicContentId,encodingString];
    [CommonUtil gotoWebView:url andTitle:topic.title At:self.parentViewController];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotation;
    // cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
