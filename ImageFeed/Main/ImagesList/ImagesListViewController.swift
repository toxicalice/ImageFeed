//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alice on 03.05.2023.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var photos: [Photo] = []
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var imageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        
        imageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SingleImageViewController,
           let indexPath = sender as? IndexPath,
           segue.identifier == ShowSingleImageSegueIdentifier {
            let image = photos[indexPath.row].largeImageURL
            viewController.imageUrl = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        let oldPhotos = photos.count
        let newPhotos = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        guard newPhotos > 0 else { return }
        
        tableView.performBatchUpdates {
            
            var indexPaths: [IndexPath] = []
            
            for index in oldPhotos..<newPhotos {
                indexPaths.append(IndexPath(row: index , section: 0))
            }
            
            tableView.insertRows(at: indexPaths , with: .automatic)
        } completion: { _ in }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        imageListCell.configCell(tableView: tableView, photo: photos[indexPath.row], with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        let lastIndex = photos.count - 1
        
        if indexPath.row == lastIndex {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageWidth = imageSize.width
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
           guard let indexPath = tableView.indexPath(for: cell) else { return }
           let photo = photos[indexPath.row]
            ImagesListService.shared.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
                switch (result){
                case .success(_):
                    self.onLikeUpdated(photoId: photo.id)
                    cell.setIsLiked(isLiked: !photo.isLiked)
                case .failure(let error):
                    let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
                UIBlockingProgressHUD.dismiss()
            }
    }
    
    private func onLikeUpdated(photoId: String) {
        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
           let photo = self.photos[index]
           let newPhoto = Photo(
                    id: photo.id,
                    size: photo.size,
                    createdAt: photo.createdAt,
                    welcomeDescription: photo.welcomeDescription,
                    thumbImageURL: photo.thumbImageURL,
                    largeImageURL: photo.largeImageURL,
                    isLiked: !photo.isLiked
                )
            self.photos[index] = newPhoto
            
        }
    }
}

