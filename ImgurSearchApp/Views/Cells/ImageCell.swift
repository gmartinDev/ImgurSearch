//
//  ImageCell.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import UIKit
import AlamofireImage

class ImageCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    
    public var imageUrl: String = "" {
        didSet {
            let placeHolderImg = #imageLiteral(resourceName: "placeholderImage")
            if let url = URL(string: imageUrl) {
                imageView.af.setImage(withURL: url, placeholderImage: placeHolderImg, completion:  { (_) in
                    self.imageView.contentMode = .scaleAspectFit
                })
            } else {
                imageView.image = placeHolderImg
                imageView.contentMode = .center
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        backgroundColor = .systemBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        print("Does not support storyboards")
        return nil
    }
    
    private func createConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.af.cancelImageRequest()
        imageView.image = nil
    }
}
