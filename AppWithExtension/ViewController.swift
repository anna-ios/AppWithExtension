//
//  ViewController.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 19.02.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var sortButton: UIButton!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	
	var suffixes : [Dictionary<String, Int>.Element] = []
	var allSuffixes : [Dictionary<String, Int>.Element] = []
	var threeLetterSuffixes : [Dictionary<String, Int>.Element] = []
	var fiveLetterSuffixes : [Dictionary<String, Int>.Element] = []
	var textString = ""
	var sortAsc = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(updateSuffixes), name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		updateSuffixes()
	}
	
	@IBAction func sort(_ sender: Any) {
		sortAsc = !sortAsc
		allSuffixes = allSuffixes.sorted(by: { sortAsc ? $0.0 < $1.0 : $0.0 > $1.0 })
		setupSuffixes(allSuffixes)
	}
	
	@IBAction func indexChanged(_ sender: Any) {
		switch segmentedControl.selectedSegmentIndex {
		case 0:
			setupSuffixes(allSuffixes)
			sortButton.isHidden = false
		case 1:
			setupSuffixes(threeLetterSuffixes)
			sortButton.isHidden = true
		case 2:
			setupSuffixes(fiveLetterSuffixes)
			sortButton.isHidden = true
		default:
			break;
		}
	}
		
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return suffixes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		
		let suffix = suffixes[indexPath.row]
		cell.textLabel?.text = suffix.key
		cell.detailTextLabel?.text = "Кол-во нахождений: \(suffix.value)"
		
		return cell
	}
	
	@objc func updateSuffixes() {
		
		if let textStr = UserDefaults(suiteName: "group.com.Zelinskaya.ShareExtension")?.value(forKey: "textString") as? String {
			textString = textStr
			UserDefaults(suiteName: "group.com.Zelinskaya.ShareExtension")?.removeObject(forKey: "textString")
		}
		
		let suffixesCreator = SuffixesCreator.init(text: textString)
		allSuffixes = suffixesCreator.allSuffixes.sorted(by: { $0.0 < $1.0 })
		threeLetterSuffixes = Array(suffixesCreator.threeLetterSuffixes.sorted(by: { $0.1 > $1.1 }).prefix(10))
		fiveLetterSuffixes = Array(suffixesCreator.fiveLetterSuffixes.sorted(by: { $0.1 > $1.1 }).prefix(10))
		
		indexChanged(segmentedControl as Any)
	}
	
	fileprivate func setupSuffixes(_ test: [Dictionary<String, Int>.Element]) {
		suffixes = test
		tableView.reloadData()
	}
	
}

