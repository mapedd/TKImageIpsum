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

@property (nonatomic, copy) NSString *category;

@end

@implementation TKViewController

#pragma mark - UIViewController

- (id)init{
    self = [super initWithNibName:nil bundle:nil];
    if(!self)return nil;
    
    _category = @"people";
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 44.0f) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 120;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, self.view.bounds.size.height - 44.0f, self.view.bounds.size.width, 44.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:toolBar];
    
    UIBarButtonItem *people = [[UIBarButtonItem alloc] initWithTitle:@"people" style:UIBarButtonItemStyleBordered target:self action:@selector(tap:)];
    UIBarButtonItem *food = [[UIBarButtonItem alloc] initWithTitle:@"food" style:UIBarButtonItemStyleBordered target:self action:@selector(tap:)];
    UIBarButtonItem *nature = [[UIBarButtonItem alloc] initWithTitle:@"nature" style:UIBarButtonItemStyleBordered target:self action:@selector(tap:)];
    UIBarButtonItem *sports = [[UIBarButtonItem alloc] initWithTitle:@"sports" style:UIBarButtonItemStyleBordered target:self action:@selector(tap:)];
    UIBarButtonItem *cats = [[UIBarButtonItem alloc] initWithTitle:@"cats" style:UIBarButtonItemStyleBordered target:self action:@selector(tap:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[space, people, food, nature, sports, cats, space]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    if (indexPath) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tap:(UIBarButtonItem *)item{
    NSLog(@"item : %@", item.title);
    self.category = item.title;
}

- (void)setCategory:(NSString *)category{
    if(_category != category){
        _category = [category copy];
        self.title = [NSString stringWithFormat:@"TKImageIpsum:%@", _category];
        [TKImageIpsum clearCaches];
        [_tableView reloadData];
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
    
    [TKImageIpsum getRandomImageWithSize:size\
                               urlFormat:[NSString stringWithFormat:@"%@/%@",@"http://lorempixel.com/%d/%d/", self.category]
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
