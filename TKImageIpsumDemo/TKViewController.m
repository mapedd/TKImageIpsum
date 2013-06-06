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

@interface TKViewController ()

@end

@implementation TKViewController

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if(!self)return nil;
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
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
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row + 1];
    
    [TKImageIpsum getRandomImageWithSize:CGSizeMake(tableView.rowHeight, tableView.rowHeight)
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
    vc.title = [indexPath description];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
