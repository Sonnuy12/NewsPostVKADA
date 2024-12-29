//
//  AddLabel.swift
//  NewsPostVKADA
//
//  Created by Дима Люфт on 21.12.2024.
//

import UIKit

protocol SetupLabel:UILabel {
    var fontText: CGFloat {get}
    var fontW: UIFont.Weight {get}
    var colorText: UIColor {get}
}

class AddLabel: UILabel, SetupLabel {
    var fontText: CGFloat
    var fontW: UIFont.Weight
    var colorText: UIColor
    
    init(fontText: CGFloat, fontW: UIFont.Weight, colorText: UIColor) {
        self.fontText = fontText
        self.fontW = fontW
        self.colorText = colorText
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: fontText, weight: fontW)
        textColor = colorText
        numberOfLines = 0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

