
import UIKit
import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call Update Version Funtion
        self.appUpdateAvailable { status in
            if status {
                self.getUpdatedVersion()
            }
        }
    }
}

//MARK:- Update Version Extension
extension ViewController {
    func getUpdatedVersion() {
        var app_Version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        var latest_Version = "1.1"
        app_Version = app_Version.replacingOccurrences(of: ".", with: "") as String
        latest_Version = latest_Version.replacingOccurrences(of: ".", with: "") as String
        
        if app_Version.count < latest_Version.count {
            app_Version = app_Version.appending("0") as String
        }
        else if latest_Version.count < app_Version.count {
            latest_Version = latest_Version.appending("0") as String
        }
        
        let appData = ["whats_new_text" : "You can set your updated new version text here...", "minimum_app_version_ios" : "1.1", "latest_Version" : "1.1"]
        
        let app_V : Double = Double(app_Version)!
        let latest_V : Double = Double(latest_Version)!
        
        if app_V < latest_V {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 5)) {
                self.getUpdateWithDict(dictData: appData as NSDictionary)
            }
        }
    }
    
    func getUpdateWithDict(dictData : NSDictionary)  {
        ManageUpdateVC.showPopup(strTitle: "New Update Available!!!", dictData: dictData,viewController: self, completion: { (sender) -> Void in
            print("\(sender.tag)")
            if sender.tag == 101 {
                if let url = URL(string: ""), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(url)
                    }
                }
            }
            else {
                //Close Popup login
            }
        })
    }
    
    func appUpdateAvailable(completion:@escaping (Bool)-> ()) {
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            guard let bundleID = infoDictionary["CFBundleIdentifier"] else {return}
            let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=\(bundleID)"
            
            if let urlOnAppStore = URL(string: storeInfoURL) {
                URLSession.shared.dataTask(with: urlOnAppStore) { (data, response, error) in
                    // Error handling...
                    guard let dataInJSON = data else { return }
                    
                    DispatchQueue.main.async {
                        if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] as NSDictionary? {
                            if let results:NSArray = dict["results"] as? NSArray {
                                if results.count > 0 {
                                    let dictVersion = results[0] as AnyObject
                                    if let version = dictVersion["version"] as? String {
                                        print(version)
                                        if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                            // Check if they are the same. If not, an upgrade is available.
                                            print("\(version)")
                                            if version != currentVersion {
                                                upgradeAvailable = true
                                                completion(upgradeAvailable)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }.resume()
            }
        }
    }
}


