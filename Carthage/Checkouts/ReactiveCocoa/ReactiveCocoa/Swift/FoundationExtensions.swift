//
//  FoundationExtensions.swift
//  ReactiveCocoa
//
//  Created by Justin Spahr-Summers on 2014-10-19.
//  Copyright (c) 2014 GitHub. All rights reserved.
//

import Foundation
import Result

extension NSNotificationCenter {
	/// Returns a producer of notifications posted that match the given criteria.
	/// This producer will not terminate naturally, so it must be explicitly
	/// disposed to avoid leaks.
	public func rac_notifications(name: String? = nil, object: AnyObject? = nil) -> SignalProducer<NSNotification, NoError> {
		return SignalProducer { observer, disposable in
			let notificationObserver = self.addObserverForName(name, object: object, queue: nil) { notification in
				sendNext(observer, notification)
			}

			disposable.addDisposable {
				self.removeObserver(notificationObserver)
			}
		}
	}
}

private let defaultSessionError = NSError(domain: "org.reactivecocoa.ReactiveCocoa.rac_dataWithRequest", code: 1, userInfo: nil)

extension NSURLSession {
	/// Returns a producer that will execute the given request once for each
	/// invocation of start().
	public func rac_dataWithRequest(request: NSURLRequest) -> SignalProducer<(NSData, NSURLResponse), NSError> {
		return SignalProducer { observer, disposable in
			let task = self.dataTaskWithRequest(request, completionHandler: { data, response, error in
				if let data = data, response = response {
					sendNext(observer, (data, response))
					sendCompleted(observer)
				} else {
					sendError(observer, error ?? defaultSessionError)
				}
			})

			disposable.addDisposable {
				task.cancel()
			}
			task.resume()
		}
	}
}
