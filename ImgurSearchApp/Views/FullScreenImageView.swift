//
//  FullScreenImageView.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 5/1/21.
//

import UIKit
import AlamofireImage

protocol FullScreenImageViewDelegate: AnyObject {
    func toggleNavigationBar()
}

class FullScreenImageView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    public weak var delegate: FullScreenImageViewDelegate?
    
    init() {
        super.init(frame: .zero)
        addSubview(imageView)
        backgroundColor = .systemBackground
        createConstraints()
        
        addTapGesture()
    }
    
    required init?(coder: NSCoder) {
        print("Does not support storyboards")
        return nil
    }
    
    private func createConstraints() {
        createCollectionViewConstraints()
    }
    
    private func createCollectionViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavbar))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleNavbar() {
        delegate?.toggleNavigationBar()
    }

// MARK: - Public Functions
    
    public func setImage(thumbnail: UIImage, imageLink: String) {
        if let imageURL = URL(string: imageLink) {
            imageView.af.setImage(withURL: imageURL, placeholderImage: thumbnail)
        } else {
            imageView.image = thumbnail
        }
    }
}
