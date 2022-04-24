//
//  AdDetailsStyle.swift
//  Domicil
//
//  Created by Никита Гусев on 24.04.2022.
//

import Foundation
import UIKit

struct AdDetailsStyle {
    var selectedFavoriteButtonImage: UIImage {
        UIImage(systemName: "heart.fill")!
    }
    
    var notSelectedFavoriteButtonImage: UIImage {
        UIImage(systemName: "heart")!
    }
    
    var favoriteButtonTintColor: UIColor {
        applicationColors.red
    }
    
    var header: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16)),
            .color(applicationColors.header)
        )
    }
    
    var parameter: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16)),
            .color(applicationColors.header)
        )
    }
    
    var price: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 18, weight: .bold)),
            .color(applicationColors.description)
        )
    }
    
    var roomsCount: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 18, weight: .bold)),
            .color(applicationColors.description)
        )
    }
    
    var address: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 18)),
            .color(applicationColors.description)
        )
    }
    
    var description: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16)),
            .color(applicationColors.description)
        )
    }
    
    var separatorBackgroundColor: UIColor {
        applicationColors.mediumGray
    }
    
    var openAdButtonCornerRadius: CGFloat {
        25
    }
    
    var openAdButtonTitle: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 16, weight: .medium)),
            .color(applicationColors.white)
        )
    }
    
    var openAdButtonBackgroundColor: UIColor {
        applicationColors.red
    }
}
