//
//  PostTableViewCell.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/28/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import UIKit

protocol ImageLoaderDelegate:class {
    func thumbnail(for: Link, completion: ((UIImage?) -> Void))
}

class PostTableViewCell: UITableViewCell {

    static let reuseIdentifier: String = "PostTableViewCell"

    @IBOutlet var thumbnailImageView: UIImageView!
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
        // do some styling stuff here
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with link: Link, delegate: ImageLoaderDelegate?) {
        self.delegate = delegate
        titleLabel.text = link.title
        upvotesLabel.text = String(format: NSLocalizedString("%d upvotes", comment: "number of upvotes for a link"), link.upvotes)
        commentsLabel.text = String(format: NSLocalizedString("%d comments", comment: "number of comments for a link"), link.numComments)
        delegate?.thumbnail(for: link, completion: { [weak self] (image) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.thumbnailImageView.image = image
            }
        })
    }
    
}
