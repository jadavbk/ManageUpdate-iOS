import UIKit

class ManageUpdateVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet var viewUpdate: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    //MARK:- Variables
    var versionInfoDict: NSDictionary = [:]
    var navController: UINavigationController?
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Layout Subview
    func setupUI() {
        self.btnOK.tag = 101
        self.btnCancel.tag = 102
        
        self.btnOK.setTitleColor(.black, for: .normal)
        self.btnCancel.setTitleColor(.black, for: .normal)
        
        self.viewUpdate.layer.cornerRadius    = 5.0
        self.viewUpdate.layer.shadowColor     = UIColor.black.cgColor
        self.viewUpdate.layer.shadowOpacity   = 0.5
        self.viewUpdate.layer.shadowOffset    = CGSize.zero
        self.viewUpdate.layer.shadowRadius    = 5
        
        self.btnOK.layer.cornerRadius    = 5.0
        self.btnOK.layer.borderWidth     = 1.0
        self.btnOK.layer.borderColor     = UIColor.lightGray.cgColor

        self.btnCancel.layer.cornerRadius    = 5.0
        self.btnCancel.layer.borderWidth     = 1.0
        self.btnCancel.layer.borderColor     = UIColor.lightGray.cgColor
                
        self.view.backgroundColor       = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        self.updateLayout()
    }
    
    func updateLayout() {
        let app_Version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! NSString
        let min_Version = self.versionInfoDict["minimum_app_version_ios"] as? NSString ?? app_Version
        self.btnCancel.isHidden = app_Version.doubleValue < min_Version.doubleValue ? true : false
    }
    
    //MARK: - Show Popup Class Method
    class func showPopup(strTitle:String, dictData:NSDictionary, viewController : UIViewController, completion:@escaping (UIButton)-> ()){
        
        let managePopup = ManageUpdateVC.init(nibName: "ManageUpdateVC", bundle: nil)
        managePopup.view.tag = 121;
        managePopup.lblTitle.text = strTitle
        managePopup.lblMsg.text = dictData["whats_new_text"] as? String
        managePopup.versionInfoDict = dictData
        managePopup.navController = viewController.navigationController
        
        managePopup.view.frame = (managePopup.navController?.view.bounds ?? CGRect.zero)!
        managePopup.navController?.view.addSubview(managePopup.view)
        
        managePopup.btnCancel.addTapGesture { (gesture) in
            if let popUpView = managePopup.navController?.view.viewWithTag(121) {
                popUpView.removeFromSuperview()
            }
            completion(managePopup.btnCancel)
        }
        
        managePopup.btnOK.addTapGesture { (gesture) in
            if let popUpView = managePopup.navController?.view.viewWithTag(121) {
                popUpView.removeFromSuperview()
            }
            completion(managePopup.btnOK)
        }
    }
}
