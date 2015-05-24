#import <UIKit/UIKit.h>
#import "Client.h"
#import <UIKit/UIKit.h>

@interface RecognitionViewController : UIViewController<ClientDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *statusIndicator;
@property (strong, nonatomic) IBOutlet UITextView *summary;

@end
