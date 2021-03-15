//
//  TimeProfiler.swift
//  AppWithExtension
//
//  Created by Zelinskaya Anna on 14.03.2021.
//

import Foundation

class TimeProfiler {
	
	class func getOperationTime(closure: @escaping () -> Void) -> String {
		let start = DispatchTime.now()
		closure()
		let end = DispatchTime.now()
		
		let time = end.uptimeNanoseconds - start.uptimeNanoseconds
		let timeInterval = Double(time) / 1_000_000_000
		let strTimeInterval = String(timeInterval) + " seconds"
		
		return strTimeInterval
	}
	
}
