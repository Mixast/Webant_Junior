import Foundation
import Kanna
import Alamofire
import SwiftyJSON

struct Cards { // Структура Аnime
    var id: String
    var name: String
    var previewImageUrl: String
    var fullImageUrl: String
    var previewImageData: Data
    var fullImageData: Data
    var rarity: String
    var type: [String]
    var subtype: String
    var health: String
    var attackTypes: [String]

    init() {
        self.id = ""
        self.name = ""
        self.previewImageUrl = ""
        self.fullImageUrl = ""
        self.previewImageData = Data()
        self.fullImageData = Data()
        self.rarity = ""
        self.type = []
        self.subtype = ""
        self.health = ""
        self.attackTypes = []
    }
}

class PokemonProfile: Any {         // Структура профиля друга Singleton
    var colectionCards = [Cards]()
    var favoriteCards = [Cards]()

    func fillingUrlImage(page: Int, pageSize: Int  , completioHandler : (() ->Void)?) {
        DispatchQueue.global().async {
            let url = "https://api.pokemontcg.io/v1/cards?page=\(String( page))&pageSize=\(String(pageSize))"
            
            request(url,  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    for (_, subJson):(String, JSON) in json["cards"] {
                        
                        let id = subJson["id"].stringValue
                        var name = subJson["name"].stringValue
                        let previewImageUrl = subJson["imageUrl"].stringValue
                        let fullImageUrl = subJson["imageUrlHiRes"].stringValue
                        var rarity = subJson["rarity"].stringValue
                        var subtype = subJson["subtype"].stringValue
                        var health = subJson["hp"].stringValue
                        if name == "" {
                            name = "No name"
                        }
                        if rarity == "" {
                            rarity = "No rarity"
                        }
                        if subtype == "" {
                            subtype = "No subtype"
                        }
                        if health == "" {
                            health = "No health"
                        }
                        
                        var type = [String]()
                        
                        for (_, subJson):(String, JSON) in subJson["types"] {
                            type.append(subJson.stringValue)
                        }
                        
                        var attackTypes = [String]()
                        for (_, subJson):(String, JSON) in subJson["attacks"] {
                            attackTypes.append(subJson["name"].stringValue)
                        }
                        
                        if type.count == 0 {
                            type.append("No type")
                        }
                        if attackTypes.count == 0 {
                            attackTypes.append("No attackTypes")
                        }
                        
                        var card = Cards()
                        card.id = id
                        card.name = name
                        card.previewImageUrl = previewImageUrl
                        card.fullImageUrl = fullImageUrl
                        card.rarity = rarity
                        card.subtype = subtype
                        card.health = health
                        card.type = type
                        card.attackTypes = attackTypes
                        self.colectionCards.append(card)
                    }
                    completioHandler?()
                case .failure(let error):
                    let arres = error.localizedDescription
                    print(arres)
                    completioHandler?()
                }
            }
        }
    }
    
    
    
    private init() {}
    static let instance = PokemonProfile()
}


// Для шутки
func displayURL(url: String) -> [String] {
    let myURLString = url
    var arrayJoke = [String]()
    
    guard let myURL = URL(string: myURLString) else {
        print("Error: \(myURLString) doesn't seem to be a valid URL")
        return arrayJoke
    }
    
    do {
        let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
        if let doc = try? HTML(html: myHTMLString, encoding: .utf8) {
            // Search for nodes by CSS
         
            for link in doc.css("div") {
                if link["class"] == "str_left" {
                    let l = link
                    for link in l.css("div") {
                        if link["id"] == "dle-content" {
                            let k = link
                            for link in k.css("article") {
                                if link["class"] == "block story shortstory" {
                                    let m = link
                                    for link in m.css("div") {
                                        if link["class"] == "text" {
                                            let n = link
                                            guard let text = n.text else {
                                                return arrayJoke
                                            }
                                            guard let data = text.data(using: .isoLatin1) else {
                                                return arrayJoke
                                            }
                                            guard let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                                                return arrayJoke
                                            }
                                            arrayJoke.append(str as String)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    } catch let error {
        print("Error: \(error)")
    }
    return arrayJoke
}

var filteredTableViewData = [Cards]()
func searchPoky(name: String, completioHandler : (() ->Void)?) {
    
    let url = "https://api.pokemontcg.io/v1/cards?name=\(name)"
    request(url,  method: .get).validate(contentType: ["application/json"]).responseJSON() { response in
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            
            for (_, subJson):(String, JSON) in json["cards"] {

                let id = subJson["id"].stringValue
                var name = subJson["name"].stringValue
                let previewImageUrl = subJson["imageUrl"].stringValue
                let fullImageUrl = subJson["imageUrlHiRes"].stringValue
                var rarity = subJson["rarity"].stringValue
                var subtype = subJson["subtype"].stringValue
                var health = subJson["hp"].stringValue
                if name == "" {
                    name = "No name"
                }
                if rarity == "" {
                    rarity = "No rarity"
                }
                if subtype == "" {
                    subtype = "No subtype"
                }
                if health == "" {
                    health = "No health"
                }

                var type = [String]()

                for (_, subJson):(String, JSON) in subJson["types"] {
                    type.append(subJson.stringValue)
                }

                var attackTypes = [String]()
                for (_, subJson):(String, JSON) in subJson["attacks"] {
                    attackTypes.append(subJson["name"].stringValue)
                }

                if type.count == 0 {
                    type.append("No type")
                }
                if attackTypes.count == 0 {
                    attackTypes.append("No attackTypes")
                }

                var card = Cards()
                card.id = id
                card.name = name
                card.previewImageUrl = previewImageUrl
                card.fullImageUrl = fullImageUrl
                card.rarity = rarity
                card.subtype = subtype
                card.health = health
                card.type = type
                card.attackTypes = attackTypes
                
                filteredTableViewData.append(card)
            }
            print(filteredTableViewData.count)
            completioHandler?()
        case .failure(let error):
            let arres = error.localizedDescription
            print(arres)
            completioHandler?()
        }
        
    }
    
}
