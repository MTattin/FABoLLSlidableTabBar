import XCTest
@testable import FABoLLSlidableTabBar
///
/// - Tag: FABoLLSlidableTabBarTests
///
final class FABoLLSlidableTabBarTests: XCTestCase {
    ///
    // MARK: -------------------- static properties
    ///
    ///
    ///
    static var allTests = [
        ("testSetup", testSetup),
    ]
    ///
    ///
    ///
    private static let _SettingsTestData: [FABoLLSlidableTabBarCellData] = [
        (
            title: "アイウエ",
            icon: nil,
            selected: nil
        ),
        (
            title: "アイウAA",
            icon: nil,
            selected: nil
        ),
        (
            title: "かきくけこ",
            icon: nil,
            selected: nil
        ),
        (
            title: "かきくけこAA",
            icon: nil,
            selected: nil
        ),
        (
            title: "さしすせそ",
            icon: nil,
            selected: nil
        ),
    ]
    ///
    // MARK: -------------------- properties
    ///
    ///
    ///
    private let _base: UIView = UIView.init(frame: UIScreen.main.bounds)
    private var _tabBar1: FABoLLSlidableTabBar!
    private let _tabBarArea1: UIView = UIView.init(
        frame: CGRect.init(
            origin: CGPoint.init(x: 0.0, y: 50.0),
            size: CGSize.init(
                width: UIScreen.main.bounds.width,
                height: 32.0
            )
        )
    )
    private var _tabBar2: FABoLLSlidableTabBar!
    private let _tabBarArea2: UIView = UIView.init(
        frame: CGRect.init(
            origin: CGPoint.init(x: 0.0, y: 150.0),
            size: CGSize.init(
                width: UIScreen.main.bounds.width,
                height: 32.0
            )
        )
    )
    ///
    // MARK: -------------------- tests
    ///
    ///
    ///
    override func setUp() {
        super.setUp()
        self._base.addSubview(self._tabBarArea1)
        self._base.addSubview(self._tabBarArea2)
    }
    ///
    ///
    ///
    func testSetup() {
        ///
        /// No option
        ///
        self._tabBar1 = FABoLLSlidableTabBar.init(
            size: self._tabBarArea1.frame.size,
            settings: FABoLLSlidableTabBarSettings.init(
                data: Self._SettingsTestData
            ),
            selected: nil
        )
        self._tabBarArea1.addSubview(self._tabBar1)
        XCTAssertEqual(self._tabBar1.frame.size, self._tabBarArea1.frame.size)
        XCTAssertNotNil(self._tabBar1.subviews
            .filter { (view: UIView) -> Bool in
                view is UICollectionView
            }
            .first
        )
        ///
        /// All options
        ///
        self._tabBar2 = FABoLLSlidableTabBar.init(
            size: self._tabBarArea2.frame.size,
            settings: FABoLLSlidableTabBarSettings.init(
                data: Self._SettingsTestData,
                clipTipWidth: 20.0,
                iconSize: CGSize.init(width: 20, height: 20),
                normalDecoration: (
                    titleFont: UIFont.init(name: "HelveticaNeue-Light", size: 13)!,
                    titleColor: UIColor.darkGray,
                    fillColor:  UIColor.white.withAlphaComponent(0.8),
                    borderColor: UIColor.gray,
                    borderWidth: 1.0
                ),
                selectedDecoration: (
                    titleFont: UIFont.init(name: "HelveticaNeue-Bold", size: 13)!,
                    titleColor: UIColor.white,
                    fillColor: UIColor.red.withAlphaComponent(0.8),
                    borderColor: UIColor.red,
                    borderWidth: 1.0
                )

            ),
            selected: nil
        )
        self._tabBarArea2.addSubview(self._tabBar2)
        XCTAssertEqual(self._tabBar2.frame.size, self._tabBarArea2.frame.size)
        XCTAssertNotNil(self._tabBar2.subviews
            .filter { (view: UIView) -> Bool in
                view is UICollectionView
            }
            .first
        )
    }
}
