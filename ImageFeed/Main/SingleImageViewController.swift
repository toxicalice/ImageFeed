//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alice on 10.05.2023.
//

import Foundation
import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var imageUrl: String?
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let shareController = UIActivityViewController(activityItems: [imageView.image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        updateImage()
    }
    
    private func updateImage() {
        if let imageUrl = imageUrl {
            UIBlockingProgressHUD.show()
            imageView.kf.setImage(with: URL(string: imageUrl)) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure:
                    self.showError()
                }
            }
        }
    }
    
    private func showError(){
        let alert = UIAlertController(title: "Что-то пошло не так(", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Не надо", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { _ in self.updateImage() }))
        self.present(alert, animated: true)
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



