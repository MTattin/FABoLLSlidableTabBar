//
//  FABoLLSlidableTabBarCell
//
//  © 2023 Masakiyo Tachikawa
//

import UIKit

// MARK: - FABoLLSlidableTabBarCell

final class FABoLLSlidableTabBarCell: UICollectionViewCell {

    // MARK: - Static Properties

    static let Identifier: String = "FABoLLSlidableTabBarCell"

    // MARK: - Static Conveniences

    static func CellWidth(font: UIFont, fontSelected: UIFont, title: String, iconSize: CGSize) -> CGFloat {
        let label = UILabel()
        label.font = font
        label.text = title
        label.sizeToFit()
        let normal: CGFloat = label.frame.width
        label.font = fontSelected
        label.sizeToFit()
        let selected: CGFloat = label.frame.width
        let labelWidth: CGFloat = max(normal, selected)
        if iconSize == CGSize.zero {
            return ceil(labelWidth)
        }
        return ceil(labelWidth + 5 + iconSize.width)
    }

    // MARK: - Properties

    private let title = UILabel()
    private var titleLeading: NSLayoutConstraint!
    private var titleTrailing: NSLayoutConstraint!

    private let icon = UIImageView()
    private var iconLeading: NSLayoutConstraint!
    private var iconWidth: NSLayoutConstraint!
    private var iconHeight: NSLayoutConstraint!

    // MARK: - Life cycle

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        initIcon()
        initTitle()
    }

    private func initIcon() {
        icon.frame = CGRect()
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFit
        icon.image = nil
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
        // constraints
        icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        iconLeading = icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        iconWidth = icon.widthAnchor.constraint(equalToConstant: 0)
        iconHeight = icon.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate(
            [
                iconLeading,
                iconWidth,
                iconHeight,
            ]
        )
    }

    private func initTitle() {
        title.frame = CGRect()
        title.text = ""
        title.backgroundColor = .clear
        title.textColor = .darkText
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        // constraints
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        titleLeading = title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 0)
        titleTrailing = title.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: 0)
        NSLayoutConstraint.activate(
            [
                titleLeading,
                titleTrailing,
            ]
        )
    }

    func set(title: String, icon: UIImage?, iconSize: CGSize, paddingHorizontal: CGFloat) {
        self.title.text = title
        iconLeading.constant = paddingHorizontal
        titleTrailing.constant = -paddingHorizontal
        // is there an icon image ?
        guard let icon else {
            self.icon.isHidden = true
            self.icon.image = nil
            iconWidth.constant = 0
            iconHeight.constant = 0
            titleLeading.constant = 0
            return
        }
        iconWidth.constant = iconSize.width
        iconHeight.constant = iconSize.height
        titleLeading.constant = 5
        self.icon.image = icon
        self.icon.isHidden = false
    }

    func decoration(style: FABoLLSlidableTabBar.CellDecoration, height: CGFloat) {
        contentView.backgroundColor = style.fillColor
        contentView.layer.cornerRadius = height * 0.5
        contentView.layer.borderColor = style.borderColor.cgColor
        contentView.layer.borderWidth = style.borderWidth
        title.font = style.titleFont
        title.textColor = style.titleColor
    }
}
