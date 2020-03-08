//
//  FABoLLSlidableTabBarSettings.swift
//
//
//  Created by Masakiyo Tachikawa on 2020/03/04.
//
import UIKit
///
/// This type is for display contents of a cell.
///
/// - Tag: FABoLLSlidableTabBarCellData
///
/// ```
/// title: String,
/// icon: UIImage?,
/// selected: UIImage?
/// ```
///
public typealias FABoLLSlidableTabBarCellData = (
    title: String,
    icon: UIImage?,
    selected: UIImage?
)
///
/// This type is for cell decoration.
///
/// - Tag: FABoLLSlidableTabBarCellDecoration
///
/// ```
/// titleFont: UIFont,
/// titleColor: UIColor,
/// fillColor: UIColor,
/// borderColor: UIColor,
/// borderWidth: CGFloat
/// ```
///
public typealias FABoLLSlidableTabBarCellDecoration = (
    titleFont: UIFont,
    titleColor: UIColor,
    fillColor: UIColor,
    borderColor: UIColor,
    borderWidth: CGFloat
)
///
/// - Tag: FABoLLSlidableTabBarSettings
///
public struct FABoLLSlidableTabBarSettings {
    ///
    // MARK: -------------------- properties
    ///
    ///
    ///
    let data: [FABoLLSlidableTabBarCellData]
    ///
    ///
    ///
    let iconSize: CGSize
    ///
    /// This decoration is used for normal status.
    ///
    let normalDecoration: FABoLLSlidableTabBarCellDecoration
    ///
    /// This decoration is used for selected status.
    ///
    let selectedDecoration: FABoLLSlidableTabBarCellDecoration
    ///
    // MARK: -------------------- life cycle
    ///
    ///
    ///
    public init(
        data: [FABoLLSlidableTabBarCellData],
        clipTipWidth: CGFloat = 10.0,
        iconSize: CGSize = CGSize.init(width: 24, height: 24),
        normalDecoration: FABoLLSlidableTabBarCellDecoration = (
            titleFont: UIFont.systemFont(ofSize: 14.0),
            titleColor: UIColor.blue,
            fillColor: UIColor.white,
            borderColor: UIColor.blue,
            borderWidth: 1.0
        ),
        selectedDecoration: FABoLLSlidableTabBarCellDecoration = (
            titleFont: UIFont.boldSystemFont(ofSize: 14.0),
            titleColor: UIColor.white,
            fillColor: UIColor.blue,
            borderColor: UIColor.blue,
            borderWidth: 1.0
        )
    ) {
        self.data = data
        self.iconSize = iconSize
        self.normalDecoration = normalDecoration
        self.selectedDecoration = selectedDecoration
    }
}
