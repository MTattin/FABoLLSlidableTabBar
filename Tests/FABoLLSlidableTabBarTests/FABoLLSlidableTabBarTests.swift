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
        ("testSimpleSetup", testSimpleSetup),
        ("testOptionSetup", testOptionSetup),
        ("testChangeSize", testChangeSize)
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
    private let _tabBarArea: UIView = UIView.init(
        frame: CGRect.init(
            origin: CGPoint.init(x: 0.0, y: 100.0),
            size: CGSize.init(
                width: UIScreen.main.bounds.width,
                height: 32.0
            )
        )
    )
    private let _selectedIndexPath: IndexPath = IndexPath.init(row: 2, section: 0)
    private let _normalDecoration: FABoLLSlidableTabBarCellDecoration = (
        titleFont: UIFont.init(name: "HelveticaNeue-Light", size: 13)!,
        titleColor: UIColor.darkGray,
        fillColor:  UIColor.white.withAlphaComponent(0.8),
        borderColor: UIColor.gray,
        borderWidth: 1.0
    )
    private let _selectedDecoration: FABoLLSlidableTabBarCellDecoration = (
        titleFont: UIFont.init(name: "HelveticaNeue-Bold", size: 13)!,
        titleColor: UIColor.white,
        fillColor: UIColor.red.withAlphaComponent(0.8),
        borderColor: UIColor.red,
        borderWidth: 1.0
    )
    private var _tabBar: FABoLLSlidableTabBar!
    private var _collection: UICollectionView? {
        for view in self._tabBar.subviews {
            if let collectionView: UICollectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }
    private var _selectedCell: FABoLLSlidableTabBarCell? {
        return self._collection?.cellForItem(at: self._selectedIndexPath) as? FABoLLSlidableTabBarCell
    }
    private var _selectedCellTitle: UILabel? {
        guard let subviews: [UIView] = self._selectedCell?.contentView.subviews else {
            return nil
        }
        for view in subviews {
            if let label: UILabel = view as? UILabel {
                return label
            }
        }
        return nil
    }
    ///
    // MARK: -------------------- tests
    ///
    ///
    ///
    override func setUp() {
        super.setUp()
        self._base.addSubview(self._tabBarArea)
    }
    ///
    ///
    ///
    func testSimpleSetup() {
        self._tabBar = FABoLLSlidableTabBar.init(
            size: self._tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings.init(
                data: Self._SettingsTestData
            ),
            selected: nil
        )
        self._tabBarArea.addSubview(self._tabBar)
        guard let collection: UICollectionView = self._collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: self._selectedIndexPath)
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
    }
    ///
    /// Options and select action
    ///
    func testOptionSetup() {
        let selectedExpectation: XCTestExpectation = self.expectation(description: "SelectCell")
        var selectedRow: Int?
        self._tabBar = FABoLLSlidableTabBar.init(
            size: self._tabBarArea.frame.size,
            initRow: 1,
            clipTipWidth: 20.0,
            settings: FABoLLSlidableTabBarSettings.init(
                data: Self._SettingsTestData,
                clipTipWidth: 20.0,
                iconSize: CGSize.init(width: 20, height: 20),
                normalDecoration: self._normalDecoration,
                selectedDecoration: self._selectedDecoration
            ),
            selected: { (callbackSelectedRow: Int) in
                if callbackSelectedRow == self._selectedIndexPath.row {
                    selectedRow = callbackSelectedRow
                    selectedExpectation.fulfill()
                }
            }
        )
        self._tabBarArea.addSubview(self._tabBar)
        guard let collection: UICollectionView = self._collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: IndexPath.init(row: 0, section: 0))
        ///
        ///
        ///
        guard let unSelectedCell: FABoLLSlidableTabBarCell = self._selectedCell else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(unSelectedCell.contentView.backgroundColor, self._normalDecoration.fillColor)
        XCTAssertEqual(unSelectedCell.contentView.layer.borderWidth, self._normalDecoration.borderWidth)
        XCTAssertEqual(unSelectedCell.contentView.layer.borderColor, self._normalDecoration.borderColor.cgColor)
        guard let unSelectedCellTitle: UILabel = self._selectedCellTitle else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(unSelectedCellTitle.font, self._normalDecoration.titleFont)
        XCTAssertEqual(unSelectedCellTitle.textColor, self._normalDecoration.titleColor)
        XCTAssertEqual(unSelectedCellTitle.text, Self._SettingsTestData[self._selectedIndexPath.row].title)
        ///
        /// Selected
        ///
        collection.delegate?.collectionView?(collection, didSelectItemAt: self._selectedIndexPath)
        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(selectedRow, self._selectedIndexPath.row)
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
        ///
        ///
        ///
        guard let selectedCell: FABoLLSlidableTabBarCell = self._selectedCell else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCell.contentView.backgroundColor, self._selectedDecoration.fillColor)
        XCTAssertEqual(selectedCell.contentView.layer.borderWidth, self._selectedDecoration.borderWidth)
        XCTAssertEqual(selectedCell.contentView.layer.borderColor, self._selectedDecoration.borderColor.cgColor)
        guard let selectedCellTitle: UILabel = self._selectedCellTitle else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCellTitle.font, self._selectedDecoration.titleFont)
        XCTAssertEqual(selectedCellTitle.textColor, self._selectedDecoration.titleColor)
        XCTAssertEqual(selectedCellTitle.text, Self._SettingsTestData[self._selectedIndexPath.row].title)
    }
    ///
    /// Change size
    ///
    func testChangeSize() {
        self._tabBar = FABoLLSlidableTabBar.init(
            size: self._tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings.init(
                data: Self._SettingsTestData
            ),
            selected: nil
        )
        self._tabBarArea.addSubview(self._tabBar)
        guard let collection: UICollectionView = self._collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: self._selectedIndexPath)
        XCTAssertEqual(self._tabBar.frame.size, self._tabBarArea.frame.size)
        guard let beforeSelectedCell: FABoLLSlidableTabBarCell = self._selectedCell else {
            XCTAssert(false)
            return
        }
        guard let beforeSelectedCellTitle: UILabel = self._selectedCellTitle else {
            XCTAssert(false)
            return
        }
        ///
        ///
        ///
        let newSize: CGSize = CGSize.init(
            width: self._tabBarArea.frame.size.width * 0.5,
            height: self._tabBarArea.frame.size.height * 0.5
        )
        self._tabBar.updateSize(newSize)
        XCTAssertEqual(self._tabBar.frame.size, newSize)
        guard let afterSelectedCell: FABoLLSlidableTabBarCell = self._selectedCell else {
            XCTAssert(false)
            return
        }
        guard let afterSelectedCellTitle: UILabel = self._selectedCellTitle else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(beforeSelectedCell.frame, afterSelectedCell.frame)
        XCTAssertEqual(beforeSelectedCellTitle.frame, afterSelectedCellTitle.frame)
        XCTAssertEqual(beforeSelectedCell.contentView.backgroundColor, afterSelectedCell.contentView.backgroundColor)
        XCTAssertEqual(beforeSelectedCell.contentView.layer.borderWidth, afterSelectedCell.contentView.layer.borderWidth)
        XCTAssertEqual(beforeSelectedCell.contentView.layer.borderColor, afterSelectedCell.contentView.layer.borderColor)
        XCTAssertEqual(beforeSelectedCellTitle.font, afterSelectedCellTitle.font)
        XCTAssertEqual(beforeSelectedCellTitle.textColor, afterSelectedCellTitle.textColor)
        XCTAssertEqual(beforeSelectedCellTitle.text, afterSelectedCellTitle.text)
    }
}
