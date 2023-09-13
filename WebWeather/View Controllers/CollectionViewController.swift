//
//  CollectionViewController.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import UIKit

final class CollectionViewController: UICollectionViewController {
    private var cellsIsSelected = Array(repeating: false, count: 7)

    private var forecasts: [DayForecastWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateForecastWeather()
    }
}

// MARK: UICollectionViewDataSource
extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath)
        
        guard let cell = cell as? CollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.item {
        case 0:
            cell.dateLabel.text = "Сегодня".uppercased()
        case 1:
            cell.dateLabel.text = "Завтра".uppercased()
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateToConvert = dateFormatter.date(from: forecasts[indexPath.item].date)
            dateFormatter.dateFormat = "d MMMM"
            dateFormatter.locale = .current
            cell.dateLabel.text = dateFormatter.string(from: dateToConvert ?? Date.now).uppercased()
        }
        
        let tempMin = [
            forecasts[indexPath.item].parts.night.tempAvg,
            forecasts[indexPath.item].parts.morning.tempAvg,
            forecasts[indexPath.item].parts.day.tempAvg,
            forecasts[indexPath.item].parts.evening.tempAvg
        ].min()?.temp() ?? ""
        let tempMax = [
            forecasts[indexPath.item].parts.night.tempAvg,
            forecasts[indexPath.item].parts.morning.tempAvg,
            forecasts[indexPath.item].parts.day.tempAvg,
            forecasts[indexPath.item].parts.evening.tempAvg
        ].max()?.temp() ?? ""
        
        cell.shortImage.image = UIImage(
            systemName: forecasts[indexPath.item]
                .parts
                .day
                .condition
                .image
        )?.withRenderingMode(.alwaysOriginal)
        cell.shortTemp.text = tempMin + "..." + tempMax
        cell.shortCondition.text = forecasts[indexPath.item].parts.day.condition.formatted
//        cell.shortView.backgroundColor
        
        cell.nightImage.image = UIImage(
            systemName: forecasts[indexPath.item]
                .parts
                .night
                .condition
                .image
        )?.withRenderingMode(.alwaysOriginal)
        cell.nightTemp.text = forecasts[indexPath.item]
            .parts
            .night
            .tempAvg
            .temp()
        cell.nightCondition.text = forecasts[indexPath.item]
            .parts
            .night
            .condition
            .formatted
        
        cell.morningImage.image = UIImage(
            systemName: forecasts[indexPath.item]
                .parts
                .morning
                .condition
                .image
        )?.withRenderingMode(.alwaysOriginal)
        cell.morningTemp.text = forecasts[indexPath.item]
            .parts
            .morning
            .tempAvg
            .temp()
        cell.morningCondition.text = forecasts[indexPath.item]
            .parts
            .morning
            .condition
            .formatted
        
        cell.dayImage.image = UIImage(
            systemName: forecasts[indexPath.item]
                .parts
                .day
                .condition
                .image
        )?.withRenderingMode(.alwaysOriginal)
        cell.dayTemp.text = forecasts[indexPath.item]
            .parts
            .day
            .tempAvg
            .temp()
        cell.dayCondition.text = forecasts[indexPath.item]
            .parts
            .day
            .condition
            .formatted
        
        cell.eveningImage.image = UIImage(
            systemName: forecasts[indexPath.item]
                .parts
                .evening
                .condition
                .image
        )?.withRenderingMode(.alwaysOriginal)
        cell.eveningTemp.text = forecasts[indexPath.item]
            .parts
            .evening
            .tempAvg
            .temp()
        cell.morningCondition.text = forecasts[indexPath.item]
            .parts
            .evening
            .condition
            .formatted
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension CollectionViewController {
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
extension CollectionViewController {
    func updateForecastWeather() {
        NetworkManager.shared.fetchWeather(from: RequestURL.getURL()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.forecasts = weather.forecasts
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }    }
}


