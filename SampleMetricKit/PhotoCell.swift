//
//  PhotoCell.swift
//  ImageFormats
//
//  Created by a.pomozov on 18.11.2022.
//

import UIKit

final class PhotoCell: UICollectionViewCell {

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage) {
        imageView.image = image
        imageView.alpha = 0.5
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 4.0
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        imageView.layer.shadowRadius = 10.0
        imageView.layer.shouldRasterize = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}


private extension PhotoCell {
    func setupCell() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
