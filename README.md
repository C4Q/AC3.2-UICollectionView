### AC3.2-UICollectionView
---

### Objective

To learn how to build and populate a ```UICollectionView```with dynamically sized items while understanding how flows work.

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
protocol ```UICollectionViewDelegateFlowLayout```.


### 2. DataSource Delegate

UICollectionView's data source delegate is very much like UITableView's. The key methods
are exactly the same, but for some rewording.


```swift
override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}
```
---

### 3. Exercise

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
