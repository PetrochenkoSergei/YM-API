//
//  RadioCVCell.swift
//  Rave
//
//  Created by Developer on 27.08.2021.
//

import UIKit

class RadioCVCell: UICollectionViewCell {

    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var imgView_stationIcon: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.layer.cornerRadius = innerView.frame.width / 2
    }
    
    func initializeCell(innerViewBgColor: UIColor, stationImg: UIImage?, title: String)
    {
        innerView.backgroundColor = innerViewBgColor
        if let g_img = stationImg {
            imgView_stationIcon.image = g_img
        } else {
            imgView_stationIcon.image = UIImage(named: "radio_template")
        }
        lbl_title.text = title
    }
}
