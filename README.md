# FABoLLSlidableTabBar

You can make tab bar which scrolls to horizontal direction.

This tabbar button is made rounded button like Google Maps.

If your tabs is over than a screen width, this UI shows always a interruption of some button as a clip tip.


| Before scroll | After scroll |
|:---:|:---:|
| ![Before scroll](https://github.com/MTattin/FABoLLSlidableTabBar/blob/master/Images/first.png) | ![After scroll](https://github.com/MTattin/FABoLLSlidableTabBar/blob/master/Images/end.png) |


# License
MIT


# Dependency

- iOS, >=11
- Xcode, >= 11


# Usage

```
///
/// Tab bar data
///
private var _settingsData: [FABoLLSlidableTabBarCellData] = [
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
///
/// Set tab bar size
///
var height: CGFloat = min(round(base * 0.1), 44.0)
height = max(height, 32.0)
let tabBarSize: CGSize = CGSize.init(
    width: UIScreen.main.bounds.width,
    height: height
)
///
/// Create FABoLLSlidableTabBar
///
let tabBar: FABoLLSlidableTabBar = FABoLLSlidableTabBar.init(
    size: tabBarSize,
    settings: FABoLLSlidableTabBarSettings.init(
        data: self._settingsData
    ),
    selected: { [weak self] (row: Int) in
        let title: String = self._settingsData[row].title ?? "error"
        print(title)
    }
)
```

Full parameters:

```
let tabBar: FABoLLSlidableTabBar = FABoLLSlidableTabBar.init(
    size: tabBarSize,
    settings: FABoLLSlidableTabBarSettings.init(
        data: self._settingsData
        iconSize: CGSize.init(width: 20, height: 20),
        normalDecoration: (
            titleFont: UIFont.init(name: "HelveticaNeue-Light", size: 13)!,
            titleColor: UIColor.darkGray,
            fillColor:  UIColor.white.alpha(0.8),
            borderColor: UIColor.gray,
            borderWidth: 1.0
        ),
        selectedDecoration: (
            titleFont: UIFont.init(name: "HelveticaNeue-Bold", size: 13)!,
            titleColor: UIColor.white,
            fillColor: UIColor.blue.alpha(0.8),
            borderColor: UIColor.blue,
            borderWidth: 1.0
        )
    ),
    selected: { [weak self] (row: Int) in
        let title: String = self._settingsData[row].title ?? "error"
        print(title)
    }
)
```
