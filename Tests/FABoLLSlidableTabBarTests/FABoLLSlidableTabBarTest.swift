//
//  FABoLLSlidableTabBarTest
//
//  © 2023 Masakiyo Tachikawa
//

import Testing
import XCTest
@testable import FABoLLSlidableTabBar

@MainActor
struct FABoLLSlidableTabBarTest {

    private static let SettingsTestData: [FABoLLSlidableTabBar.CellData] = [
        .init(title: "アイウエ"),
        .init(title: "アイウAA"),
        .init(title: "かきくけこ"),
        .init(title: "かきくけこAA"),
        .init(title: "さしすせそ"),
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
    private let normalDecoration: FABoLLSlidableTabBar.CellDecoration = .init(
        titleFont: UIFont.systemFont(ofSize: 13, weight: .regular),
        titleColor: .darkGray,
        fillColor:  .white.withAlphaComponent(0.8),
        borderColor: .gray,
        borderWidth: 1
    )
    private let selectedDecoration: FABoLLSlidableTabBar.CellDecoration = .init(
        titleFont: UIFont.systemFont(ofSize: 13, weight: .bold),
        titleColor: .white,
        fillColor: .red.withAlphaComponent(0.8),
        borderColor: .red,
        borderWidth: 1
    )

    @Test func test() async throws {
        base.addSubview(tabBarArea)
        var tabBar: FABoLLSlidableTabBar = .init(
            size: tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings(data: Self.SettingsTestData),
            selected: nil
        )
        tabBarArea.addSubview(tabBar)
        guard let collection = tabBar.collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)

        // Options and select action
        let selectedRow: Int? = await withCheckedContinuation { continuation in
            tabBar = .init(
                size: tabBarArea.frame.size,
                initRow: 1,
                clipTipWidth: 20,
                settings: .init(
                    data: Self.SettingsTestData,
                    clipTipWidth: 20,
                    iconSize: CGSize(width: 20, height: 20),
                    normalDecoration: normalDecoration,
                    selectedDecoration: selectedDecoration
                ),
                selected: { row in
                    if row == self.selectedIndexPath.row {
                        continuation.resume(returning: row)
                    }
                }
            )
            guard let collection = tabBar.collection else {
                XCTAssert(false)
                return
            }
            XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
            collection.delegate?.collectionView?(collection, didSelectItemAt: IndexPath(row: 0, section: 0))

            collection.layoutIfNeeded()
            guard let unSelectedCell: FABoLLSlidableTabBarCell = tabBar.cell(at: self.selectedIndexPath) else {
                XCTAssert(false)
                return
            }
            XCTAssertEqual(unSelectedCell.contentView.backgroundColor, normalDecoration.fillColor)
            XCTAssertEqual(unSelectedCell.contentView.layer.borderWidth, normalDecoration.borderWidth)
            XCTAssertEqual(unSelectedCell.contentView.layer.borderColor, normalDecoration.borderColor.cgColor)
            guard let unSelectedCellTitle = unSelectedCell.title else {
                XCTAssert(false)
                return
            }
            XCTAssertEqual(unSelectedCellTitle.font, normalDecoration.titleFont)
            XCTAssertEqual(unSelectedCellTitle.textColor, normalDecoration.titleColor)
            XCTAssertEqual(unSelectedCellTitle.text, Self.SettingsTestData[selectedIndexPath.row].title)
            // Selected
            collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        }
        guard let selectedRow else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedRow, selectedIndexPath.row)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        tabBar.collection?.layoutIfNeeded()
        guard let selectedCell = tabBar.cell(at: IndexPath(row: selectedRow, section: 0)) else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCell.contentView.backgroundColor, selectedDecoration.fillColor)
        XCTAssertEqual(selectedCell.contentView.layer.borderWidth, selectedDecoration.borderWidth)
        XCTAssertEqual(selectedCell.contentView.layer.borderColor, selectedDecoration.borderColor.cgColor)
        guard let selectedCellTitle: UILabel = selectedCell.title else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(selectedCellTitle.font, selectedDecoration.titleFont)
        XCTAssertEqual(selectedCellTitle.textColor, selectedDecoration.titleColor)
        XCTAssertEqual(selectedCellTitle.text, Self.SettingsTestData[selectedIndexPath.row].title)

        // Change size
        tabBar = FABoLLSlidableTabBar(
            size: tabBarArea.frame.size,
            settings: FABoLLSlidableTabBarSettings(data: Self.SettingsTestData),
            selected: nil
        )
        guard let collection = tabBar.collection else {
            XCTAssert(false)
            return
        }
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.delegate?.collectionView?(collection, didSelectItemAt: selectedIndexPath)
        XCTAssertEqual(tabBar.frame.size, tabBarArea.frame.size)
        collection.layoutIfNeeded()
        guard let beforeSelectedCell: FABoLLSlidableTabBarCell = tabBar.cell(at: selectedIndexPath) else {
            XCTAssert(false)
            return
        }
        guard let beforeSelectedCellTitle: UILabel = beforeSelectedCell.title else {
            XCTAssert(false)
            return
        }
        let newSize = CGSize(width: tabBarArea.frame.size.width * 1.5, height: tabBarArea.frame.size.height * 1.5)
        tabBar.updateSize(newSize)
        XCTAssertEqual(tabBar.frame.size, newSize)
        collection.layoutIfNeeded()
        guard let afterSelectedCell: FABoLLSlidableTabBarCell = tabBar.cell(at: selectedIndexPath) else {
            XCTAssert(false)
            return
        }
        guard let afterSelectedCellTitle: UILabel = afterSelectedCell.title else {
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

private extension FABoLLSlidableTabBar {
    var collection: UICollectionView? {
        for view in subviews {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }

    func cell(at indexPath: IndexPath) -> FABoLLSlidableTabBarCell? {
        collection?.cellForItem(at: indexPath) as? FABoLLSlidableTabBarCell
    }
}

private extension FABoLLSlidableTabBarCell {
    var title: UILabel? {
        for view in contentView.subviews {
            if let label = view as? UILabel {
                return label
            }
        }
        return nil
    }
}
