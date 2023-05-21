//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alice on 06.05.2023.
//

import Foundation
import UIKit
import Kingfisher


protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    weak var delegate: ImagesListCellDelegate?

    
    @IBAction func onLikeButtonClick(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        if isLiked {
            likeButton.imageView?.image = UIImage(named: "Like")
        } else {
            likeButton.imageView?.image = UIImage(named: "Unlike")
        }
        
    }
    
    func configCell(tableView: UITableView, photo: Photo, with indexPath: IndexPath) {
        if let createdAt = photo.createdAt {dataLabel.text = dateFormatter.string(from: createdAt)}
        
        backgroundImageView.kf.setImage(with: URL(string: photo.thumbImageURL), placeholder: UIImage(named: "Placeholder_image_list")) {_ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        backgroundImageView.kf.indicatorType = .activity
    
        setIsLiked(isLiked: photo.isLiked)
    }
}


