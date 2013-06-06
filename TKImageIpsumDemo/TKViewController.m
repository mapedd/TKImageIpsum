//
//  TKViewController.m
//  TKImageIpsumDemo
//
//  Created by Tomasz Kuźma on 6/6/13.
//  Copyright (c) 2013 mapedd. All rights reserved.
//

#import "TKViewController.h"
#import "TKTableViewCell.h"
#import "TKImageIpsum.h"

@interface TKViewController (){
    UITableView *_tableView;
}

@end

@implementation TKViewController

#pragma mark - UIViewController

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if(!self)return nil;
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    
    TKTableViewCell *cell = (TKTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TKTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d,%d",indexPath.section + 1, indexPath.row + 1];
    
    CGSize size = CGSizeMake(tableView.rowHeight, tableView.rowHeight);
    
    if ([[UIScreen mainScreen] scale]>1.0f) {
        size.height = size.width *= 2.0f;
    }
    
    [TKImageIpsum getRandomImageWithSize:size
                                   group:self.title
                                     key:indexPath
                     withCompletionBlock:^(UIImage *image) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([[tableView indexPathForCell:cell] isEqual:indexPath]) {
                                 cell.imageView.image = image;
                                 [cell setNeedsLayout];
                             }
                         });
                     }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKViewController *vc = [[TKViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"Screen %d,%d", indexPath.row, indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [TKImageIpsum clearCaches];
}

@end
