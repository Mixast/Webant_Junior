import UIKit
import AVFoundation
import RealmSwift

class MainViewController: UIViewController {
    let collectionCard = PokemonProfile.instance
    let realm =  try? Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private let customCollectionViewCell = "CustomCollectionViewCell"
    private var sizeWidthCell = CGFloat()
    private var sizeHeightCell = CGFloat()
    private var arrayJoke = [String]()
    let interactive = CustomInteractiveTransition()
    private var page = 1
    private var pageSize = 50
    
    private var tasks = [URLSessionDataTask?](repeating: nil, count: 1000)
    private let refreshControl = UIRefreshControl()
    private var api_success = true
    private var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Colection"
        
        arrayJoke = displayURL(url: "https://humornet.ru/anekdot/nacionalnye/pro-kazahov/")
        sizeWidthCell = collectionView.frame.size.width / 2.2
        sizeHeightCell = collectionView.frame.size.height / 2.2
        self.collectionView.register(UINib.init(nibName: customCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: customCollectionViewCell)
        
        if self.collectionCard.colectionCards.count == 0 {
            collectionCard.fillingUrlImage(page: page, pageSize: pageSize) {
                DispatchQueue.main.async {
                    if self.collectionCard.colectionCards.count > 0 {
                        realmSave()
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        collectionView.addSubview(refreshControl)
    }
    
    @objc private func refreshData(_ sender: Any) {
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        collectionCard.fillingUrlImage(page: page, pageSize: pageSize) {
            DispatchQueue.main.async {
                if self.collectionCard.colectionCards.count != 0 {
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                } else {
                    self.showAlert(massage: "", title: "Update failed")
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    

    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let randomInt = Int.random(in: 0..<arrayJoke.count)
            easterEgg(joke: arrayJoke[randomInt])
            let utterance = AVSpeechUtterance(string: arrayJoke[randomInt])
            utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
            utterance.rate = 0.45
            let synthesizer = AVSpeechSynthesizer()
            synthesizer.speak(utterance)
        }
    }
    
    // Вывод шутки
    func easterEgg(joke: String) {
        let optionMenu = UIAlertController(title: "Анекдот", message: joke, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.view.tintColor = .black
        optionMenu.addAction(cancelAction)
        
        // Добавляем небольшую костомизацию размер текста и перенос
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).lineBreakMode = .byWordWrapping
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 0
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).font = UIFont.systemFont(ofSize: 12)
        self.present(optionMenu, animated: true, completion: nil)
    }
}

//     MARK: - Collection View main
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeWidthCell, height: sizeHeightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return filteredTableViewData.count
        } else {
            return self.collectionCard.colectionCards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        if searching {
            if filteredTableViewData[indexPath.row].previewImageData == Data() {
                 
                 DispatchQueue.global().async {
                     self.requestImage(forIndex: indexPath)
                 }
                 cell.image.image = #imageLiteral(resourceName: "tmb_2019_6153")
             } else {
                 guard let image = UIImage(data: filteredTableViewData[indexPath.row].previewImageData) else {
                     return cell
                 }
                 cell.image.image = image
             }
             let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
             tapGestureRecognizer.tag = indexPath.row
             cell.image.isUserInteractionEnabled = true
             cell.image.addGestureRecognizer(tapGestureRecognizer)
             
             let tapGestureRecognizerDuoble = MyTapGesture(target: self, action: #selector(tap(tapGestureRecognizer:)))
             tapGestureRecognizerDuoble.numberOfTouchesRequired = 2
             tapGestureRecognizerDuoble.imageNumber = indexPath.row
             cell.image.addGestureRecognizer(tapGestureRecognizerDuoble)
            
            
            cell.textView.text = filteredTableViewData[indexPath.row].name
            
        } else {
            if self.collectionCard.colectionCards[indexPath.row].previewImageData == Data() {
                
                DispatchQueue.global().async {
                    self.requestImage(forIndex: indexPath)
                }
                cell.image.image = #imageLiteral(resourceName: "tmb_2019_6153")
            } else {
                guard let image = UIImage(data: self.collectionCard.colectionCards[indexPath.row].previewImageData) else {
                    return cell
                }
                cell.image.image = image
            }
            let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.tag = indexPath.row
            cell.image.isUserInteractionEnabled = true
            cell.image.addGestureRecognizer(tapGestureRecognizer)
            
            let tapGestureRecognizerDuoble = MyTapGesture(target: self, action: #selector(tap(tapGestureRecognizer:)))
            tapGestureRecognizerDuoble.numberOfTouchesRequired = 2
            tapGestureRecognizerDuoble.imageNumber = indexPath.row
            cell.image.addGestureRecognizer(tapGestureRecognizerDuoble)
            
            cell.textView.text = self.collectionCard.colectionCards[indexPath.row].name
        }
        return cell
    }
    
  //     MARK: -  Image taped
    @objc func tap(tapGestureRecognizer: MyTapGesture) {
        guard let index = tapGestureRecognizer.imageNumber else {
            return
        }
        //     MARK: - searching
        
        if searching {
            
            if self.collectionCard.favoriteCards.count > 0 {
                for i in 1...self.collectionCard.favoriteCards.count {
                    if self.collectionCard.favoriteCards[i-1].id == filteredTableViewData[index].id {
                        return
                    }
                }
                self.collectionCard.favoriteCards.append(filteredTableViewData[index])
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .broadcast, object: nil)
                }
                
                
                DispatchQueue.global().async {
                    
                    guard let realm = self.realm else {
                        return
                    }
                    
                    let object = realm.objects(RealmBase.self)
                    if object.count > 0 {
                        guard let base = Optional(object[transportRealmIndex]) else {
                            return
                        }
                        
                        for i in 1...base.favoriteCards.count {
                            if base.favoriteCards[i-1].id == filteredTableViewData[index].id {
                                return
                            }
                        }
                        
                        let card = CardsRealm()
                        card.id = filteredTableViewData[index].id
                        card.name = filteredTableViewData[index].name
                        card.previewImageUrl = filteredTableViewData[index].previewImageUrl
                        card.fullImageUrl = filteredTableViewData[index].fullImageUrl
                        card.previewImageData = filteredTableViewData[index].previewImageData
                        card.fullImageData = filteredTableViewData[index].fullImageData
                        card.rarity = filteredTableViewData[index].rarity
                        card.subtype = filteredTableViewData[index].subtype
                        card.health = filteredTableViewData[index].health
                        
                        if filteredTableViewData[index].type.count != 0 {
                            let list = List<String>()
                            for k in 1...filteredTableViewData[index].type.count {
                                list.append(filteredTableViewData[index].type[k-1])
                            }
                            card.type = list
                        }
                        
                        if filteredTableViewData[index].attackTypes.count != 0 {
                            let list = List<String>()
                            for k in 1...filteredTableViewData[index].attackTypes.count {
                                list.append(filteredTableViewData[index].attackTypes[k-1])
                            }
                            card.attackTypes = list
                        }
                        DispatchQueue.main.async {
                            try! realm.write {
                                base.favoriteCards.append(card)
                            }
                        }
                    }
                    
                }

            } else {
                self.collectionCard.favoriteCards.append(filteredTableViewData[index])
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .broadcast, object: nil)
                }
                
                DispatchQueue.global().async {
                    
                    guard let realm = self.realm else {
                        return
                    }
                    
                    let object = realm.objects(RealmBase.self)
                    if object.count > 0 {
                        guard let base = Optional(object[transportRealmIndex]) else {
                            return
                        }
                        
                        let card = CardsRealm()
                        card.id = filteredTableViewData[index].id
                        card.name = filteredTableViewData[index].name
                        card.previewImageUrl = filteredTableViewData[index].previewImageUrl
                        card.fullImageUrl = filteredTableViewData[index].fullImageUrl
                        card.previewImageData = filteredTableViewData[index].previewImageData
                        card.fullImageData = filteredTableViewData[index].fullImageData
                        card.rarity = filteredTableViewData[index].rarity
                        card.subtype = filteredTableViewData[index].subtype
                        card.health = filteredTableViewData[index].health
                        
                        if filteredTableViewData[index].type.count != 0 {
                            let list = List<String>()
                            for k in 1...filteredTableViewData[index].type.count {
                                list.append(filteredTableViewData[index].type[k-1])
                            }
                            card.type = list
                        }
                        
                        if filteredTableViewData[index].attackTypes.count != 0 {
                            let list = List<String>()
                            for k in 1...filteredTableViewData[index].attackTypes.count {
                                list.append(filteredTableViewData[index].attackTypes[k-1])
                            }
                            card.attackTypes = list
                        }
                        DispatchQueue.main.async {
                            
                            try! realm.write {
                                base.favoriteCards.append(card)
                            }
                        }
                    }
                }
                
            }
            
         //     MARK: - No searching
            
        } else {
            if self.collectionCard.favoriteCards.count > 0 {
                for i in 1...self.collectionCard.favoriteCards.count {
                    if self.collectionCard.favoriteCards[i-1].id == self.collectionCard.colectionCards[index].id {
                        return
                    }
                }
                self.collectionCard.favoriteCards.append(self.collectionCard.colectionCards[index])
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .broadcast, object: nil)
                }
                
                DispatchQueue.main.async {

                    guard let realm = self.realm else {
                        return
                    }
                    
                    let object = realm.objects(RealmBase.self)
                    if object.count > 0 {
                        guard let base = Optional(object[transportRealmIndex]) else {
                            return
                        }
                        
                        try! realm.write {
                            base.favoriteCards.append(base.colectionCards[index])
                        }
                    }
                }
                
            } else {
                self.collectionCard.favoriteCards.append(self.collectionCard.colectionCards[index])
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .broadcast, object: nil)
                }
                DispatchQueue.main.async {
                    
                    guard let realm = self.realm else {
                        return
                    }
                    
                    let object = realm.objects(RealmBase.self)
                    if object.count > 0 {
                        guard let base = Optional(object[transportRealmIndex]) else {
                            return
                        }
                        
                        try! realm.write {
                            base.favoriteCards.append(base.colectionCards[index])
                        }
                    }
                }
            
            }
            
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: MyTapGesture) {
        
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
            guard let tag = tapGestureRecognizer.tag else {
                return
            }
            detailVC.transportLine = tag
            detailVC.searching = searching
            self.interactive.viewController = detailVC
            self.navigationController?.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
}
extension MainViewController {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if searching == false{
            if collectionCard.colectionCards.count-1 == indexPath.row && collectionCard.colectionCards.count%10 == 0{
                getMoreImages(page: page)
            }
        }
    }

    func getMoreImages(page: Int) {
        if api_success {
            
            self.page = self.page + 1
            api_success = false
            let savePosition = self.collectionCard.colectionCards.count
            collectionCard.fillingUrlImage(page: page, pageSize: pageSize) {
                DispatchQueue.main.async {
                    if self.collectionCard.colectionCards.count > savePosition {
                        
                        for i in savePosition...self.collectionCard.colectionCards.count {
                            let card = CardsRealm()
                            card.id = self.collectionCard.colectionCards[i-1].id
                            card.name = self.collectionCard.colectionCards[i-1].name
                            card.previewImageUrl = self.collectionCard.colectionCards[i-1].previewImageUrl
                            card.fullImageUrl = self.collectionCard.colectionCards[i-1].fullImageUrl
                            card.previewImageData = self.collectionCard.colectionCards[i-1].previewImageData
                            card.fullImageData = self.collectionCard.colectionCards[i-1].fullImageData
                            card.rarity = self.collectionCard.colectionCards[i-1].rarity
                            card.subtype = self.collectionCard.colectionCards[i-1].subtype
                            card.health = self.collectionCard.colectionCards[i-1].health
                            
                            if self.collectionCard.colectionCards[i-1].type.count != 0 {
                                let list = List<String>()
                                for k in 1...self.collectionCard.colectionCards[i-1].type.count {
                                    list.append(self.collectionCard.colectionCards[i-1].type[k-1])
                                }
                                card.type = list
                            }
                            
                            if self.collectionCard.colectionCards[i-1].attackTypes.count != 0 {
                                let list = List<String>()
                                for k in 1...self.collectionCard.colectionCards[i-1].attackTypes.count {
                                    list.append(self.collectionCard.colectionCards[i-1].attackTypes[k-1])
                                }
                                card.attackTypes = list
                            }
                            
                            guard let realm = self.realm else {
                                return
                            }
                            
                            let object = realm.objects(RealmBase.self)
                            if object.count > 0 {
                                guard let base = Optional(object[transportRealmIndex]) else {
                                    return
                                }
                                
                                try! realm.write {
                                    base.colectionCards.append(card)
                                }
                            }
                        }
                        
                        self.api_success = true
                        self.collectionView.reloadData()
                    } else {
                        print("Dont donwload")
                    }
                }
            }
        }
    }
}

