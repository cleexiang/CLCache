//
//  CLViewController.m
//  CLCacheService
//
//  Created by lixiang on 14-1-22.
//  Copyright (c) 2014年 lixiang. All rights reserved.
//

#import "CLViewController.h"
#import "RXMLElement.h"
#import "CLCache.h"
#import "CLCachePolicy.h"

@interface CLViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *_tableView;
    BOOL        _useCache;
}

@property (nonatomic, strong) NSMutableArray   *items;
@property (nonatomic, strong) CLCache *cache;

@end

@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    NSArray *items = @[@"not use cache", @"use cache"];
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:items];
    control.tintColor = [UIColor blueColor];
    control.selectedSegmentIndex = 0;
    control.frame = CGRectMake(20, 20, 220, 30);
    [control addTarget:self action:@selector(action:)
      forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:control];

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [self sendRequest];
    
    [self.view bringSubviewToFront:self.activityIndicator];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)action:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _useCache = NO;
    } else {
        _useCache = YES;
    }
}

- (IBAction)refresh:(id)sender {
    if (self.items.count > 0) {
        [self.items removeAllObjects];
    }
    [self.activityIndicator startAnimating];
    [self sendRequest];
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (CLCache *)cache {
    if (!_cache) {
        CLCachePolicy *policy = [CLCachePolicy defaultCachePolicy];
        policy.level = CLCachePolicyMemory;
        _cache = [CLCache cacheWithPolicy:policy];
    }
    return _cache;
}

- (void)sendRequest {
    NSString *url = @"http://www.meituan.com/api/v1/divisions";
    NSData *data = nil;
    if (_useCache) {
        data = [self.cache dataForKey:url];
    }
    if (data == nil) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.cache setData:data forKey:url];
        });
    }
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    RXMLElement *root = [RXMLElement elementFromXMLData:data];
    [root iterate:@"divisions.division" usingBlock:^(RXMLElement *element) {
        NSString *name = [element child:@"name"].text;
        [self.items addObject:name];
    }];
    [_tableView reloadData];
    [self.activityIndicator stopAnimating];

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
