//
//  FABoLLSlidableTabBar.swift
//
//  Created by Masakiyo Tachikawa on 2020/03/05.
//  Copyright © 2020 FABoLL. All rights reserved.
//
//  Copyright 2020 Masakiyo Tachikawa
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import UIKit
///
/// Create a tab bar using UICollectionView
///
/// - Tag: FABoLLSlidableTabBar
///
public class FABoLLSlidableTabBar: UIView {
    ///
    // MARK: ------------------------------ properties
    ///
    ///
    ///
    private let _flowlayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    ///
    ///
    ///
    private let _collectionView: UICollectionView
    ///
    ///
    ///
    private var _settings: FABoLLSlidableTabBarSettings = FABoLLSlidableTabBarSettings.init(data: [])
    ///
    ///
    ///
    private var _callbackSelected: ((_ row: Int) -> Void)?
    ///
    ///
    ///
    private(set) var _selectedIndexPath: IndexPath = IndexPath.init(row: 0, section: 0)
    ///
    /// This property is used for both side insets and clip tip display area width.
    /// Clip tip is set larger than this property.
    ///
    private var _clipTipWidth: CGFloat = 10.0
    ///
    /// This property is used for a margin between each cell.
    ///
    private var _cellMarginHorizontal: CGFloat = 10.0
    ///
    /// This property is used for a horizontal padding of each cell.
    /// This is added 1px automatically when all cells is not on the clip tip area.
    ///
    private var _cellPaddingHorizontal: CGFloat = 15.0
    ///
    /// This property is used for cache to save each caluculated cell witdh.
    ///
    private var _cellWidthList: [IndexPath : CGFloat] = [:]
    ///
    // MARK: -------------------- life cycle
    ///
    ///
    ///
    deinit {
        print("FABoLLSlidableTabBar released")
    }
    ///
    ///
    ///
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///
    ///
    ///
    override init(frame: CGRect) {
        ///
        self._flowlayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self._collectionView = UICollectionView.init(
            frame: frame,
            collectionViewLayout: self._flowlayout
        )
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.addSubview(self._collectionView)
        ///
        self._collectionView.showsHorizontalScrollIndicator = false
        self._collectionView.showsVerticalScrollIndicator = false
        self._collectionView.backgroundView = nil
        self._collectionView.backgroundColor = UIColor.clear
        self._collectionView.delegate = self
        self._collectionView.dataSource = self
        self._collectionView.register(
            FABoLLSlidableTabBarCell.self,
            forCellWithReuseIdentifier: FABoLLSlidableTabBarCell.Identifier
        )
    }
    ///
    ///
    ///
    public convenience init(
        size: CGSize,
        clipTipWidth: CGFloat = 10.0,
        settings: FABoLLSlidableTabBarSettings,
        initRow: Int = 0,
        selected: ((_ row: Int) -> Void)?
    ) {
        self.init(frame: CGRect.init(origin: CGPoint.zero, size: size))
        self._clipTipWidth = clipTipWidth
        self._callbackSelected = selected
        self._selectedIndexPath = IndexPath.init(row: initRow, section: 0)
        self._settings = settings
        self._setCellWidth()
        self._checkClipTip { [weak self] in
            self?._collectionView.reloadData()
        }
    }
    ///
    ///
    ///
    private func _setCellWidth() {
        self._cellWidthList.removeAll()
        var row: Int = 0
        for item in self._settings.data {
            let iconSize: CGSize = (item.icon == nil) ? CGSize.zero : self._settings.iconSize
            let width: CGFloat = FABoLLSlidableTabBarCell.CellWidth(
                font: self._settings.normalDecoration.titleFont,
                fontSelected: self._settings.selectedDecoration.titleFont,
                title: item.title,
                iconSize: iconSize
            )
            self._cellWidthList[IndexPath.init(row: row, section: 0)] = width
            row += 1
        }
    }
    ///
    ///
    ///
    private func _checkClipTip(_ callback: (() -> Void)?) {
        var tempX: CGFloat = self._clipTipWidth
        ///
        /// create frame of each cell
        ///
        let frames: [CGRect] = self._cellWidthList
            .sorted { (a: (key: IndexPath, value: CGFloat), b: (key: IndexPath, value: CGFloat)) -> Bool in
                return a.key.row < b.key.row
            }
            .map { (item: (key: IndexPath, value: CGFloat)) -> CGRect in
                let cellWidth: CGFloat = round(item.value + (self._cellPaddingHorizontal * 2.0))
                let frame: CGRect = CGRect.init(
                    x: tempX,
                    y: 0.0,
                    width: cellWidth,
                    height: self._collectionView.frame.height
                )
                tempX += (cellWidth + self._cellMarginHorizontal)
                return frame
            }
        ///
        /// is a need to check clip tip ?
        ///
        guard let lastFrame: CGRect = frames.last else {
            callback?()
            return
        }
        let clipTipPoint: CGPoint = CGPoint.init(
            x: self._collectionView.frame.width,
            y: self._collectionView.frame.height * 0.5
        )
        if (lastFrame.origin.x + lastFrame.width) <= clipTipPoint.x {
            callback?()
            return
        }
        ///
        /// check clip tip
        ///
        var canCallback: Bool = false
        for cellFrame in frames {
            let okArea: CGRect = CGRect.init(
                x: cellFrame.origin.x + self._clipTipWidth,
                y: cellFrame.origin.y,
                width: cellFrame.width - (self._clipTipWidth * 2.0),
                height: cellFrame.height
            )
            if okArea.contains(clipTipPoint) {
                canCallback = true
                break
            }
            if cellFrame.origin.x > clipTipPoint.x {
                break
            }
        }
        if canCallback == true {
            callback?()
        } else {
            self._cellPaddingHorizontal += 1.0
            self._setCellWidth()
            self._checkClipTip(callback)
        }
    }
}
///
// MARK: ------------------------------ UICollectionViewDelegate
///
///
///
extension FABoLLSlidableTabBar: UICollectionViewDelegate {
    ///
    ///
    ///
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self._selectedIndexPath == indexPath {
            self._callbackSelected?(indexPath.row)
            return
        }
        let old: IndexPath = self._selectedIndexPath
        self._selectedIndexPath = indexPath
        self._collectionView.reloadItems(
            at: [
                old,
                indexPath
            ]
        )
        self._callbackSelected?(indexPath.row)
        collectionView.scrollToItem(
            at: indexPath,
            at: UICollectionView.ScrollPosition.centeredHorizontally,
            animated: true
        )
    }
}
///
// MARK: ------------------------------ UICollectionViewDataSource
///
///
///
extension FABoLLSlidableTabBar: UICollectionViewDataSource {
    ///
    ///
    ///
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._settings.data.count
    }
    ///
    ///
    ///
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: FABoLLSlidableTabBarCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FABoLLSlidableTabBarCell.Identifier,
            for: indexPath
        ) as! FABoLLSlidableTabBarCell
        let item: FABoLLSlidableTabBarCellData = self._settings.data[indexPath.row]
        cell.set(
            title: item.title,
            icon: (self._selectedIndexPath == indexPath)
                ? item.selected
                : item.icon,
            iconSize: self._settings.iconSize,
            paddingHorizontal: self._cellPaddingHorizontal
        )
        cell.decoration(
            style: (self._selectedIndexPath == indexPath)
                ? self._settings.selectedDecoration
                : self._settings.normalDecoration,
            height: collectionView.frame.height
        )
        return cell
    }
}
///
// MARK: -------------------- UICollectionViewDelegateFlowLayout
///
///
///
extension FABoLLSlidableTabBar: UICollectionViewDelegateFlowLayout {
    ///
    ///
    ///
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {        
        guard let width: CGFloat = self._cellWidthList[indexPath] else {
            fatalError()
        }
        return CGSize.init(
            width: width + (self._cellPaddingHorizontal * 2),
            height: collectionView.frame.height
        )
    }
    ///
    ///
    //
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets.init(
            top: 0.0,
            left: self._clipTipWidth,
            bottom: 0.0,
            right: self._clipTipWidth
        )
    }
    ///
    ///
    ///
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0.0
    }
    ///
    ///
    ///
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return self._cellMarginHorizontal
    }
}
