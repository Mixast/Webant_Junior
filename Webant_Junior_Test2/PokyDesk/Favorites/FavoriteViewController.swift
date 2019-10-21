import UIKit
class FavoriteViewController: UIViewController {
    let collectionCard = PokemonProfile.instance
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fullImage: UIImageView!
    
    let customCollectionViewCell = "CustomCollectionViewCell"
    var saveFrame = CGRect()
    var sizeWidthCell = CGFloat()
    var sizeHeightCell = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        sizeWidthCell = collectionView.frame.size.width / 2.2
        sizeHeightCell = collectionView.frame.size.height / 2.2
        
        self.collectionView.register(UINib.init(nibName: customCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: customCollectionViewCell)
        
        let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
         
         self.fullImage.addGestureRecognizer(tapGestureRecognizer)
         self.fullImage.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.broadcast), name: .broadcast, object: nil)
        
    }
    
    @objc func broadcast(_ notification: Notification) {
        collectionView.reloadData()
    }
      
}



//     MARK: - Collection View main
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: sizeWidthCell, height: sizeHeightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionCard.favoriteCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.image.image = UIImage(data: self.collectionCard.favoriteCards[indexPath.row].previewImageData)
        
        let tapGestureRecognizer = MyTapGesture(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.imageNumber = indexPath.row

        cell.image.isUserInteractionEnabled = true
        cell.image.addGestureRecognizer(tapGestureRecognizer)
        cell.textView.text = self.collectionCard.favoriteCards[indexPath.row].name
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: MyTapGesture) {

        UIView.animate(withDuration: 1.0, animations: {
            
            if self.fullImage.alpha == 1 {
                self.fullImage.alpha = 0
            } else {
                self.fullImage.alpha = 1
            }
            
            if self.collectionView.alpha == 1 {
                self.collectionView.alpha = 0
            } else {
                self.collectionView.alpha = 1
            }
            
            guard let tagNew = tapGestureRecognizer.imageNumber else {
                return
            }
            
            self.fullImage.image = UIImage(data: self.collectionCard.favoriteCards[tagNew].previewImageData)
            
        })
        
    }
}


