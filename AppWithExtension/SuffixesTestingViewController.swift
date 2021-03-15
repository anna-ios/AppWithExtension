//
//  SuffixesTestingViewController.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 11.03.2021.
//

import UIKit

class SuffixesTestingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var testTimeTableView: UITableView!
	let manager: SuffixManager = SuffixManager()
	var testTimeArray: [String] = []
	var results: [Array<String>] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		testTimeTableView.delegate = self
		testTimeTableView.dataSource = self
	}
	
	@IBAction func startReverseTesting(_ sender: Any) {
		testTimeArray = []
		
		let queue = OperationQueue()
		queue.maxConcurrentOperationCount = 3
		
		let completionOperation = BlockOperation {
			DispatchQueue.main.async {
				self.testTimeTableView.reloadData()
			}
		}
		
		for item in results {
			let operation = BlockOperation {
				if let strInterval = self.manager.reverseSuffixes(item) {
					self.testTimeArray.append(strInterval)
				}
			}
			completionOperation.addDependency(operation)
			queue.addOperation(operation)
		}
		
		queue.addOperation(completionOperation)
	}
	
	@IBAction func startUppercasedTesting(_ sender: Any) {
		testTimeArray = []
		
		let dispatchGroup = DispatchGroup()
		
		for item in results {
			DispatchQueue.global().async(group: dispatchGroup) {
				if let strInterval = self.manager.uppercasedSuffixes(item) {
					self.testTimeArray.append(strInterval)
				}
			}
		}
		
		dispatchGroup.notify(queue: DispatchQueue.main) {
			self.testTimeTableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		results.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		if testTimeArray.count > 0,
		   let time = testTimeArray[indexPath.row] as? String {
			cell.textLabel?.text = time
		}
		return cell
	}
	
}
