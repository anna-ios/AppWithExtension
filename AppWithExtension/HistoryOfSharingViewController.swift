//
//  HistoryOfSharingViewController.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 07.03.2021.
//

import UIKit
import CoreData

class HistoryOfSharingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	var fetchedResultsController = CoreDataManager.instance.fetchedResultsController()
	var suffixesArray : [Array<String>] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		fetchedResultsController.delegate = self
		do {
			try fetchedResultsController.performFetch()
		} catch {
			print(error)
		}
		
		updateSuffixesArray()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let sections = fetchedResultsController.sections {
			return sections[section].numberOfObjects
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		
		if let suffixes = fetchedResultsController.object(at: indexPath) as? Suffixes {
			cell.textLabel?.text = suffixes.array.description
		}
		
		return cell
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		updateSuffixesArray()
		tableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "suffixesTesting" {
			let controller = segue.destination as! SuffixesTestingViewController
			controller.results = suffixesArray
		}
	}
	
	func updateSuffixesArray() {
		guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
			return
		}
		
		suffixesArray = []
		for fetchedObject in fetchedObjects {
			if let suffixes = fetchedObject as? Suffixes {
				suffixesArray.append(suffixes.array)
			}
		}
	}
}
