#Design Considerations and Walkthrough

I used an MVVM architecture in order to separate the formatting concern rather than placing all the business logic into the view controller making the MVC a massive view controller. I used NSFileManager to save the data. Instead of saving the data into a text file, the NSData is written into file because it is readily available and extra processing without a clear purpose of saving into text file is not necessary.

The models are preferably created as structures with value type semantics. However the MasterList model needed to be an NSObject because I used KVO to bind asynchronous changes from the view model to the view controller. An alternative to KVO is NSNotification, however this has global scope and breaks local reasoning. If allowed, I would have used RxSwift to observe state changes since it's more elegant and easier to use.

I used local notification to schedule expiration. NSTime, GCD and NSOperationQueue will canccel expiration if app is manually killed. This way with local notification, the user is prompted even when the app is not running.

Model views should not import UIKit. However MastersViewModel need to schedule local notifications is implemented from UIKit. To solve this problem, use delegation pattern to delegate this responsibility to the owning view controller. The view model however controls all the parameter supplied to the notification.

NSNotification is used to to inform the model view from the AppDelegate callback on the arrival of the local notification payload. Maybe there's a more elegant solution than this. I tried to parse the navigation controller tree to get a reference of the view model from the AppDelegate but it looked very hacky and ugly! NSNotification has the global scope needed to solve this problem.

I used NSRLSession with an Alamofire inspired Router making URL composition more flexible and easier to maintain. I also used NSJSONSerialization to transform the data into dictionary and eventually parsing into first class Swift models (structs or classes). I used NSNumberFormatter with the given currency code to format the jackpot. On the other hand I used NSDateFormatter to localise the formatted date. All formatting are done in the view model layer. I used XCTestExpectation to asynchronously test the fetch data from the URL.
