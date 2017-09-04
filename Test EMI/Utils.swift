//
//  Utils.swift
//  Test EMI
//
//  Created by Jose Francisco Rosales Hernandez on 03/09/17.
//  Copyright © 2017 Jose Francisco Rosales Hernandez. All rights reserved.
//

import SystemConfiguration
import Foundation
import UIKit

class Utils: UIViewController {
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    func checkInternet() -> Bool{
        let utils : Utils = Utils()
        if(utils.isInternetAvailable()){
            return true
        }else{
            print("NO INTERNET")
            return false
        }
    }
    
    func showLoadingAlert(text:String? = nil, controller : UIViewController) {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        if let text = text {
            alert.message = text
        }
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        //sleep(3)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
}
