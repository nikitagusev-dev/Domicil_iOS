//
//  TabBarStyle.swift
//  Domicil
//
//  Created by Никита Гусев on 12.04.2022.
//

import Foundation
import UIKit

struct BarStyle {
    var backgroundColor: UIColor {
        applicationColors.lightGray
    }
    
    var searchTabImage: UIImage {
        UIImage(systemName: "magnifyingglass")!
    }
    
    var favoritesTabImage: UIImage {
        UIImage(systemName: "heart")!
    }
    
    var barTintColor: UIColor {
        applicationColors.red
    }
}
