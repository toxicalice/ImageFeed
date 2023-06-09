//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alice on 10.05.2023.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var image: UIImage! {
        didSet {
        guard isViewLoaded else { return }
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
           super.viewDidLoad()
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 1.25
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
            
       }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
}

    extension SingleImageViewController: UIScrollViewDelegate {
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


   
