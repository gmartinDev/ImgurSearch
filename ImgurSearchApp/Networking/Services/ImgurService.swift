//
//  ImgurServices.swift
//  ImgurSearchApp
//
//  Created by Greg Martin on 4/30/21.
//

protocol IImgurService: AnyObject {
    func searchImage(queryString: String, completion: @escaping (Result<[ImageModel], ApiError>) -> Void)
}

class ImgurService: IImgurService {
    func searchImage(queryString: String, completion: @escaping (Result<[ImageModel], ApiError>) -> Void) {
        let api = ImageEndpoint()
        let apiRequestLoader = ImageApiLoader(apiRequest: api)
        let parameters = [
            "q": queryString,
            "q_type": "jpg | png"
        ]
        
        apiRequestLoader.loadRequest(requestData: parameters) { (result) in
            switch result {
            case .success(let galleries):
                let images = galleries.flatMap { gallery in
                    gallery.images
                }
                completion(.success(images))
            case .failure(let apiError):
                completion(.failure(apiError))
            }
        }
    }
}
