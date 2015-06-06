//
//  FormVC.m
//  Greek-Gods
//
//  Created by Ashley Ng on 6/1/15.
//  Copyright (c) 2015 Ashley Ng. All rights reserved.
//

#import "FormVC.h"
#import <Firebase/Firebase.h>
#import "GreekGodDetailVC.h"
#import <Foundation/Foundation.h>
//#import "NSStrinAdditions.h"

@interface FormVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *romanField;
@property (strong, nonatomic) IBOutlet UITextView *repField;
@property (strong, nonatomic) IBOutlet UITextView *symbolField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end

@implementation FormVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // on edit form
    if (self.isEditForm)
        [self editFormSetup];
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
    self.nameField.text = [self.data valueForKey:@"name"];
    self.romanField.text = [self.data valueForKey:@"roman"];
    self.repField.text = [[self.data valueForKey:@"rep"] componentsJoinedByString:@","];
    self.symbolField.text = [[self.data valueForKey:@"symbol"] componentsJoinedByString:@","];
    if (![[self.data valueForKey:@"image"] isEqualToString:@""]) {
        self.image.image = [self decodeImage:[self.data valueForKey:@"image"]];
    }
}


/*
 done for submitting a new entry and updating an existing entry
 */
- (IBAction)submitForm:(id)sender
{
    // format symbols and representation fields
    NSArray *symbols = [self.symbolField.text componentsSeparatedByString:@","];
    NSArray *reps = [self.repField.text componentsSeparatedByString:@","];
    symbols = [self formatArray:symbols];
    reps = [self formatArray:reps];
    
    // put form field data in a dictionary
    NSDictionary *data = @{
                           @"name" : self.nameField.text,
                           @"roman" : self.romanField.text,
                           @"symbol" : symbols,
                           @"rep" : reps,
                           @"image" : [self encodeImage:self.image.image]
                           };
    
    // firebase set up and add new data
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://greek-gods.firebaseio.com/"];
    
    
    if (self.isEditForm) {
        // if editting, update child and segue back to detail view controller
# warning May not be able to handle if name changes
        Firebase *godRef = [ref childByAppendingPath:self.key];
        [godRef updateChildValues: data];
        [self performSegueWithIdentifier:@"toDetailVC" sender:self];
    }
    else {
        // if submit a new entry, setValue of new entry and segue back to table view
        Firebase *godRef = [ref childByAutoId];
        [godRef setValue: data];
        [self performSegueWithIdentifier:@"toTableVC" sender:self];
    }
}

#pragma mark encode/decode image

/*
    encode an image into a base64 string
 */
- (NSString *)encodeImage:(UIImage *)image {
    // convert UIImage to NSData
    NSData *dataImage = UIImagePNGRepresentation(image);
    
    // encode NSDate to base64 NSString
    NSString *encodedImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImage;
}

/*
    decode a string to an image
 */
- (UIImage *)decodeImage:(NSString *)encodedImage {
    //convert string to NSDate
    NSData *decodedData = [[NSData alloc]
                           initWithBase64EncodedString:encodedImage
                           options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // make image with NSdata
    UIImage *image = [UIImage imageWithData:decodedData];
    return image;
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

/*

 */
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

#pragma mark Navigation

/*
 tapped back button. Send you to the correct view depending of editing or submiting
 a new entry
 */
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
