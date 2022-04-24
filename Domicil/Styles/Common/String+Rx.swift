//
//  String+Rx.swift
//  Domicil
//
//  Created by Никита Гусев on 22.04.2022.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequence where Element == String {
    func mapStyle(_ style: StringStyle) -> SharedSequence<SharingStrategy, NSAttributedString> {
        self
            .asSharedSequence()
            .map { $0.styled(with: style) }
    }
}

extension SharedSequence where Element == String? {
    func mapStyle(_ style: StringStyle) -> SharedSequence<SharingStrategy, NSAttributedString?> {
        self
            .asSharedSequence()
            .map { $0?.styled(with: style) }
    }
}
