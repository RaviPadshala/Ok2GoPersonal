//
//  TaskBarView.swift
//  clock2go2020
//
//  Created by Admin on 1/4/20.
//

import UIKit

class TaskBarView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var taskView: UIView!
    @IBOutlet var taskCollectionView: UICollectionView!
    @IBOutlet weak var healthImage: UIImageView!
    @IBOutlet var selectedTaskNameButton: UIButton!

    let colapsedViewHeight = CGFloat(50)
    let expandedViewHeight = CGFloat(70)

    let viewModel = TaskBarViewModel()

    weak var delegate: TaskBarViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TaskBarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupUI()
        setupCollectionView()
        updateSelectedItemView()
//        setupTap()
    }

    func reloadView() {
        viewModel.refreshData()
        setupUI()
        config()
        taskCollectionView.reloadData()
    }

    func config() {
        contentView.isUserInteractionEnabled = true
        contentView.alpha = 1
    }

    func setupUI() {
        // self.isHidden = !viewModel.hasItems()

        taskCollectionView.semanticContentAttribute = .forceRightToLeft

        taskView.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        taskView.shadow(CGSize(width: 0, height: 10), opacity: 0.2, radius: 5, color: #colorLiteral(red: 0.6181033129, green: 0.630385781, blue: 0.6499643084, alpha: 1))

        selectedTaskNameButton.isHidden = true
    }

    func setupCollectionView() {
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self

        let nib = UINib(nibName: "TaskBarCollectionViewCell", bundle: nil)
        taskCollectionView.register(nib, forCellWithReuseIdentifier: TaskBarCollectionViewCell.identifier)
    }

    func updateSelectedItemView() {
        if self.viewModel.hasSelectedItem(), (self.viewModel.getSelectedItemTitle() != "" || self.viewModel.getHealthDisclaimerImage() != nil) {
            self.selectedTaskNameButton.isHidden = false
            self.healthImage.isHidden = false
            self.selectedTaskNameButton.setTitle(self.viewModel.getSelectedItemTitle(), for: .normal)

            self.contentView.frame.size.height = expandedViewHeight
        } else {
            self.healthImage.isHidden = true
            self.selectedTaskNameButton.isHidden = true
            self.selectedTaskNameButton.setTitle("", for: .normal)

            self.contentView.frame.size.height = colapsedViewHeight
        }

        self.healthImage.image = self.viewModel.getHealthDisclaimerImage()
    }

    @IBAction func taskNameAction(_ sender: Any) {
        guard viewModel.shouldShowMapView() else { return }

        if let task = viewModel.selectedItem {
            delegate?.userDidTapLocation(task)
        }
    }

}

extension TaskBarView: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskBarCollectionViewCell.identifier, for: indexPath) as? TaskBarCollectionViewCell,
            let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row) {

            // Menu item.
            cell.configure(viewModel: cellViewModel)

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(viewModel.getModelForItemAt(index: indexPath.row)?.item.isSelected ?? false) {
            viewModel.setTaskBarItemSelected(index: indexPath.row)
            collectionView.reloadData()

//            if let task = viewModel.selectedItem {
//                delegate?.usrDidTapLocation(task)
//            }
        } else {
            viewModel.setAllTaskBarItemUnselected()
            viewModel.setAllTaskBarItemActive()
            collectionView.reloadData()
        }
        updateSelectedItemView()
        delegate?.userDidTapTask()
    }
}

protocol TaskBarViewDelegate: NSObjectProtocol {
    func userDidTapLocation(_ task: TaskBarItem)
    func userDidTapTask()
}
