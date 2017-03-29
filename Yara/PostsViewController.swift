//
//  PostsViewController.swift
//  Yara
//
//  Created by Ryan Grigsby on 3/24/17.
//  Copyright © 2017 Grigs-b. All rights reserved.
//

import UIKit
import SafariServices

class PostsViewController: UIViewController {


    @IBOutlet var tableView: UITableView!
    let subreddit: String = "Charlottesville"
    let api: RedditAPIClient = RedditAPIClient()
    var data: [Listing] = []
    var query: SubredditQuery = SubredditQuery()
    var currentTask: URLSessionDataTask?
    var after: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        loadListing()
        setupTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentTask?.cancel()
    }

    private func loadListing() {
        query = SubredditQuery(subreddit)
        currentTask = api.getListing(query) { [weak self]
            result in
            guard let strongSelf = self else { return }

            strongSelf.handleListingDidLoad(result)
        }
    }

    private func handleListingDidLoad(_ result: Result<ListingContainer, Error>) {
        switch result {
        case .success(let container):

            data += container.children
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.currentTask = nil
                //todo: continuous fetching as user scrolls
                //self.query = SubredditQuery(subreddit, after: container.after)
            }
        case .failure(let error):
            DispatchQueue.main.async {
                print(error.localizedDescription)
                self.present(self.errorAlertController(), animated: true, completion: nil)
            }
        }
    }

    private func setupTableView() {
        // register our nibs used for our cells
        let nib = UINib(nibName: String(describing: PostTableViewCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)

        // allow our cells to be dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        // style it a bit
        tableView.backgroundView = nil
        tableView.backgroundColor = Style.Color.lightGray
    }

    private func errorAlertController() -> UIViewController {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error title when failed to load content"),
                                                message: NSLocalizedString("There was a problem loading content from Reddit", comment: "Error message when failed to load content"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Darn", comment: "OK Button"), style: .cancel, handler: nil))
        return alertController
    }

}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier) as! PostTableViewCell

        let listing = data[indexPath.row]
        if let link = listing.data as? Link {
            cell.configure(with: link, delegate: self)
        }
        return cell
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let listing = data[indexPath.row]
        if let link = listing.data as? Link,
            let url = URL(string: link.url) {

            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}

extension PostsViewController: ImageLoaderDelegate {
    func thumbnail(for link: Link, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        guard let thumbnail = link.thumbnail, !link.isSelf,
            let url = URL(string:thumbnail) else {
            completion(.failure(ModelError.noData))
            return
        }
        api.getImage(url, completion: completion)
    }
}
