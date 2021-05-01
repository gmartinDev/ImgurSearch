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
    func imageSelected(at indexPath: IndexPath, thumbnail: UIImage?)
}

class ImageSearchView: UIView {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Search for an image!"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .gray
        spinner.isHidden = true
        return spinner
    }()
    
    public weak var datasource: ImageSearchViewDatasource?
    public weak var delegate: ImageSearchViewDelegate?
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        addSubview(stateLabel)
        addSubview(spinner)
        
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
        createStateLabelConstraints()
        createSpinnerConstraints()
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
    
    private func createStateLabelConstraints() {
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            stateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            stateLabel.leftAnchor.constraint(equalTo: leftAnchor),
            stateLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    private func createSpinnerConstraints() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 45),
            spinner.widthAnchor.constraint(equalToConstant: 45),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func displayStateLabel() {
        stateLabel.text = "No image found, try search something else!"
        stateLabel.isHidden = false
    }
    
// MARK: - Public
    
    public func refreshList() {
        if (datasource?.getImageCount() ?? 0) == 0 {
            displayStateLabel()
            collectionView.isHidden = true
        } else {
            stateLabel.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
    
    public func resetViewToTop() {
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    public func showSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.stateLabel.isHidden = true
            self.collectionView.isHidden = true
            self.spinner.startAnimating()
        }
    }
    
    public func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
            self.collectionView.isHidden = false
            self.spinner.stopAnimating()
        }
    }
}

extension ImageSearchView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        var thumbnail: UIImage?
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            thumbnail = cell.currentImage
        }
        delegate?.imageSelected(at: indexPath, thumbnail: thumbnail)
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
            return ImageCell()
        }
        let cell: ImageCell
        if let reuseCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell {
            cell = reuseCell
        } else {
            cell = ImageCell(frame: .zero)
        }
        
        //TODO: setup cell with image
        cell.imageUrl = imageModel.link ?? ""
        
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
