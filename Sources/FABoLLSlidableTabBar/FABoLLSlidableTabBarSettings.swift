//
//  FABoLLSlidableTabBarSettings
//
//  © 2023 Masakiyo Tachikawa
//

import UIKit

// MARK: - FABoLLSlidableTabBarSettings

public struct FABoLLSlidableTabBarSettings: Sendable {

    // MARK: - Properties

    public private(set) var data: [FABoLLSlidableTabBar.CellData]
    /// If you want to unselect a selected cell with tapping it, set this flag `true`.
    /// Default is `false`.
    public private(set) var canUnselect: Bool

    public private(set) var iconSize: CGSize
    /// This decoration is used for normal status.
    public private(set) var normalDecoration: FABoLLSlidableTabBar.CellDecoration
    /// This decoration is used for selected status.
    public private(set) var selectedDecoration: FABoLLSlidableTabBar.CellDecoration

    // MARK: - Life cycle

    public init(
        data: [FABoLLSlidableTabBar.CellData] = [],
        canUnselect: Bool = false,
        clipTipWidth: CGFloat = 10,
        iconSize: CGSize = CGSize(width: 24, height: 24),
        normalDecoration: FABoLLSlidableTabBar.CellDecoration = .defaultNormal,
        selectedDecoration: FABoLLSlidableTabBar.CellDecoration = .defaultSelected
    ) {
        self.data = data
        self.canUnselect = canUnselect
        self.iconSize = iconSize
        self.normalDecoration = normalDecoration
        self.selectedDecoration = selectedDecoration
    }

    public mutating func update<T>(_ key: KeyPath<Self, T>, _ value: T) {
        guard let writableKey = key as? WritableKeyPath<Self, T> else {
            assertionFailure("KeyPath変換で問題発生")
            return
        }
        self[keyPath: writableKey] = value
    }
}

extension FABoLLSlidableTabBar {
    public struct CellData: Sendable {
        public private(set) var title: String
        public private(set) var icon: UIImage?
        public private(set) var selected: UIImage?

        public init(
            title: String,
            icon: UIImage? = nil,
            selected: UIImage? = nil
        ) {
            self.title = title
            self.icon = icon
            self.selected = selected
        }
    }

    public struct CellDecoration: Sendable {
        public static var defaultNormal: Self {
            .init(
                titleFont: UIFont.systemFont(ofSize: 14),
                titleColor: .blue,
                fillColor: .white,
                borderColor: .blue,
                borderWidth: 1
            )
        }
        public static var defaultSelected: Self {
            .init(
                titleFont: UIFont.boldSystemFont(ofSize: 14),
                titleColor: .white,
                fillColor: .blue,
                borderColor: .blue,
                borderWidth: 1
            )
        }

        public private(set) var titleFont: UIFont
        public private(set) var titleColor: UIColor
        public private(set) var fillColor: UIColor
        public private(set) var borderColor: UIColor
        public private(set) var borderWidth: CGFloat

        public init(
            titleFont: UIFont,
            titleColor: UIColor,
            fillColor: UIColor,
            borderColor: UIColor,
            borderWidth: CGFloat
        ) {
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.fillColor = fillColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
        }
    }
}
