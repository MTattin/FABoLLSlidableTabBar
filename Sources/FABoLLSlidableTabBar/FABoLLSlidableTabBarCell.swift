//
//  FABoLLSlidableTabBarCell.swift
//  
//
//  Created by Masakiyo Tachikawa on 2020/03/06.
//
import UIKit
///
/// - Tag: FABoLLSlidableTabBarCell
///
final class FABoLLSlidableTabBarCell: UICollectionViewCell {
    ///
    // MARK: -------------------- static propetries
    ///
    ///
    ///
    static let Identifier: String = "FABoLLSlidableTabBarCell"
    ///
    // MARK: -------------------- static mechot
    ///
    ///
    ///
    static func CellWidth(
        font: UIFont,
        fontSelected: UIFont,
        title: String,
        iconSize: CGSize
    ) -> CGFloat {
        let label: UILabel = UILabel.init()
        label.font = font
        label.text = title
        label.sizeToFit()
        let normal: CGFloat = label.frame.width
        label.font = fontSelected
        label.sizeToFit()
        let selected: CGFloat = label.frame.width
        let labelWidth: CGFloat = max(normal, selected)
        if iconSize == CGSize.zero {
            return labelWidth
        }
        return labelWidth + 5.0 + iconSize.width
    }
    ///
    // MARK: -------------------- propetries
    ///
    ///
    ///
    private let _title: UILabel = UILabel.init()
    private var _titleLeading: NSLayoutConstraint!
    private var _titleTrailing: NSLayoutConstraint!
    ///
    ///
    ///
    private let _icon: UIImageView = UIImageView.init()
    private var _iconLeading: NSLayoutConstraint!
    private var _iconWidth: NSLayoutConstraint!
    private var _iconHeight: NSLayoutConstraint!
    ///
    // MARK: -------------------- life cycle
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
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.clipsToBounds = true
        self._initIcon()
        self._initTitle()
    }
    ///
    ///
    ///
    private func _initIcon() {
        self._icon.frame = CGRect.init()
        self._icon.backgroundColor = UIColor.clear
        self._icon.contentMode = UIView.ContentMode.scaleAspectFit
        self._icon.image = nil
        self._icon.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._icon)
        ///
        /// constraints
        ///
        self._icon.centerYAnchor
            .constraint(equalTo: self.contentView.centerYAnchor)
            .isActive = true
        self._iconLeading = self._icon.leadingAnchor
            .constraint(equalTo: self.contentView.leadingAnchor, constant: 0.0)
        self._iconWidth = self._icon.widthAnchor
            .constraint(equalToConstant: 0.0)
        self._iconHeight = self._icon.heightAnchor
            .constraint(equalToConstant: 0.0)
        NSLayoutConstraint.activate(
            [
                self._iconLeading,
                self._iconWidth,
                self._iconHeight,
            ]
        )
    }
    ///
    ///
    ///
    private func _initTitle() {
        self._title.frame = CGRect.init()
        self._title.text = ""
        self._title.backgroundColor = UIColor.clear
        self._title.textColor = UIColor.darkText
        self._title.textAlignment = NSTextAlignment.left
        self._title.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self._title)
        ///
        /// constraints
        ///
        self._title.topAnchor
            .constraint(equalTo: self.contentView.topAnchor, constant: 0.0)
            .isActive = true
        self._title.bottomAnchor
            .constraint(equalTo: self.contentView.bottomAnchor, constant: 0.0)
            .isActive = true
        self._titleLeading = self._title.leadingAnchor
            .constraint(equalTo: self._icon.trailingAnchor, constant: 0.0)
        self._titleTrailing = self._title.trailingAnchor
            .constraint(equalTo: self.contentView.trailingAnchor, constant: 0.0)
        NSLayoutConstraint.activate(
            [
                self._titleLeading,
                self._titleTrailing,
            ]
        )
    }
    ///
    ///
    ///
    func set(
        title: String,
        icon: UIImage?,
        iconSize: CGSize,
        paddingHorizontal: CGFloat
    ) {
        self._title.text = title
        self._iconLeading.constant = paddingHorizontal
        self._titleTrailing.constant = -paddingHorizontal
        ///
        /// is there an icon image ?
        ///
        guard let icon: UIImage = icon else {
            self._icon.isHidden = true
            self._icon.image = nil
            self._iconWidth.constant = 0.0
            self._iconHeight.constant = 0.0
            self._titleLeading.constant = 0.0
            return
        }
        self._icon.image = icon
        self._iconWidth.constant = iconSize.width
        self._iconHeight.constant = iconSize.height
        self._titleLeading.constant = 5.0
        self._icon.isHidden = false
    }
    ///
    ///
    ///
    func decoration(style: FABoLLSlidableTabBarCellDecoration, height: CGFloat) {
        self.contentView.backgroundColor = style.fillColor
        self.contentView.layer.cornerRadius = height * 0.5
        self.contentView.layer.borderColor = style.borderColor.cgColor
        self.contentView.layer.borderWidth = style.borderWidth
        self._title.font = style.titleFont
        self._title.textColor = style.titleColor        
    }
}
