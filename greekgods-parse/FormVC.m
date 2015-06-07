//
//  FormVC.m
//  greekgods-parse
//
//  Created by Ashley Ng on 6/6/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "FormVC.h"
#import "Parse/Parse.h"

@interface FormVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *romanField;
@property (strong, nonatomic) IBOutlet UITextView *repText;
@property (strong, nonatomic) IBOutlet UITextView *symbolsText;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) PFObject *parseObject; // only for edit form

@end

@implementation FormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // on edit form
    if (self.isEditForm) {
        PFQuery *query = [PFQuery queryWithClassName:@"GreekGod"];
        self.parseObject = [query getObjectWithId:self.key];
        [self editFormSetup];
    }
    else
        self.submitButton.title = @"Sumbit";
}

/*
 if editting existing entry, fill in form with entry's data.
 and change 'submit' button to a 'done' button
 */
- (void)editFormSetup
{
    self.submitButton.title = @"Done";
    self.nameField.text = [self.parseObject objectForKey:@"name"];
    self.romanField.text = [self.parseObject objectForKey:@"roman"];
    self.repText.text = [[self.parseObject objectForKey:@"reps"] componentsJoinedByString:@","];
    self.symbolsText.text = [[self.parseObject objectForKey:@"symbol"] componentsJoinedByString:@","];
    if (self.parseObject[@"imageFile"]) {
        PFFile *image = self.parseObject[@"imageFile"];
        NSData *imageData = [image getData];
        self.image.image = [UIImage imageWithData:imageData];
    }
}

/*
 tapped the submit/done button
 */
- (IBAction)submitButtonTapped:(id)sender
{
    if (self.isEditForm) {
        // if editting, update child and segue back to detail view controller
        [self submitEditForm];
        [self performSegueWithIdentifier:@"toDetailVC" sender:self];
    }
    else {
        // if submit a new entry, setValue of new entry and segue back to table view
        [self submitNewEntryForm];
        [self performSegueWithIdentifier:@"toTableVC" sender:self];
    }
}

/*
    done editing form, completes the saving
 */
- (void)submitEditForm {
    self.parseObject[@"name"] = self.nameField.text;
    self.parseObject[@"roman"] = self.romanField.text;
    self.parseObject[@"reps"] = [self formatArray:[self.symbolsText.text componentsSeparatedByString:@","]];;
    self.parseObject[@"symbols"] = [self formatArray:[self.repText.text componentsSeparatedByString:@","]];
    NSData *imageData = UIImagePNGRepresentation(self.image.image);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@-image.png", self.nameField.text] data:imageData];
    self.parseObject[@"imageFile"] = imageFile;
    [self.parseObject save];
    NSLog(@"object updated in database");
}

/*
    done added new entry. completes the saving
 */
- (void)submitNewEntryForm {
    PFObject *newObject = [PFObject objectWithClassName:@"GreekGod"];
    newObject[@"name"] = self.nameField.text;
    newObject[@"roman"] = self.romanField.text;
    newObject[@"reps"] = [self formatArray:[self.symbolsText.text componentsSeparatedByString:@","]];
    newObject[@"symbol"] = [self formatArray:[self.repText.text componentsSeparatedByString:@","]];
    if (self.image.image) {
        NSData *imageData = UIImagePNGRepresentation(self.image.image);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@-image.png", self.nameField.text] data:imageData];
        newObject[@"imageFile"] = imageFile;
    }
    [newObject save];
    NSLog(@"new object saved to database");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 get's rid of trailing and leading white spaces in an
 array entry
 */
- (NSArray *)formatArray: (NSArray *)unformatedArray {
    if ([unformatedArray count] == 0) {
        return @[];
    }
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (id value in unformatedArray) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *formatedString = [(NSString *)value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [returnArray addObject:formatedString];
        }
    }
    return returnArray;
}


# pragma mark Image Uploading

# warning need to support take image
- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.image.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Navigation


- (IBAction)goBackButton:(id)sender {
    if (self.isEditForm) {
        [self performSegueWithIdentifier:@"toDetailVC" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"toTableVC" sender:self];
    }
    
}
- (IBAction)toTableVC:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)toDetailVC:(UIStoryboardSegue *)segue
{
    
}

@end
