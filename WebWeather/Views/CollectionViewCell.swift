//
//  CollectionViewCell.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var selectedStack: UIStackView!

    @IBOutlet private var dateLabel: UILabel!
    
    @IBOutlet private var shortImage: UIImageView!
    @IBOutlet private var shortTemp: UILabel!
    @IBOutlet private var shortCondition: UILabel!
    @IBOutlet private var shortView: UIView!

    @IBOutlet private var nightImage: UIImageView!
    @IBOutlet private var nightTemp: UILabel!
    @IBOutlet private var nightCondition: UILabel!
    
    @IBOutlet private var morningImage: UIImageView!
    @IBOutlet private var morningTemp: UILabel!
    @IBOutlet private var morningCondition: UILabel!
    
    @IBOutlet private var dayImage: UIImageView!
    @IBOutlet private var dayTemp: UILabel!
    @IBOutlet private var dayCondition: UILabel!
    
    @IBOutlet private var eveningImage: UIImageView!
    @IBOutlet private var eveningTemp: UILabel!
    @IBOutlet private var eveningCondition: UILabel!
    
    func configureCell(at index: Int, with forecast: DayForecastWeather) {
        setupTitleTabel()
        setupShortenedCell()
        setupExpandedCell()
        
        func setupTitleTabel() {
            switch index {
            case 0:
                dateLabel.text = "Сегодня".uppercased()
            case 1:
                dateLabel.text = "Завтра".uppercased()
            default:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateToConvert = dateFormatter.date(from: forecast.date)
                dateFormatter.dateFormat = "d MMMM"
                dateFormatter.locale = .current
                dateLabel.text = dateFormatter.string(from: dateToConvert ?? Date.now).uppercased()
            }
        }
        
        func setupShortenedCell() {
            let tempMin = [
                forecast.parts.night.tempAvg,
                forecast.parts.morning.tempAvg,
                forecast.parts.day.tempAvg,
                forecast.parts.evening.tempAvg
            ].min()?.temp() ?? ""
            let tempMax = [
                forecast.parts.night.tempAvg,
                forecast.parts.morning.tempAvg,
                forecast.parts.day.tempAvg,
                forecast.parts.evening.tempAvg
            ].max()?.temp() ?? ""
            
            //shortView.backgroundColor =
            shortImage.image = UIImage(systemName: forecast.parts.day.condition.image)?
                .withRenderingMode(.alwaysOriginal)
            shortTemp.text = tempMin + "..." + tempMax
            shortCondition.text = forecast.parts.day.condition.formatted
        }
        
        func setupExpandedCell() {
            nightImage.image = UIImage(
                systemName: forecast.parts.night.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            nightTemp.text = forecast.parts.night.tempAvg.temp()
            nightCondition.text = forecast.parts.night.condition.formatted
            
            morningImage.image = UIImage(
                systemName: forecast.parts.morning.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            morningTemp.text = forecast.parts.morning.tempAvg.temp()
            morningCondition.text = forecast.parts.morning.condition.formatted
            
            dayImage.image = UIImage(
                systemName: forecast.parts.day.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            dayTemp.text = forecast.parts.day.tempAvg.temp()
            dayCondition.text = forecast.parts.day.condition.formatted
            
            eveningImage.image = UIImage(
                systemName: forecast.parts.evening.condition.image
            )?.withRenderingMode(.alwaysOriginal)
            eveningTemp.text = forecast.parts.evening.tempAvg.temp()
            eveningCondition.text = forecast.parts.evening.condition.formatted
        }
    }
}
