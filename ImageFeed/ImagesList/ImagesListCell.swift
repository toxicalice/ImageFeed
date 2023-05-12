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
}
