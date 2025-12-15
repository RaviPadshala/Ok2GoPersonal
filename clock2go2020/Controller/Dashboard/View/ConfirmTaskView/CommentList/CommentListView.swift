//
//  CommentListView.swift
//  clock2go2020
//
//  Created by MacPro4 on 24.04.2021.
//

import UIKit

class CommentListView: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var selectCommentTitle: UILabel!

    // MARK: - Property
    var viewModel: CommentListViewModel?
    var selectedComment:((_ comment: String) -> Void)?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTaps()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configTableView()

        selectCommentTitle.text = "SELECT_COMMENT".localized
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    // MARK: - Public method
    func config(model: CommentListViewModel) {
        self.viewModel = model
    }

    private func setupTaps() {
        let closeTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        closeImage.addGestureRecognizer(closeTap)

        let backgroundTap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(backgroundTap)
    }

    @objc func dismissView() {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true, completion: nil)
        })
    }

    // MARK: - Private method
  private  func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self

    let cell = UINib(nibName: CommentListCellTableViewCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: CommentListCellTableViewCell.identifier)
    }

}

// MARK: - Extension CommentListView - Table View
extension CommentListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel?.commentArray?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentListCellTableViewCell.identifier, for: indexPath) as? CommentListCellTableViewCell

        cell?.commentLabel.text = String(viewModel?.commentArray?[indexPath.row] ?? 0)

        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let comment = viewModel?.commentArray?[indexPath.row] else { return  }
        selectedComment?(String(comment) )
    }
}
