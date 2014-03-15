//
//  ViewController.m
//  PostData
//
//  Created by Akshat Singhal on 13/03/14.
//  Copyright (c) 2014 info. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak) id currentField;
@property (strong) NSString *currentText;
@property (weak, nonatomic) IBOutlet UITextView *textBox;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@end

@implementation ViewController

- (void)viewDidLoad
{
    networkAdapter  =   [[NetworkAdapter alloc] init];
    networkAdapter.delegate =   self;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postData:(id)sender {
    [networkAdapter postData:[NSDictionary dictionaryWithObjectsAndKeys:
                             _textBox.text,@"text",
                             _emailField.text,@"email",
                             _dateField.text,@"date",
                             nil]];
    UIActivityIndicatorView *activityIndicator  =   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame =   self.view.frame;
    activityIndicator.tag   =   2;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
//    NSLog(@"PRINT %@ %@ %@",_textBox.text,_emailField.text,_dateField.text);
}

- (IBAction)dateDidBeginEditing:(id)sender {
    _currentField   =   sender;
    UITextField *dateField  =   (UITextField *)sender;
    _currentText    =   dateField.text;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init] ;
    if ([_currentText isEqualToString:@""])
        datePicker.date =   [NSDate date];
    else{
        NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle    =   NSDateFormatterLongStyle;
        datePicker.date =   [dateFormatter dateFromString:_currentText];
    }
    
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    dateField.inputView = datePicker;
}

- (IBAction)emailDidBeginEditing:(id)sender {
    UITextField *email  =   (UITextField *)sender;
    _currentText    =   email.text;
    _currentField   =   sender;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    _currentField   =   textView;
    [self addEditingButtons];
    _currentText    =   textView.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self removeEditingButtons];
    [self addRemovePlaceHolderForTextBox:textView];
}

- (void)textViewDidChange:(UITextView *)textView{
    [self addRemovePlaceHolderForTextBox:textView];
}

- (void)addRemovePlaceHolderForTextBox:(UITextView *)textView {
    if ([textView.text isEqualToString:@""])
        [[self.view viewWithTag:1] setAlpha:1];
    else
        [[self.view viewWithTag:1] setAlpha:0];
}

- (void)dateSelected:(id)sender {
    NSDateFormatter *dateFormat =   [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterLongStyle];
    UIDatePicker    *datePicker =   (UIDatePicker *)sender;
    UITextField     *dateField  =   (UITextField *)_currentField;
    dateField.text =   [dateFormat stringFromDate:datePicker.date];
}


- (void)editingCancelled {
    if ([_currentField respondsToSelector:@selector(setText:)])
        [_currentField performSelector:@selector(setText:) withObject:_currentText];
    [self removeEditingButtons];
}

- (IBAction)addEditingButtons {
    self.navigationItem.rightBarButtonItem  =   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(removeEditingButtons)];
    self.navigationItem.leftBarButtonItem   =   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editingCancelled)];
}

- (IBAction)removeEditingButtons{
    self.navigationItem.rightBarButtonItem  =   nil;
    self.navigationItem.leftBarButtonItem   =   nil;
    if ([_currentField respondsToSelector:@selector(resignFirstResponder)])
        [_currentField performSelector:@selector(resignFirstResponder)];
}

- (void)networkAdapterDelegateDidFinish:(NSDictionary *)response {
    [[self.view viewWithTag:2] removeFromSuperview];
    [[[UIAlertView alloc] initWithTitle:response[@"status"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show ];
}

@end
