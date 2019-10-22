import Foundation
import RealmSwift

var transportRealmIndex = Int()

class RealmBase: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var birthday: String = ""
    @objc dynamic var avatar: String = ""
    
    var colectionCards = List<CardsRealm>()
    var favoriteCards = List<CardsRealm>()

    // primaryKey  для проверки сохраняемых данных на дублирование
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // indexedProperties  для ускорения чтения данных
    override static func indexedProperties() -> [String] {
        return ["id"]
    }

}

class CardsRealm: Object { // Структура Аnime
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var previewImageUrl: String = ""
    @objc dynamic var fullImageUrl: String = ""
    @objc dynamic var previewImageData: Data = Data()
    @objc dynamic var fullImageData: Data = Data()
    @objc dynamic var rarity: String = ""
    @objc dynamic var subtype: String = ""
    @objc dynamic var health: String = ""
    var type = List<String>()
    var attackTypes = List<String>()

}

// Сохраниение данных в реалм
func realmSave() {
    DispatchQueue.global().async {
        
        let pokemonProfile = PokemonProfile.instance
        let testEntyty = RealmBase()
        testEntyty.id = 1
        testEntyty.name = "Test"
        testEntyty.birthday = "20.20.2020"
        testEntyty.avatar = "Test"
        
        if pokemonProfile.colectionCards.count > 0 {
            for i in 1...pokemonProfile.colectionCards.count {
                let card = CardsRealm()
                card.id = pokemonProfile.colectionCards[i-1].id
                card.name = pokemonProfile.colectionCards[i-1].name
                card.previewImageUrl = pokemonProfile.colectionCards[i-1].previewImageUrl
                card.fullImageUrl = pokemonProfile.colectionCards[i-1].fullImageUrl
                card.previewImageData = pokemonProfile.colectionCards[i-1].previewImageData
                card.fullImageData = pokemonProfile.colectionCards[i-1].fullImageData
                card.rarity = pokemonProfile.colectionCards[i-1].rarity
                card.subtype = pokemonProfile.colectionCards[i-1].subtype
                card.health = pokemonProfile.colectionCards[i-1].health
                
                if pokemonProfile.colectionCards[i-1].type.count != 0 {
                    let list = List<String>()
                    for k in 1...pokemonProfile.colectionCards[i-1].type.count {
                        list.append(pokemonProfile.colectionCards[i-1].type[k-1])
                    }
                    card.type = list
                }
                
                if pokemonProfile.colectionCards[i-1].attackTypes.count != 0 {
                    let list = List<String>()
                    for k in 1...pokemonProfile.colectionCards[i-1].attackTypes.count {
                        list.append(pokemonProfile.colectionCards[i-1].attackTypes[k-1])
                    }
                    card.attackTypes = list
                }
                testEntyty.colectionCards.append(card)
            }
        }
        
        if pokemonProfile.favoriteCards.count > 0 {
            for i in 1...pokemonProfile.favoriteCards.count {
                let card = CardsRealm()
                card.id = pokemonProfile.favoriteCards[i-1].id
                card.name = pokemonProfile.favoriteCards[i-1].name
                card.previewImageUrl = pokemonProfile.favoriteCards[i-1].previewImageUrl
                card.fullImageUrl = pokemonProfile.favoriteCards[i-1].fullImageUrl
                card.previewImageData = pokemonProfile.favoriteCards[i-1].previewImageData
                card.fullImageData = pokemonProfile.favoriteCards[i-1].fullImageData
                card.rarity = pokemonProfile.favoriteCards[i-1].rarity
                card.subtype = pokemonProfile.favoriteCards[i-1].subtype
                card.health = pokemonProfile.favoriteCards[i-1].health
                
                if pokemonProfile.favoriteCards[i-1].type.count != 0 {
                    let list = List<String>()
                    for k in 1...pokemonProfile.favoriteCards[i-1].type.count {
                        list.append(pokemonProfile.favoriteCards[i-1].type[k-1])
                    }
                    card.type = list
                }
                
                if pokemonProfile.favoriteCards[i-1].attackTypes.count != 0 {
                    let list = List<String>()
                    for k in 1...pokemonProfile.favoriteCards[i-1].attackTypes.count {
                        list.append(pokemonProfile.favoriteCards[i-1].attackTypes[k-1])
                    }
                    card.attackTypes = list
                }
                testEntyty.favoriteCards.append(card)
            }
        }
        
        
        DispatchQueue.main.async {
            
            guard let realm =  try? Realm() else {
                print("Error Realm")
                return
            }
            
            let object = realm.objects(RealmBase.self)
            if object.count > 0 {
                guard let base = Optional(object[transportRealmIndex]) else {
                    return
                }
                
                try! realm.write {
                    realm.delete(base)
                    print("delete base")
                }
            }
            
            do {
                let realm = try Realm()
                print(realm.configuration.fileURL as Any)
                realm.beginWrite()
                realm.add(testEntyty)
                try realm.commitWrite()
                
            } catch {
                print(error)
            }
        }
    }
}

