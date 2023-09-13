//
//  CollectionViewCell.swift
//  WebWeather
//
//  Created by HOLY NADRUGANTIX on 12.09.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var shortImage: UIImageView!
    @IBOutlet var shortTemp: UILabel!
    @IBOutlet var shortCondition: UILabel!
    @IBOutlet var shortView: UIView!
    
    @IBOutlet var selectedStack: UIStackView!
    
    @IBOutlet var nightImage: UIImageView!
    @IBOutlet var nightTemp: UILabel!
    @IBOutlet var nightCondition: UILabel!
    
    @IBOutlet var morningImage: UIImageView!
    @IBOutlet var morningTemp: UILabel!
    @IBOutlet var morningCondition: UILabel!
    
    @IBOutlet var dayImage: UIImageView!
    @IBOutlet var dayTemp: UILabel!
    @IBOutlet var dayCondition: UILabel!
    
    @IBOutlet var eveningImage: UIImageView!
    @IBOutlet var eveningTemp: UILabel!
    @IBOutlet var eveningCondition: UILabel!
    
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
            
            shortImage.image = UIImage(systemName: forecast.parts.day.condition.image)?
                .withRenderingMode(.alwaysOriginal)
            shortTemp.text = tempMin + "..." + tempMax
            shortCondition.text = forecast.parts.day.condition.formatted
          //shortView.backgroundColor =
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
