//
//  LocalStorageService.swift
//  Domicil
//
//  Created by Никита Гусев on 09.04.2022.
//

import Foundation
import CoreData
import RxCocoa

protocol LocalStorageServiceType {
    var favoriteAds: Driver<[PreviewAd]> { get }
    
    func toggleStoring(of favoriteAd: PreviewAd)
    func add(favoriteAd: PreviewAd)
    func remove(favoriteAd: PreviewAd)
}

final class LocalStorageService: LocalStorageServiceType {
    var favoriteAds: Driver<[PreviewAd]> {
        adFRC.result
            .map { $0.compactMap(PreviewAd.init) }
    }
    
    private let context: NSManagedObjectContext
    private let adFRC: FetchedResultsController<Ad>

    init() {
        let persistentContainer = NSPersistentContainer(name: "Domicil")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Can't find persistent container: error \(error), \(error.userInfo)")
            }
        }
        context = persistentContainer.viewContext
        adFRC = Self.makeAdFRC(context: context)
    }
    
    func toggleStoring(of favoriteAd: PreviewAd) {
        if let existingAd = getIfExists(ad: favoriteAd) {
            context.delete(existingAd)
            try? context.save()
        } else {
            _ = Ad(context: context, previewAd: favoriteAd)
            try? context.save()
        }
    }
    
    func add(favoriteAd: PreviewAd) {
        if getIfExists(ad: favoriteAd) == nil {
            _ = Ad(context: context, previewAd: favoriteAd)
            try? context.save()
        }
    }
    
    func remove(favoriteAd: PreviewAd) {
        if let ad = getIfExists(ad: favoriteAd) {
            context.delete(ad)
        }
    }
}

// MARK: - Private methods
private extension LocalStorageService {
    static func makeAdFRC(context: NSManagedObjectContext) -> FetchedResultsController<Ad> {
        let fetchRequest = Ad.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Ad.sourceUrl), ascending: true)]
        return FetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context)
    }
    
    func getIfExists(ad: PreviewAd) -> Ad? {
        guard let nsUrl = NSURL(string: ad.sourceUrl.absoluteString) else {
            return nil
        }
        
        let request = Ad.fetchRequest()
        request.predicate = NSPredicate(format: "sourceUrl = %@", nsUrl)
        return (try? context.fetch(request))?.first
    }
}

private extension PreviewAd {
    init?(from ad: Ad) {
        guard let rawAccommodationKind = ad.accommodationKind,
              let accomodationKind = AccommodationKind(rawValue: rawAccommodationKind),
              let rawTransactionKind = ad.transactionKind,
              let transactionKind = TransactionKind(rawValue: rawTransactionKind),
              let rawSourceKind = ad.sourceKind,
              let sourceKind = SourceKind(rawValue: rawSourceKind),
              let sourceUrlString = ad.sourceUrl,
              let sourceUrl = URL(string: sourceUrlString)
        else {
            return nil
        }
        
        self.accommodationKind = accomodationKind
        self.transactionKind = transactionKind
        self.sourceKind = sourceKind
        self.sourceUrl = sourceUrl
        roomsCount = Int(ad.roomsCount)
        partOfTown = ad.partOfTown ?? ""
        totalArea = Int(ad.totalArea)
        floor = Int(ad.floor)
        numberOfFloors = Int(ad.numberOfFloors)
        price = Int(ad.price)
        
        if let imageUrl = ad.imageUrl {
            self.imageUrl = URL(string: imageUrl)
        } else {
            self.imageUrl = nil
        }
        
        if let street = ad.street, let houseNumber = ad.houseNumber {
            address = AdAddress(street: street, houseNumber: houseNumber)
        } else {
            address = nil
        }
    }
}

private extension Ad {
    convenience init(context: NSManagedObjectContext, previewAd: PreviewAd) {
        self.init(context: context)
        
        accommodationKind = previewAd.accommodationKind.rawValue
        transactionKind = previewAd.transactionKind.rawValue
        sourceKind = previewAd.sourceKind.rawValue
        roomsCount = Int32(previewAd.roomsCount)
        partOfTown = previewAd.partOfTown
        totalArea = Int32(previewAd.totalArea)
        floor = Int32(previewAd.floor)
        price = Int32(previewAd.price)
        imageUrl = previewAd.imageUrl?.absoluteString
        sourceUrl = previewAd.sourceUrl.absoluteString
        
        if let numberOfFloors = previewAd.numberOfFloors {
            self.numberOfFloors = Int32(numberOfFloors)
        }
        
        if let address = previewAd.address {
            street = address.street
            houseNumber = address.houseNumber
        }
    }
}
