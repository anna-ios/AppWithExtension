//
//  File.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 22.02.2021.
//

import Foundation

struct SuffixesCreator {
	
	var allSuffixes: [String: Int] = [:]
	var threeLetterSuffixes: [String: Int] = [:]
	var fiveLetterSuffixes: [String: Int] = [:]
	
	init(text: String) {
		let words = text.split { !$0.isLetter }
		for word in words {
			let sequence = SuffixSequence(string: String(word))
			for suffix in sequence {
				allSuffixes[String(suffix)] = (allSuffixes[String(suffix)] ?? 0) + 1
			}
			
			if word.count >= 3 {
				let threeLetterSuffix = String(word.suffix(3))
				if !threeLetterSuffix.isEmpty {
					threeLetterSuffixes[threeLetterSuffix] = (threeLetterSuffixes[threeLetterSuffix] ?? 0) + 1
				}
			}
			
			if word.count >= 5 {
				let fiveLetterSuffix = String(word.suffix(5))
				if !fiveLetterSuffix.isEmpty {
					fiveLetterSuffixes[fiveLetterSuffix] = (fiveLetterSuffixes[fiveLetterSuffix] ?? 0) + 1
				}
			}
		}
	}
	
}

struct SuffixIterator: IteratorProtocol {
	
	let string: String
	let length: Int
	var index = 1
	
	init(string: String) {
		self.string = string
		length = string.count
	}
	
	mutating func next() -> Substring? {
		guard index <= length else {
			return nil
		}
		
		let suffix = string.suffix(index)
		index += 1
		return suffix
	}
	
}

struct SuffixSequence: Sequence {
	
	let string: String
	
	func makeIterator() -> SuffixIterator {
		return SuffixIterator(string: string)
	}
	
}
