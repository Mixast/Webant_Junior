//
//  ProfileView.swift
//  Webant_Junior_Test2
//
//  Created by Лекс Лютер on 20/10/2019.
//  Copyright © 2019 Лекс Лютер. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    let collectionCard = PokemonProfile.instance
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var pokyImage: UIImageView!
    
    @IBOutlet weak var pokyName: UITextView!
    @IBOutlet weak var pokyRarity: UITextField!
    @IBOutlet weak var pokyType: UITextField!
    @IBOutlet weak var pokyHealth: UITextField!
    @IBOutlet weak var pokySubtype: UITextField!
    @IBOutlet weak var pokyAttackTypes: UITextField!
    
    var transportLine: Int!
    var saveFrame = CGRect()
    var searching = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        pokyName.textContainer.lineBreakMode = .byCharWrapping
        pokyRarity.autocapitalizationType = .words
        pokyType.autocapitalizationType = .words
        pokyHealth.autocapitalizationType = .words
        pokySubtype.autocapitalizationType = .words
        pokyAttackTypes.autocapitalizationType = .words
        
        if filteredTableViewData.count > 0 {
            
            DispatchQueue.main.async {
                self.pokyName.text = filteredTableViewData[self.transportLine].name
                self.pokyRarity.text! += " " + filteredTableViewData[self.transportLine].rarity
                self.pokyHealth.text! += " " + filteredTableViewData[self.transportLine].health
                self.pokySubtype.text! += " " + filteredTableViewData[self.transportLine].subtype
                
                if filteredTableViewData[self.transportLine].attackTypes.count > 0 {
                    for i in 1...filteredTableViewData[self.transportLine].attackTypes.count {
                        self.pokyAttackTypes.text! +=  " " +  filteredTableViewData[self.transportLine].attackTypes[i-1]
                        if i != filteredTableViewData[self.transportLine].attackTypes.count {
                            self.pokyAttackTypes.text! += ", "
                        }
                    }
                }
                
                if filteredTableViewData[self.transportLine].type.count > 0 {
                    for i in 1...filteredTableViewData[self.transportLine].type.count {
                        self.pokyType.text! +=  " " +  filteredTableViewData[self.transportLine].type[i-1]
                        if i != filteredTableViewData[self.transportLine].type.count {
                            self.pokyType.text! += ", "
                        }
                    }
                }
                if filteredTableViewData[self.transportLine].fullImageData == Data() {
                    self.pokyImage.image = UIImage(data: filteredTableViewData[self.transportLine].previewImageData)
                    DispatchQueue.global().async {
                        guard let url = URL(string: filteredTableViewData[self.transportLine].fullImageUrl) else {
                            return
                        }
                        
                        if let newData = try? Data(contentsOf: url) {
                            filteredTableViewData[self.transportLine].fullImageData = newData
                            DispatchQueue.main.async {
                                self.pokyImage.image = UIImage(data: filteredTableViewData[self.transportLine].fullImageData)
                            }
                        } else {
                            self.pokyImage.image = UIImage(data: filteredTableViewData[self.transportLine].previewImageData)
                        }
                    }
                } else {
                    self.pokyImage.image = UIImage(data: filteredTableViewData[self.transportLine].fullImageData)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.pokyName.text = self.collectionCard.colectionCards[self.transportLine].name
                self.pokyRarity.text! += " " + self.collectionCard.colectionCards[self.transportLine].rarity
                self.pokyHealth.text! += " " + self.collectionCard.colectionCards[self.transportLine].health
                self.pokySubtype.text! += " " + self.collectionCard.colectionCards[self.transportLine].subtype
                
                if self.collectionCard.colectionCards[self.transportLine].attackTypes.count > 0 {
                    for i in 1...self.collectionCard.colectionCards[self.transportLine].attackTypes.count {
                        self.pokyAttackTypes.text! +=  " " +  self.collectionCard.colectionCards[self.transportLine].attackTypes[i-1]
                        if i != self.collectionCard.colectionCards[self.transportLine].attackTypes.count {
                            self.pokyAttackTypes.text! += ", "
                        }
                    }
                }
                
                if self.collectionCard.colectionCards[self.transportLine].type.count > 0 {
                    for i in 1...self.collectionCard.colectionCards[self.transportLine].type.count {
                        self.pokyType.text! +=  " " +  self.collectionCard.colectionCards[self.transportLine].type[i-1]
                        if i != self.collectionCard.colectionCards[self.transportLine].type.count {
                            self.pokyType.text! += ", "
                        }
                    }
                }
                if self.collectionCard.colectionCards[self.transportLine].fullImageData == Data() {
                    self.pokyImage.image = UIImage(data: self.collectionCard.colectionCards[self.transportLine].previewImageData)
                    DispatchQueue.global().async {
                        guard let url = URL(string: self.collectionCard.colectionCards[self.transportLine].fullImageUrl) else {
                            return
                        }
                        
                        if let newData = try? Data(contentsOf: url) {
                            self.collectionCard.colectionCards[self.transportLine].fullImageData = newData
                            DispatchQueue.main.async {
                                self.pokyImage.image = UIImage(data: self.collectionCard.colectionCards[self.transportLine].fullImageData)
                            }
                        } else {
                            self.pokyImage.image = UIImage(data: self.collectionCard.colectionCards[self.transportLine].previewImageData)
                        }
                    }
                } else {
                    self.pokyImage.image = UIImage(data: self.collectionCard.colectionCards[self.transportLine].fullImageData)
                }
            }
        }
        
        pokyImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(refreshData(_:)))
        pokyImage.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func refreshData(_ sender: Any) {
        if pokyImage.frame == self.frame {
            pokyImage.frame = saveFrame
        } else {
            saveFrame = pokyImage.frame
            pokyImage.frame = self.frame
        }
    }
}
