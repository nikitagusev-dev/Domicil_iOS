//
//  AdListViewCellStyle.swift
//  Domicil
//
//  Created by Никита Гусев on 22.04.2022.
//

import Foundation
import UIKit

struct AdListViewCellStyle {
    var price: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 18, weight: .bold)),
            .color(applicationColors.description)
        )
    }
    
    var roomsCount: StringStyle {
        description
    }
    
    var totalArea: StringStyle {
        description
    }
    
    var floor: StringStyle {
        description
    }
    
    var address: StringStyle {
        description
    }
    
    var selectedFavoriteButtonImage: UIImage {
        UIImage(systemName: "heart.fill")!
    }
    
    var notSelectedFavoriteButtonImage: UIImage {
        UIImage(systemName: "heart")!
    }
    
    var favoriteButtonTintColor: UIColor {
        applicationColors.red
    }
    
    var cellBackgroundColor: UIColor {
        applicationColors.mediumGray
    }
    
    var cellShadowColor: UIColor {
        applicationColors.description
    }
    
    var cellShadowRadius: CGFloat {
        4
    }
    
    var cellShadowOpacity: Float {
        0.5
    }
    
    var cellShadowOffset: CGSize {
        CGSize(width: 0, height: 1)
    }
    
    private var description: StringStyle {
        StringStyle(
            .font(.systemFont(ofSize: 14)),
            .color(applicationColors.description)
        )
    }
}
