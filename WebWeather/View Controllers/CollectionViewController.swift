//
//  CollectionViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import UIKit

protocol MainViewControllerDelegate: AnyObject {
    func updateForecast(with forecasts: [DayForecastWeather])
}

final class CollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    private var cellsIsSelected = Array(repeating: false, count: 7)
    private var forecasts: [DayForecastWeather] = []
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath)
        
        guard let cell = cell as? CollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(
            at: indexPath.item,
            with: forecasts[indexPath.item]
        )
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        
        collectionView.performBatchUpdates {
            collectionView.isScrollEnabled.toggle()
            cellsIsSelected[indexPath.item].toggle()
        }
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView.performBatchUpdates {
            UIView.transition(
                with: cell,
                duration: 0.25,
                options: .transitionCrossDissolve
            ) {
                cell.selectedStack.alpha = cell.selectedStack.alpha == 0 ? 1 : 0
            }
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellsIsSelected[indexPath.item]
        ? CGSize(width: view.bounds.width - 32, height: view.bounds.height)
        : CGSize(width: 150, height: view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

// MARK: - MainViewControllerDelegate
extension CollectionViewController: MainViewControllerDelegate {
    func updateForecast(with forecasts: [DayForecastWeather]) {
        self.forecasts = forecasts
        collectionView.reloadData()
    }
}


