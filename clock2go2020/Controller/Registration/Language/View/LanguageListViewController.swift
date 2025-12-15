//
//  LanguageListViewController.swift
//  clock2go2020
//
//  Created by Admin on 12/22/19.
//

import UIKit

class LanguageListViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var languageTableView: UITableView!
    @IBOutlet weak var languageTableViewHeightConstraint: NSLayoutConstraint!

    weak var delegate: LanguageListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
        setupTaps()
    }

    func setupUI() {
        languageTableView.roundCorners([.allCorners], radius: 30.0)
        languageTableView.clipsToBounds = true

        languageTableViewHeightConstraint.constant = CGFloat(LanguageEntity.allCases.count * 50)
    }

    func setupTableView() {
        languageTableView.delegate = self
        languageTableView.dataSource = self

        let cell = UINib(nibName: LanguageListCellTableViewCell.identifier, bundle: nil)
        languageTableView.register(cell, forCellReuseIdentifier: LanguageListCellTableViewCell.identifier)
    }

    func setupTaps() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
        backgroundView.addGestureRecognizer(tap)
    }

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)

    }

}

extension LanguageListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageEntity.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageListCellTableViewCell.identifier) as! LanguageListCellTableViewCell
        cell.languageImage.image = LanguageEntity(rawValue: indexPath.row)?.languageImage
        cell.languageTitle.text = LanguageEntity(rawValue: indexPath.row)?.languageTitle

        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.init().hexStringToUIColor(hex: "#E4EDFA")
        cell.selectedBackgroundView = customColorView

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
            
      
            if let lang = LanguageEntity(rawValue: indexPath.row)?.idetifier {
                UserDefaultsManager.appleLanguagesNew = [lang]
                self.delegate?.userDidTapLanguage(indexPath.row)
            }
            self.dismissView()
        
        
        
    }
   
}

protocol LanguageListDelegate: NSObjectProtocol {
    func userDidTapLanguage(_ row: Int)
}
