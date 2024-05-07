# FABoLLSlidableTabBar

[![FABoLL](https://custom-icon-badges.herokuapp.com/badge/license-FABoLL-8BB80A.svg?logo=law&logoColor=white)]()　[![iOS 16.0](https://custom-icon-badges.herokuapp.com/badge/iOS-16.0-007bff.svg?logo=apple&logoColor=white)]()　[![Xcode 15.3](https://custom-icon-badges.herokuapp.com/badge/Xcode-15.3-007bff.svg?logo=Xcode&logoColor=white)]()　[![Swift 5.9](https://custom-icon-badges.herokuapp.com/badge/Swift-5.9-df5c43.svg?logo=Swift&logoColor=white)]()

You can make tab bar which scrolls to horizontal direction.

This tabbar button is made rounded button like Google Maps.

If your tabs is over than a screen width, this UI shows always a interruption of some button as a clip tip.


| Before scroll | After scroll |
|:---:|:---:|
| ![Before scroll](https://github.com/MTattin/FABoLLSlidableTabBar/blob/master/Images/first.png) | ![After scroll](https://github.com/MTattin/FABoLLSlidableTabBar/blob/master/Images/end.png) |

# Usage

```
// Tab bar data
private var settingsData: [FABoLLSlidableTabBarCellData] = [
    (
        title: "コンビニ",
        icon: nil,
        selected: nil
    ),
    (
        title: "レストラン",
        icon: nil,
        selected: nil
    ),
    (
        title: "駅",
        icon: nil,
        selected: nil
    ),
    (
        title: "ファーストフード",
        icon: nil,
        selected: nil
    ),
    (
        title: "駐車場",
        icon: nil,
        selected: nil
    ),
    (
        title: "病院",
        icon: nil,
        selected: nil
    ),
    (
        title: "銀行",
        icon: nil,
        selected: nil
    ),
]
```

```
// Set tab bar size
var height: CGFloat = min(round(base * 0.1), 44)
height = max(height, 32)
let tabBarSize = CGSize(width: UIScreen.main.bounds.width, height: height)

// Create FABoLLSlidableTabBar
let tabBar = FABoLLSlidableTabBar(
    size: tabBarSize,
    settings: FABoLLSlidableTabBarSettings(
        data: settingsData
    ),
    selected: { row in
        print(row)
    }
)
```

Full parameters:

```
let tabBar = FABoLLSlidableTabBar(
    size: tabBarSize,
    settings: FABoLLSlidableTabBarSettings(
        data: settingsData
        iconSize: CGSize(width: 20, height: 20),
        normalDecoration: (
            titleFont: UIFont(name: "HelveticaNeue-Light", size: 13)!,
            titleColor: UIColor.darkGray,
            fillColor:  UIColor.white.alpha(0.8),
            borderColor: UIColor.gray,
            borderWidth: 1
        ),
        selectedDecoration: (
            titleFont: UIFont(name: "HelveticaNeue-Bold", size: 13)!,
            titleColor: UIColor.white,
            fillColor: UIColor.blue.alpha(0.8),
            borderColor: UIColor.blue,
            borderWidth: 1
        )
    ),
    selected: { row in
        print(row)
    }
)
```

If you want to change a size when device rotated:

```
override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
        // set new size
        tabBar.updateSize(newSize)
        // If you want to scroll selected cell to tab bar center:
        //tabBar.updateSize(newSize, isScrollSelectedCellToCenter: true)
    }) { _ in }
}
```
