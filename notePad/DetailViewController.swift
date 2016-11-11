//
//  DetailViewController.swift
//  notePad
//
//  Created by sushant on 10/11/16.
//  Copyright © 2016 sushant. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var detailDescription: UITextView!
    var managedObjectContext: NSManagedObjectContext? = nil

    func configureView() {
        // Update the user interface for the detail item.
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appdelegate.persistentContainer.viewContext
        
        if let detail = self.detailItem {
            if let label = self.detailDescription {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let saveButton = UIBarButtonItem(barButtonSystemItem : .save, target:self, action: #selector(saveObject(_:)));
        self.navigationItem.rightBarButtonItem = saveButton;
        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    func saveObject(_ sender : Any) {
        
        if let detail = self.detailItem{
            detail.timestamp! = self.detailDescription.text!
        }
        
        let context = self.fetchedResultsController.managedObjectContext;
        
        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }


}

