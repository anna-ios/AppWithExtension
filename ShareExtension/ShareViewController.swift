//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Zelinskaya Anna on 19.02.2021.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
		
	override func isContentValid() -> Bool {
		
		if !contentText.isEmpty {
			return true
		}
		
		return false
	}
	
	override func didSelectPost() {
		
		if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
			let contentType = kUTTypeText as String
			if let contents = content.attachments {
				for attachment in contents {
					if attachment.hasItemConformingToTypeIdentifier(contentType) {
						attachment.loadItem(forTypeIdentifier: contentType, options: nil) { data, error in
							guard let text = data as? String else { return }
							UserDefaults(suiteName: "group.com.Zelinskaya.ShareExtension")?.set(text, forKey: "ShareExtensionText")
							
							guard let url = URL(string: "AppWithExtension://") else { return }
							self.openURL(url)
						}
					}
				}
			}
		}

		self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
	}
	
	@objc private func openURL(_ url: URL) -> Bool {
		var responder: UIResponder? = self
		while responder != nil {
			if let application = responder as? UIApplication {
				return application.perform(#selector(openURL(_:)), with: url) != nil
			}
			responder = responder?.next
		}
		return false
	}
	
	override func configurationItems() -> [Any]! {
		return []
	}
	
}
