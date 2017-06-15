### AC3.2-UICollectionView
---

### Objective

To learn how to build and populate a ```UICollectionView```with dynamically sized items while understanding how flows influence the layout of a collection.

### Readings

1. [Getting Started With UICollectionView - Ray Wenderlich Tutorial](https://www.raywenderlich.com/136159/uicollectionview-tutorial-getting-started)
2. [`UICollectionView` - Apple](https://developer.apple.com/reference/uikit/uicollectionview)
3. [`UICollectionViewLayout` - Apple](https://developer.apple.com/reference/uikit/uicollectionviewlayout)
4. [`UICollectionViewDelegateFlowLayout` - Apple](https://developer.apple.com/reference/uikit/uicollectionviewdelegateflowlayout)
---

### 1. Table View vs. Collection View

Collection views are very much like table views. The main difference is that 
collection views are far more flexible in how they can lay out their content.
While it's highly customizable via an overrideable class ```UICollectionViewLayout```,
the default ```Flow``` layout is very powerful without any subclassing. The
protocol ```UICollectionViewDelegateFlowLayout``` defines methods with which the developer 
can specify the size and spacing items.


### 2. DataSource Delegate

UICollectionView's data source delegate is very much like UITableView's. The key methods
are exactly the same, but for some rewording.


```swift
override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}

override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataArray.count
}

override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    .
    .
    .
    }

    return cell
}
```

### 3. UIEdgeInsets

UIEdgeInsets are like margins. They can be applied to any UIView but are often
found  on ```UIScrollView``` and its subclasses.
In this project we'll use this struct directly and also use its properties directly for setting
other related dimensions. 

### 4. Search

We're going to embed a ```UITextField``` 
in the [Navigation Item](https://developer.apple.com/reference/uikit/uinavigationitem) of the Navigation Bar
to allow the user to change the search term. The navigation item is an object the view controller 
uses to configure the navigation bar. 

1. Drag a Text Field into the navigation bar of the collection view controller.
2. Control drag from the Text Field to the View Controller to set the delegate property of the Text Field.
3. Declare the collection view controller as adopting the ```UITextFieldDelegate``` protocol.
4. Implement ```textFieldShouldReturn(_:)```

    ```swift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(textField.text!)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    ```
---

### 5. Full Implementation 

Here's a full implementation of the ```UICollectionViewController``` subclass.  Take a look at the solution branch for the complete project.

```swift
import UIKit

fileprivate let reuseIdentifier = "AlbumCell"
fileprivate let itemsPerRow: CGFloat = 3
fileprivate let apiKey = "1ce6fda8a223aa4b7fa0cafe4dc3d3d0"
fileprivate let apiURLRoot = "http://ws.audioscrobbler.com/2.0/"

class AlbumCollectionViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchAlbumTextField: UITextField!
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var albums: [Album] = []
    let searchTerm = "blue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "No Search Yet"
        searchAlbumTextField.delegate = self
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let acvc = cell as? AlbumCollectionViewCell {
            let album = self.albums[indexPath.row]
            acvc.titleLabel.text = "\(indexPath.row + 1). \(album.name)"
            
            if album.images.count > 1 {
                APIRequestManager.manager.getData(endPoint: album.images[1].url.absoluteString) { (data: Data?) in
                    if let validData = data,
                        let image = UIImage(data: validData) {
                        DispatchQueue.main.async {
                            acvc.imageView.image = image
                            acvc.setNeedsLayout()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(textField.text!)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Utility
    func search(_ term: String) {
        self.title = term
        let escapedString = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        APIRequestManager.manager.getData(endPoint: "\(apiURLRoot)?method=album.search&album=\(escapedString!)&api_key=\(apiKey)&format=json") { (data: Data?) in
            if  let validData = data,
                let validAlbums = Album.albums(from: validData) {
                self.albums = validAlbums
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // margin around the whole section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // spacing between rows if vertical / columns if horizontal
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
```
---

### 5. Exercise

#### New York Times Movie Reviews

Build an app that displays New York Times movie review by critic.

##### Wireframe
```
*********************************
* ..***..                       * ---\
* .*****.    A. O. Scott        *    | -- Table View on top with list*  of critics.
* ..***..                       *    |     Show thumbnail image if it exists.
* *******                       *    |     Use a custom tableview cell.
*-------------------------------*    |
* ..***..                       *    |
* .*****.    Manohla Dargis     *    |
* ..***..                       *    |
* *******                       *    |
*-------------------------------*    |
* ..***..                       *    |
* .*****.    Stephen Holden     *    |
* ..***..                       *    |
* *******                       *    |
*-------------------------------*    |
* ..***..                       *    |
* .*****.    Renata Adler       *    |
*-------------------------------* ---
*                               *    |    Collection View on bottom
*  **********   **********   ** *    | -- with reviews by selected
*  ***.. **.*   ***.. *. .   *  *    |    critic from table. All
*  **** . .**   **** ..*.*   *  *    |    should have images. Selecting
*  **..******   **..******   *  *    |    an image opens a full review page
*  **********   **********   ** *    |    via a segue to a new view controller.
*                               *    |
********************************* ---/
```

##### Steps
1. Register for an API key for the Movie Reviews API at the New York Times, http://developer.nytimes.com/.
    Don't worry about the website field. I entered "none" and received a key by email < 10s later.

2. Read the API as described on http://developer.nytimes.com/movie_reviews_v2.json.

3. Use the API to build a list of reviewers in the table view at top. 

4. When the user selects a row for the critic, send a new API request to fetch the reviews only by
   that critic.

5. In the Storyboard, you will have to choose a generic View Controller (not a Table View Controller
or a Collection View Controller). You will then drag a Table View and a Collection View into the
view controller and hook up their outlets and delegates.

6. Your view controller will have to conform to all the necessary delegate protocols.
