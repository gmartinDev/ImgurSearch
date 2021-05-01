//
//  FullScreenImageController.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 5/1/21.
//

import UIKit

class FullScreenImageController: UIViewController {
    private let thumbnail: UIImage
    private let originalImageLink: String
    
    public var contentView: FullScreenImageView? {
        return view as? FullScreenImageView
    }
    
    init(thumbnail: UIImage, originalImageLink: String) {
        self.thumbnail = thumbnail
        self.originalImageLink = originalImageLink
        super.init(nibName: nil, bundle: nil)
        
        contentView?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        print("Does not support storyboards")
        return nil
    }
    
    override func loadView() {
        view = FullScreenImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Selected image"
        contentView?.setImage(thumbnail: thumbnail, imageLink: originalImageLink)
    }
}

extension FullScreenImageController: FullScreenImageViewDelegate {
    func toggleNavigationBar() {
        navigationController?.navigationBar.isHidden.toggle()
    }
}
