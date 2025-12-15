//
//  NotificationView.swift
//  clock2go2020
//
//  Created by Admin on 2/10/20.
//

import UIKit

class NotificationView: UIView {

    // MARK: Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var notificationTitleView: UIView!
    @IBOutlet weak var notificationTitle: UILabel!

    @IBOutlet weak var removeStackView: UIStackView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var removeTitle: UILabel!

    @IBOutlet weak var selectStackView: UIStackView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectTitle: UILabel!

    @IBOutlet weak var notificationCollection: UICollectionView!

    var viewModel = NotificationViewModel()
    var dataSource: NotificationCellViewModel!

    // MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("NotificationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupCollection()
        setupLocalized()
        updateDeleteButton()
        updateSelectedButton()
    }

    func setupUI() {
        notificationTitleView.roundCorners([.bottomRight, .bottomLeft], radius: 30)
        notificationTitleView.shadow(CGSize(width: 0, height: 5), opacity: 0.15, radius: 4, color: #colorLiteral(red: 0.08268459886, green: 0.2809937894, blue: 0.4637595415, alpha: 0.5))
    }

    func setupLocalized() {
        removeTitle.text = "DELETE".localized
        selectTitle.text = "SELECT_ALL".localized
        notificationTitle.text = viewModel.getNotificationTitle()
    }

    func setupCollection() {
        
        notificationCollection.delegate = self
        notificationCollection.dataSource = self

        let nib = UINib(nibName: "NotificationViewCell", bundle: nil)
        notificationCollection.register(nib, forCellWithReuseIdentifier: NotificationViewCell.identifier)

        if let collectionViewLayout = notificationCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

    }

    func reloadView() {
        
        viewModel.loadNotifications()
        updateSelectedButton()
        notificationTitle.text = viewModel.getNotificationTitle()
        notificationCollection.reloadData()
        
    }

    func updateSelectedButton() {
        
        let alpha: CGFloat = viewModel.shouldDisableSelectButton() ? 0.5 : 1.0
        selectButton.alpha = alpha
        selectTitle.textColor = #colorLiteral(red: 0.06274509804, green: 0.2823529412, blue: 0.462745098, alpha: 1).withAlphaComponent(alpha)
        selectStackView.isUserInteractionEnabled = viewModel.shouldDisableSelectButton() ? false : true

        if let image = viewModel.getSelectionImage() {
            selectButton.setImage(image, for: .normal)
        }
        notificationCollection.reloadData()
        
    }

    func updateDeleteButton() {
        let alpha: CGFloat = viewModel.shouldDisableDeleteButton() ? 0.5 : 1.0
        removeButton.alpha = alpha
        removeTitle.textColor = #colorLiteral(red: 1, green: 0.3137254902, blue: 0.3137254902, alpha: 1).withAlphaComponent(alpha)
        removeStackView.isUserInteractionEnabled = viewModel.shouldDisableDeleteButton() ? false : true
    }

    @IBAction func deleteAction(_ sender: Any) {
        viewModel.removeSelectedNotification()
        viewModel.loadNotifications()
        notificationCollection.reloadData()
        notificationTitle.text = viewModel.getNotificationTitle()
        updateDeleteButton()
        updateSelectedButton()
    }

    @IBAction func selectAction(_ sender: Any) {
        viewModel.changeAllSelection()
        updateSelectedButton()
        updateDeleteButton()
    }

}

extension NotificationView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfNotifications()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationViewCell.identifier, for: indexPath) as? NotificationViewCell {

            cell.configure(model: viewModel.getModelFor(index: indexPath.row))

            cell.selectedAction = {
                self.viewModel.changeSelections(value: indexPath.row)
                self.updateSelectedButton()
                self.updateDeleteButton()
            }

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectNotificationAtIndex(indexPath.row)
    }

// func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//    return   CGSize(width: self.bounds.width, height:90)
//
//    }
   }
