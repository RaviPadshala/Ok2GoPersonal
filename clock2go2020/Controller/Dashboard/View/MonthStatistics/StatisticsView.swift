//
//  StatisticsView.swift
//  clock2go2020
//
//  Created by Admin on 1/3/20.
//

import UIKit

class StatisticsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var collectionView: UICollectionView!

    var viewModel = StatisticsViewModel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("StatisticsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds

        setupCollectionView()
    }

    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let nib = UINib(nibName: "StatisticsViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: StatisticsViewCell.identifier)
    }

    func reloadView() {
        self.viewModel.refreshData()
        self.collectionView.reloadData()
        if viewModel.getNumberOfCells() > 0 {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }

}

extension StatisticsView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsViewCell.identifier, for: indexPath) as? StatisticsViewCell,

            let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row) {

            // Menu item.
            cell.configure(viewModel: cellViewModel)

            cell.backTapped = {
                let index = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }

            cell.forwardTapped = {
                let index = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            }

            return cell
        }

        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let statisticsCell = cell as? StatisticsViewCell {
            statisticsCell.setLabels()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectMonthAt(index: indexPath.row)
    }

}

extension StatisticsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cellViewModel = viewModel.getModelForItemAt(index: indexPath.row) {
            return cellViewModel.cellSize
        }
        return .zero
    }
}
