//
//  FABoLLSlidableTabBarSettings
//
//  © 2023 Masakiyo Tachikawa
//

import UIKit

// MARK: - FABoLLSlidableTabBarCellData

public typealias FABoLLSlidableTabBarCellData = (
    title: String,
    icon: UIImage?,
    selected: UIImage?
)

// MARK: - FABoLLSlidableTabBarCellDecoration

public typealias FABoLLSlidableTabBarCellDecoration = (
    titleFont: UIFont,
    titleColor: UIColor,
    fillColor: UIColor,
    borderColor: UIColor,
    borderWidth: CGFloat
)

// MARK: - FABoLLSlidableTabBarSettings

public struct FABoLLSlidableTabBarSettings {

    // MARK: - Properties

    let data: [FABoLLSlidableTabBarCellData]
    /// If you want to unselect a selected cell with tapping it, set this flag `true`.
    /// Default is `false`.
    let canUnselect: Bool

    let iconSize: CGSize
    /// This decoration is used for normal status.
    let normalDecoration: FABoLLSlidableTabBarCellDecoration
    /// This decoration is used for selected status.
    let selectedDecoration: FABoLLSlidableTabBarCellDecoration

    // MARK: - Life cycle

    public init(
        data: [FABoLLSlidableTabBarCellData],
        canUnselect: Bool = false,
        clipTipWidth: CGFloat = 10,
        iconSize: CGSize = CGSize(width: 24, height: 24),
        normalDecoration: FABoLLSlidableTabBarCellDecoration = (
            titleFont: UIFont.systemFont(ofSize: 14),
            titleColor: .blue,
            fillColor: .white,
            borderColor: .blue,
            borderWidth: 1
        ),
        selectedDecoration: FABoLLSlidableTabBarCellDecoration = (
            titleFont: UIFont.boldSystemFont(ofSize: 14),
            titleColor: .white,
            fillColor: .blue,
            borderColor: .blue,
            borderWidth: 1
        )
    ) {
        self.data = data
        self.canUnselect = canUnselect
        self.iconSize = iconSize
        self.normalDecoration = normalDecoration
        self.selectedDecoration = selectedDecoration
    }
}
