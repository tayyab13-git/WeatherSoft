//
//  infoCollectionViewCell.swift
//  WeatherSoft
//
//  Created by Max on 03/09/2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit

class infoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func generateCell(weatherInfo: WeatherInfo)
    {
        infoLabel.text = weatherInfo.infoText
        infoLabel.adjustsFontSizeToFitWidth = true
        
        if weatherInfo.imageLabel != nil {
            nameLabel.isHidden = true
            infoImageView.isHidden = false
            infoImageView.image = weatherInfo.imageLabel
        }
        else
        {
            nameLabel.isHidden = false
            infoImageView.isHidden = true
            nameLabel.adjustsFontSizeToFitWidth = true
            nameLabel.text = weatherInfo.nameText
        }
    }
}
