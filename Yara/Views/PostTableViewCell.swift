//
//  PostTableViewCell.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/28/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import UIKit

protocol ImageLoaderDelegate:class {
    func thumbnail(for link: Link, completion: @escaping ((Result<UIImage, Error>) -> Void))
}

class PostTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "PostTableViewCell"
    static let maxImageWidth: CGFloat = 120

    @IBOutlet var containerView: UIView!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var thumbnailWidthConstraint: NSLayoutConstraint!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var upvotesLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!

    weak var delegate:ImageLoaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        style()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // clean up your outlets
        thumbnailImageView.image = nil
        titleLabel.text = nil
        upvotesLabel.text = nil
        commentsLabel.text = nil
    }

    private func style() {
        titleLabel.textColor = Style.Color.darkText
        upvotesLabel.textColor = Style.Color.lightText
        commentsLabel.textColor = Style.Color.lightText
        
        backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = Style.Color.borderGray.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 2.0

    }

    func configure(with link: Link, delegate: ImageLoaderDelegate?) {
        self.delegate = delegate
        titleLabel.text = link.title
        upvotesLabel.text = String(format: NSLocalizedString("%d upvotes", comment: "number of upvotes for a link"), link.upvotes)
        commentsLabel.text = String(format: NSLocalizedString("%d comments", comment: "number of comments for a link"), link.numComments)
        delegate?.thumbnail(for: link, completion: { [weak self] (result) in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    strongSelf.thumbnailImageView.image = image
                    strongSelf.thumbnailImageView.layer.cornerRadius = 5.0
                    strongSelf.thumbnailImageView.layer.masksToBounds = true
                    strongSelf.thumbnailImageView.isHidden = false
                    strongSelf.thumbnailWidthConstraint.constant = min(image.size.width, PostTableViewCell.maxImageWidth)
                case .failure:
                    // had a problem getting the thumbnail, hide the image
                    strongSelf.thumbnailImageView.isHidden = true
                    strongSelf.thumbnailWidthConstraint.constant = 0
                }
                strongSelf.layoutIfNeeded()
            }

        })
    }
    
}
