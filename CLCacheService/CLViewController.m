//
//  CLViewController.m
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLViewController.h"

@interface CLViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray   *items;

@end

@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *items = @[@"cache", @"no cache"];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
    control.frame = CGRectMake(100, 20, 100, 30);
    [control addTarget:self action:@selector(action:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    [self sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)action:(id)sender {
    
}

- (void)sendRequest {
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithHTTPGetRequest:[NSURL URLWithString:@"http://www.meituan.com/api/v1/divisions"]
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          
                      }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

@end
