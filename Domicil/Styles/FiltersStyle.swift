//
//  FiltersStyle.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import BonMot
import UIKit

typealias StringStyle = BonMot.StringStyle

struct FiltersStyle {
    var header: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 14)),
            .color(applicationColors.header)
        )
    }
    
    var description: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16)),
            .color(applicationColors.description)
        )
    }
    
    var enabledButtonColor: UIColor {
        applicationColors.red
    }
    
    var disabledButtonColor: UIColor {
        applicationColors.disabled
    }
    
    var roomButtonTitle: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 14)),
            .color(applicationColors.white)
        )
    }
    
    var confirmButtonTitle: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16, weight: .medium)),
            .color(applicationColors.white)
        )
    }
    
    var roomButtonCornerRadius: CGFloat {
        15
    }
    
    var confirmButtonCornerRadius: CGFloat {
        25
    }
}
