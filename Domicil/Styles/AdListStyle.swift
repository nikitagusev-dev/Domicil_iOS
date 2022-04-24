//
//  AdListStyle.swift
//  Domicil
//
//  Created by Никита Гусев on 23.04.2022.
//

import Foundation
import UIKit

struct AdListStyle {
    var placeholder: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 18)),
            .color(applicationColors.disabled),
            .alignment(.center),
            .lineHeightMultiple(1.5)
        )
    }
    
    var filtersImage: UIImage {
        UIImage(systemName: "slider.horizontal.3")!
    }
    
    var filtersImageTintColor: UIColor {
        applicationColors.red
    }
}
