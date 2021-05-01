//
//  ImageSearchView.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation
import UIKit

protocol ImageSearchViewDatasource: AnyObject {
    func getImageCount() -> Int
    func getImage(at indexPath: IndexPath) -> ImageModel?
}

protocol ImageSearchViewDelegate: AnyObject {
    func imageSelected(at indexPath: IndexPath)
}

class ImageSearchView: UIView {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    public weak var datasource: ImageSearchViewDatasource?
    public weak var delegate: ImageSearchViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        print("Does not support storyboards")
        return nil
    }
    
    private func createConstraints() {
        createCollectionViewConstraints()
    }
    
    private func createCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    public func refreshList() {
        self.collectionView.reloadData()
    }
}

extension ImageSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.imageSelected(at: indexPath)
    }
}

extension ImageSearchView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource?.getImageCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageModel = datasource?.getImage(at: indexPath) else {
            print("Gallery is unavailable for indexPath: \(indexPath)")
            return UICollectionViewCell()
        }
        let cell: ImageCell
        if let reuseCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell {
            cell = reuseCell
        } else {
            cell = ImageCell(frame: .zero)
        }
        
        //TODO: setup cell with image
        cell.imageUrl = imageModel.link
        
        return cell
    }
}

extension ImageSearchView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let halfWidth = collectionView.bounds.size.width / 2
        return CGSize(width: halfWidth - 16, height: halfWidth - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
