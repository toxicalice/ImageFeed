//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alice on 06.05.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dataLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func configCell(photoName: String, with indexPath: IndexPath) {
        dataLabel.text = dateFormatter.string(from: Date())
        guard let image = UIImage(named: photoName) else { return }
        backgroundImageView.image = image
        
        if indexPath.row % 2 == 0 {
            likeButton.imageView?.image = UIImage(named: "Like")
        } else {
            likeButton.imageView?.image = UIImage(named: "Unlike")
        }
    }
}
