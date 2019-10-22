import UIKit

class ProfileViewController: UIViewController {
    var transportLine = 0
    var searching = false
    var arrayView = [ProfileView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let view = ProfileView()
        view.transportLine = transportLine
        view.searching = searching
        
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 40)
        arrayView.append(view)
        
        self.view.addSubview(view)
        
    }
}
