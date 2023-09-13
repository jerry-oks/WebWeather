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
}
