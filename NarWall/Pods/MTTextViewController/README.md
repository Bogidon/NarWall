# MTTextViewController

A simple delegate-based controller for presenting editable text on iOS.

## Usage

In your presenting view controller, do:

```objc

- (IBAction)editNote {
  MTTextViewController *textViewController = [[MTTextViewController alloc] initWithText:self.noteText];
  textViewController.title = @"Edit Note";
  textViewController.delegate = self;
  // You can also push it on a navigation controller if you'd like
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:textViewController] animated:YES completion:nil];
}

- (void)textViewControllerDidFinish:(MTTextViewController *)controller {
  self.noteText = controller.text;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewControllerDidCancel:(MTTextViewController *)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

```

## Requirements

iOS 7 or greater.

## Installation

MTTextViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MTTextViewController"

## Author

Mat Trudel, mat@geeky.net

## License

MTTextViewController is available under the MIT license. See the LICENSE file for more info.

