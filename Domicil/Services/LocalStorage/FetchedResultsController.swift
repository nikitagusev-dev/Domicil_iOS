//
//  FetchedResultsController.swift
//  Domicil
//
//  Created by Никита Гусев on 21.04.2022.
//

import CoreData
import Foundation
import RxCocoa

class FetchedResultsController<Entity: NSManagedObject>: NSObject,
    NSFetchedResultsControllerDelegate
{
    var result: Driver<[Entity]> {
        resultRelay.asDriver()
    }
    
    private let controller: NSFetchedResultsController<Entity>
    private let resultRelay = BehaviorRelay<[Entity]>(value: [])
    
    init(fetchRequest: NSFetchRequest<Entity>, managedObjectContext: NSManagedObjectContext) {
        controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
    
        controller.delegate = self
        performFetch()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        performFetch()
    }
}

// MARK: - Private methods
private extension FetchedResultsController {
    func performFetch() {
        try? controller.performFetch()
        
        guard let entities = controller.fetchedObjects else { return }
        
        resultRelay.accept(entities)
        
    }
}
