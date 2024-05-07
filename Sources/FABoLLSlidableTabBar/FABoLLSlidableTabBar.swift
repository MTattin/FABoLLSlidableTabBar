//
//  FABoLLSlidableTabBar
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
//  © 2023 Masakiyo Tachikawa
//

import UIKit

// MARK: - FABoLLSlidableTabBar

/// Create a tab bar using UICollectionView
public class FABoLLSlidableTabBar: UIView {

    // MARK: - Properties

    private let flowLayout = UICollectionViewFlowLayout()

    private let collectionView: UICollectionView

    private var settings = FABoLLSlidableTabBarSettings(data: [])

    private var callbackSelected: ((_ row: Int) -> Void)?

    private(set) var selectedIndexPath: IndexPath? = nil
    /// This property is used for both side insets and clip tip display area width.
    /// Clip tip is set larger than this property.
    private var clipTipWidth: CGFloat = 10
    /// This property is used for a margin between each cell.
    private var cellMarginHorizontal: CGFloat = 10
    /// This property is used for a horizontal padding of each cell.
    /// This is added 1px automatically when all cells is not on the clip tip area.
    private var cellPaddingHorizontal: CGFloat = 15
    /// This property is used for cache to save each calculated cell width.
    private var cellWidthList: [IndexPath : CGFloat] = [:]

    // MARK: - Life cycle

    deinit {
        print("FABoLLSlidableTabBar released")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        flowLayout.scrollDirection = .horizontal
        collectionView = UICollectionView(
            frame: frame,
            collectionViewLayout: flowLayout
        )
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(collectionView)

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundView = nil
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            FABoLLSlidableTabBarCell.self,
            forCellWithReuseIdentifier: FABoLLSlidableTabBarCell.Identifier
        )
    }

    public convenience init(
        size: CGSize,
        initRow: Int? = nil,
        clipTipWidth: CGFloat = 10,
        settings: FABoLLSlidableTabBarSettings,
        selected: ((_ row: Int) -> Void)?
    ) {
        self.init(frame: CGRect(origin: .zero, size: size))
        self.clipTipWidth = clipTipWidth
        callbackSelected = selected
        if let initRow {
            selectedIndexPath = IndexPath(row: initRow, section: 0)
        } else {
            if !settings.canUnselect {
                selectedIndexPath = IndexPath(row: 0, section: 0)
            }
        }
        self.settings = settings
        setCellWidth()
        checkClipTip { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    private func setCellWidth() {
        cellWidthList.removeAll()
        var row: Int = 0
        for item in settings.data {
            let iconSize: CGSize = (item.icon == nil) ? .zero : settings.iconSize
            let width: CGFloat = FABoLLSlidableTabBarCell.CellWidth(
                font: settings.normalDecoration.titleFont,
                fontSelected: settings.selectedDecoration.titleFont,
                title: item.title,
                iconSize: iconSize
            )
            cellWidthList[IndexPath(row: row, section: 0)] = width
            row += 1
        }
    }

    private func checkClipTip(_ callback: (() -> Void)?) {
        var tempX: CGFloat = clipTipWidth
        // create frame of each cell
        let frames: [CGRect] = cellWidthList
            .sorted { (a: (key: IndexPath, value: CGFloat), b: (key: IndexPath, value: CGFloat)) -> Bool in
                a.key.row < b.key.row
            }
            .map { (item: (key: IndexPath, value: CGFloat)) -> CGRect in
                let cellWidth: CGFloat = round(item.value + (cellPaddingHorizontal * 2))
                let frame = CGRect(x: tempX, y: 0, width: cellWidth, height: collectionView.frame.height)
                tempX += (cellWidth + cellMarginHorizontal)
                return frame
            }

        // is a need to check clip tip ?
        guard let lastFrame: CGRect = frames.last else {
            callback?()
            return
        }
        let clipTipPoint = CGPoint(x: collectionView.frame.width, y: collectionView.frame.height * 0.5)
        if (lastFrame.origin.x + lastFrame.width) <= clipTipPoint.x {
            callback?()
            return
        }
        // check clip tip
        var canCallback: Bool = false
        for cellFrame in frames {
            let okArea = CGRect(
                x: cellFrame.origin.x + clipTipWidth,
                y: cellFrame.origin.y,
                width: cellFrame.width - (clipTipWidth * 2),
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
            cellPaddingHorizontal += 1
            setCellWidth()
            checkClipTip(callback)
        }
    }

    // MARK: - Conveniences

    /// - Parameter size:
    ///     Size you want to change.
    ///
    /// - Parameter isScrollSelectedCellToCenter:
    ///     If you want to scroll selected cell to tab bar center after changing size, please set  `true`.
    ///     Default is `false`
    public func updateSize(_ size: CGSize, isScrollSelectedCellToCenter: Bool = false) {
        frame.size = size
        collectionView.frame = frame
        setCellWidth()
        checkClipTip { [weak self] in
            guard let self else { return }
            collectionView.reloadData()
            guard
                let selectedIndexPath,
                isScrollSelectedCellToCenter == true
            else {
                return
            }
            collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FABoLLSlidableTabBar: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath == indexPath, settings.canUnselect == false {
            callbackSelected?(indexPath.row)
            return
        }
        let newIndexPath: IndexPath? = (selectedIndexPath == indexPath) ? nil : indexPath
        var reloadIndexPath: [IndexPath] = [
            indexPath,
        ]
        if let old: IndexPath = selectedIndexPath, old != indexPath {
            reloadIndexPath.append(old)
        }
        selectedIndexPath = newIndexPath
        collectionView.reloadItems(at: reloadIndexPath)
        callbackSelected?(indexPath.row)
        if let selectedIndexPath {
            collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FABoLLSlidableTabBar: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        settings.data.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FABoLLSlidableTabBarCell.Identifier,
            for: indexPath
        ) as! FABoLLSlidableTabBarCell
        let item: FABoLLSlidableTabBarCellData = settings.data[indexPath.row]
        cell.set(
            title: item.title,
            icon: (selectedIndexPath == indexPath) ? item.selected : item.icon,
            iconSize: settings.iconSize,
            paddingHorizontal: cellPaddingHorizontal
        )
        cell.decoration(
            style: (selectedIndexPath == indexPath) ? settings.selectedDecoration : settings.normalDecoration,
            height: collectionView.frame.height
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FABoLLSlidableTabBar: UICollectionViewDelegateFlowLayout {

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let width: CGFloat = cellWidthList[indexPath] else {
            fatalError()
        }
        return CGSize(width: width + (cellPaddingHorizontal * 2), height: collectionView.frame.height)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: clipTipWidth, bottom: 0, right: clipTipWidth)
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        cellMarginHorizontal
    }
}