// Загрузка данных из реалм
func realmLoad(index: Int) -> RealmBase {
    guard let realm =  try? Realm() else {
        print("Error Realm")
        return RealmBase()
    }
    let object = realm.objects(RealmBase.self)
    guard let base = Optional(object[index]) else {
        return RealmBase()
    }
    
    return base
}

// Загрузка аниме из List в Array ( Colection Cards )
func realmLoadColectionCards() {
    let pokemonProfile = PokemonProfile.instance
    let realm = realmLoad(index: transportRealmIndex)
    
    if realm.colectionCards.count != 0 {
   
        for i in 1...realm.colectionCards.count {
            var card = Cards()
            card.id = realm.colectionCards[i-1].id
            card.name = realm.colectionCards[i-1].name
            card.previewImageUrl = realm.colectionCards[i-1].previewImageUrl
            card.fullImageUrl = realm.colectionCards[i-1].fullImageUrl
            card.previewImageData = realm.colectionCards[i-1].previewImageData
            card.fullImageData = realm.colectionCards[i-1].fullImageData
            card.rarity = realm.colectionCards[i-1].rarity
            card.subtype = realm.colectionCards[i-1].subtype
            card.health = realm.colectionCards[i-1].health

            
            if realm.colectionCards[i-1].type.count != 0 {
                var base = [String]()
                for k in 1...realm.colectionCards[i-1].type.count {
                    base.append(realm.colectionCards[i-1].type[k-1])
                }
                card.type = base
            }
            
            if realm.colectionCards[i-1].attackTypes.count != 0 {
                var base = [String]()
                for m in 1...realm.colectionCards[i-1].attackTypes.count {
                    base.append(realm.colectionCards[i-1].attackTypes[m-1])
                }
                card.attackTypes = base
            }
            pokemonProfile.colectionCards.append(card)
        }
    }
}

// Загрузка аниме из List в Array ( Favorite Cards )
func realmLoadFavoriteCards() {
    let pokemonProfile = PokemonProfile.instance
    let realm = realmLoad(index: transportRealmIndex)
    
    if realm.favoriteCards.count != 0 {

        for i in 1...realm.favoriteCards.count {
            var card = Cards()
            card.id = realm.favoriteCards[i-1].id
            card.name = realm.favoriteCards[i-1].name
            card.previewImageUrl = realm.favoriteCards[i-1].previewImageUrl
            card.fullImageUrl = realm.favoriteCards[i-1].fullImageUrl
            card.previewImageData = realm.favoriteCards[i-1].previewImageData
            card.fullImageData = realm.favoriteCards[i-1].fullImageData
            card.rarity = realm.favoriteCards[i-1].rarity
            card.subtype = realm.favoriteCards[i-1].subtype
            card.health = realm.favoriteCards[i-1].health

            
            if realm.favoriteCards[i-1].type.count != 0 {
                var base = [String]()
                for k in 1...realm.favoriteCards[i-1].type.count {
                    base.append(realm.favoriteCards[i-1].type[k-1])
                }
                card.type = base
            }
            
            if realm.favoriteCards[i-1].attackTypes.count != 0 {
                var base = [String]()
                for m in 1...realm.favoriteCards[i-1].attackTypes.count {
                    base.append(realm.favoriteCards[i-1].attackTypes[m-1])
                }
                card.attackTypes = base
            }
            pokemonProfile.favoriteCards.append(card)
        }
    }
}