//     MARK: - Collection View DataSourcePrefetching
extension MainViewController: UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if searching {
            for indexPath in indexPaths {
                if filteredTableViewData[indexPath.row].previewImageData == Data() {
                    DispatchQueue.global().async {
                        self.requestImage(forIndex: indexPath)
                    }
                }
            }
        } else {
            for indexPath in indexPaths {
                if self.collectionCard.colectionCards[indexPath.row].previewImageData == Data() {
                    DispatchQueue.global().async {
                        self.requestImage(forIndex: indexPath)
                    }
                }
            }
        }
    }
    
    func requestImage(forIndex: IndexPath) {
        if searching {
            if forIndex.row < filteredTableViewData.count {
                if filteredTableViewData[forIndex.row].previewImageData != Data() {
                    return
                }
                
                autoreleasepool {
                    var task: URLSessionDataTask
                    if forIndex.row <= self.tasks.count {
                        if self.tasks[forIndex.row] != nil
                            && self.tasks[forIndex.row]!.state == URLSessionTask.State.running {
                            return
                        }
                        
                        task = self.getTask(forIndex: forIndex)
                        self.tasks[forIndex.row] = task
                        task.resume()
                    }
                }
            }
        } else {
            
            if self.collectionCard.colectionCards[forIndex.row].previewImageData != Data() {
                return
            }
            
            autoreleasepool {
                var task: URLSessionDataTask
                if forIndex.row <= self.tasks.count {
                    if self.tasks[forIndex.row] != nil
                        && self.tasks[forIndex.row]!.state == URLSessionTask.State.running {
                        return
                    }
                    
                    task = self.getTask(forIndex: forIndex)
                    self.tasks[forIndex.row] = task
                    task.resume()
                }
            }
        }
    }
    
    //  URLSessionDataTask
    func getTask(forIndex: IndexPath) -> URLSessionDataTask  {
        if searching {
            
            if filteredTableViewData[forIndex.row].previewImageData != Data() {
                return URLSessionDataTask()
            }
            
            guard let url = URL(string: filteredTableViewData[forIndex.row].previewImageUrl) else {
                return URLSessionDataTask()
            }
            let imgURL = url
            
            return URLSession.shared.dataTask(with: imgURL) { data, response, error in
                DispatchQueue.global().async {
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        if forIndex.row < filteredTableViewData.count {
                            filteredTableViewData[forIndex.row].previewImageData = data
                            self.collectionView.reloadItems(at: [forIndex])
                        }
                    }
                }
            }
            
        } else {
            if self.collectionCard.colectionCards[forIndex.row].previewImageData != Data() {
                return URLSessionDataTask()
            }
            
            guard let url = URL(string: self.collectionCard.colectionCards[forIndex.row].previewImageUrl) else {
                return URLSessionDataTask()
            }
            let imgURL = url
            
            return URLSession.shared.dataTask(with: imgURL) { data, response, error in
                DispatchQueue.global().async {
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() {
                        self.collectionCard.colectionCards[forIndex.row].previewImageData = data
                        self.collectionView.reloadItems(at: [forIndex])
                        
                        guard let realm = self.realm else {
                            return
                        }
                        
                        let object = realm.objects(RealmBase.self)
                        if object.count > 0 {
                            guard let base = Optional(object[transportRealmIndex]) else {
                                return
                            }
                            
                            try! realm.write {
                                base.colectionCards[forIndex.row].previewImageData = data
                            }
                        }
                    }
                }
            }
        }
    }
    
}

extension MainViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return animatedTransitionTwo()
        } else if operation == .pop {
            return animatedTransitionTwoDismissed()

        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactive.hasStarted ? interactive : nil
    }

}

extension MainViewController {
    private func showAlert (massage: String, title: String) {    // Вывод ошибки если пользователь ввел неправильно данные
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Search Bar
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                
        guard searchText != "" else {
            searching = false
            filteredTableViewData.removeAll()
            collectionView.reloadData()
            return
        }
        
        filteredTableViewData.removeAll()

        searchPoky(name: searchText) {
            DispatchQueue.main.async {
                if filteredTableViewData.count != 0 {
                    self.searching = true
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//     MARK: - Custom UITapGestureRecognizer
class MyTapGesture: UITapGestureRecognizer {
    var tag: Int?
    var imageNumber: Int?
}

extension Notification.Name {
    static let broadcast = Notification.Name("Broadcast")
}
