//
//  SelfLocationTableViewCell.swift
//  MyWeatherApp
//
//  Created by Suresh on 29/03/23.
//

import UIKit

class SelfLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configure() {
        self.locationLabel.text = "Use current location".localize
    }
}
