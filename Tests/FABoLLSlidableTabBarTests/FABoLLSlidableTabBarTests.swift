import XCTest
@testable import FABoLLSlidableTabBar

final class FABoLLSlidableTabBarTests: XCTestCase {

    // MARK: - Static Properties

    static var allTests = [
        ("testSimpleSetup", testSimpleSetup),
        ("testOptionSetup", testOptionSetup),
        ("testChangeSize", testChangeSize)
    ]

    private static let SettingsTestData: [FABoLLSlidableTabBarCellData] = [
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

    // MARK: - Properties

    private let base = UIView(frame: UIScreen.main.bounds)

    private let tabBarArea = UIView(
        frame: CGRect(
            origin: CGPoint(x: 0, y: 100),
            size: CGSize(width: UIScreen.main.bounds.width, height: 32)
        )
    )

    private let selectedIndexPath = IndexPath(row: 2, section: 0)

    private let normalDecoration: FABoLLSlidableTabBarCellDecoration = (
        titleFont: UIFont.systemFont(ofSize: 13, weight: .regular),
        titleColor: .darkGray,
        fillColor:  .white.withAlphaComponent(0.8),
        borderColor: .gray,
        borderWidth: 1
    )

    private let selectedDecoration: FABoLLSlidableTabBarCellDecoration = (
        titleFont: UIFont.systemFont(ofSize: 13, weight: .bold),
        titleColor: .white,
        fillColor: .red.withAlphaComponent(0.8),
        borderColor: .red,
        borderWidth: 1
    )

    private var tabBar: FABoLLSlidableTabBar!

    private var collection: UICollectionView? {
        for view in tabBar.subviews {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }

    private var selectedCell: FABoLLSlidableTabBarCell? {
        collection?.cellForItem(at: selectedIndexPath) as? FABoLLSlidableTabBarCell
    }

    private var selectedCellTitle: UILabel? {
        guard let subviews: [UIView] = selectedCell?.contentView.subviews else {
            return nil
        }
        for view in subviews {
            if let label = view as? UILabel {
                return label
            }
        }
        return nil
    }

    // MARK: - tests

    override func setUp() {
        super.setUp()
        base.addSubview(tabBarArea)
    }

    func testSimpleSetup() {
        tabBar = FABoLLSlidableTabBar(
            size: tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings(data: FABoLLSlidableTabBarTests.SettingsTestData),
            selected: nil
        )
        tabBarArea.addSubview(tabBar)

        guard let collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
    }
    /// Options and select action
    func testOptionSetup() {
        let selectedExpectation: XCTestExpectation = expectation(description: "SelectCell")
        var selectedRow: Int?
        tabBar = FABoLLSlidableTabBar(
            size: tabBarArea.frame.size,
            initRow: 1,
            clipTipWidth: 20,
            settings: FABoLLSlidableTabBarSettings(
                data: FABoLLSlidableTabBarTests.SettingsTestData,
                clipTipWidth: 20,
                iconSize: CGSize(width: 20, height: 20),
                normalDecoration: normalDecoration,
                selectedDecoration: selectedDecoration
            ),
            selected: { row in
                if row == self.selectedIndexPath.row {
                    selectedRow = row
                    selectedExpectation.fulfill()
                }
            }
        )
        tabBarArea.addSubview(tabBar)
        guard let collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: IndexPath(row: 0, section: 0))

        collection.layoutIfNeeded()
        guard let unSelectedCell: FABoLLSlidableTabBarCell = self.selectedCell else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(unSelectedCell.contentView.backgroundColor, normalDecoration.fillColor)
        XCTAssertEqual(unSelectedCell.contentView.layer.borderWidth, normalDecoration.borderWidth)
        XCTAssertEqual(unSelectedCell.contentView.layer.borderColor, normalDecoration.borderColor.cgColor)
        guard let unSelectedCellTitle = self.selectedCellTitle else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(unSelectedCellTitle.font, normalDecoration.titleFont)
        XCTAssertEqual(unSelectedCellTitle.textColor, normalDecoration.titleColor)
        XCTAssertEqual(
            unSelectedCellTitle.text,
            FABoLLSlidableTabBarTests.SettingsTestData[selectedIndexPath.row].title
        )
        // Selected
        collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(selectedRow, selectedIndexPath.row)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)

        collection.layoutIfNeeded()
        guard let selectedCell else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCell.contentView.backgroundColor, selectedDecoration.fillColor)
        XCTAssertEqual(selectedCell.contentView.layer.borderWidth, selectedDecoration.borderWidth)
        XCTAssertEqual(selectedCell.contentView.layer.borderColor, selectedDecoration.borderColor.cgColor)
        guard let selectedCellTitle else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCellTitle.font, selectedDecoration.titleFont)
        XCTAssertEqual(selectedCellTitle.textColor, selectedDecoration.titleColor)
        XCTAssertEqual(selectedCellTitle.text, FABoLLSlidableTabBarTests.SettingsTestData[selectedIndexPath.row].title)
    }
    // Change size
    func testChangeSize() {
        tabBar = FABoLLSlidableTabBar(
            size: tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings(data: FABoLLSlidableTabBarTests.SettingsTestData),
            selected: nil
        )
        tabBarArea.addSubview(tabBar)
        guard let collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)

        collection.layoutIfNeeded()
        guard let beforeSelectedCell: FABoLLSlidableTabBarCell = selectedCell else {
            XCTAssert(false)
            return
        }
        guard let beforeSelectedCellTitle: UILabel = selectedCellTitle else {
            XCTAssert(false)
            return
        }

        let newSize = CGSize(width: tabBarArea.frame.size.width * 1.5, height: tabBarArea.frame.size.height * 1.5)
        tabBar.updateSize(newSize)
        XCTAssertEqual(tabBar.frame.size, newSize)

        collection.layoutIfNeeded()
        guard let afterSelectedCell: FABoLLSlidableTabBarCell = selectedCell else {
            XCTAssert(false)
            return
        }
        guard let afterSelectedCellTitle: UILabel = selectedCellTitle else {
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
