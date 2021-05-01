//
//  ImageSearchController.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

import Foundation
import UIKit
import AlamofireImage

class ImageSearchController: UIViewController {
    private let imgurService: IImgurService
    
    private var imageResults = [ImageModel]()
    
    private var searchController: UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    
    public var contentView: ImageSearchView? {
        return view as? ImageSearchView
    }
    
    init(imgurService: IImgurService = ImgurService()) {
        self.imgurService = imgurService
        super.init(nibName: nil, bundle: nil)
        
        searchController.searchResultsUpdater = self
        contentView?.delegate = self
        contentView?.datasource = self
    }
    
    required init?(coder: NSCoder) {
        print("Does not support storyboards")
        return nil
    }
    
    override func loadView() {
        view = ImageSearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Image Search"
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let imageDownloader = UIImageView.af.sharedImageDownloader
        imageDownloader.imageCache?.removeAllImages()
    }
}

extension ImageSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else { return }
        imgurService.searchImage(queryString: query) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let images):
                self.imageResults = images
                DispatchQueue.main.async {
                    self.contentView?.refreshList()
                }
            case .failure(let apiError):
                self.displayError(apiError)
            }
        }
    }
    
    private func displayError(_ apiError: ApiError) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        let alertVC = UIAlertController(title: "Something went wrong", message: apiError.localizedDescription, preferredStyle: .alert)
        
        alertVC.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
}

extension ImageSearchController: ImageSearchViewDatasource {
    func getImageCount() -> Int {
        imageResults.count
    }
    
    func getImage(at indexPath: IndexPath) -> ImageModel? {
        if imageResults.indices.contains(indexPath.row) {
            return imageResults[indexPath.row]
        }
        
        return nil
    }
}

extension ImageSearchController: ImageSearchViewDelegate {
    func imageSelected(at indexPath: IndexPath) {
        
        //TODO handle image selected
    }
}
