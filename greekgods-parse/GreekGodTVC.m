//
//  GreekGodTVC.m
//  greekgods-parse
//
//  Created by Ashley Ng on 6/6/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "GreekGodTVC.h"
#import "Parse/Parse.h"
#import "DetailVC.h"

@interface GreekGodTVC ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation GreekGodTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFQuery queryWithClassName:@"GreekGod"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.data = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"God Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.data[indexPath.row] valueForKey:@"name"];
    
    return cell;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // get index of selected row
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Detail View"]) {
            if ([segue.destinationViewController isKindOfClass:[DetailVC class]]) {
                DetailVC *gvc = segue.destinationViewController;
//                NSString *key = [self.data valueForKey:@"objectId"];
//                gvc.godData = self.data[indexPath.row];
                gvc.name = [self.data[indexPath.row] valueForKey:@"name"];
//                NSLog(@"%@", gvc.godData);
                PFObject *object = self.data[indexPath.row];
                gvc.key = [object objectId];
            }
        }
    }
}

- (IBAction)toTableVC:(UIStoryboardSegue *)sender
{
    
}

@end
