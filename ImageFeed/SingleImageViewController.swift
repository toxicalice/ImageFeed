//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alice on 10.05.2023.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
        guard isViewLoaded else { return }
        imageView.image = image
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
           super.viewDidLoad()
           imageView.image = image
       }
}
