//
//  Pokemon.swift
//  pokedex
//
//  Created by alf ac on 4/18/17.
//  Copyright © 2017 alf ac. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _pokemonURL: String!
    
    var nextEvoName: String {
        if _nextEvoName == nil{
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil{
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil{
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    
    var nextEvoText: String {
        if _nextEvoText == nil{
            _nextEvoText = ""
        }
        return _nextEvoText
    }
    
    var attack : String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    var weight : String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    var height : String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var defense : String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var type : String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    
    
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId ?? 0)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        Alamofire.request( _pokemonURL).responseJSON {(response) in
            if let dict = response.result.value as? Dictionary<String, Any> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
                
                if let typesList = dict["types"] as? [Dictionary<String, String>] , typesList.count > 0 {
                    var count = 0
                    var names = ""
                    
                    for type in typesList {
                        
                        if let name = type["name"] {
                            
                            //Add the comma delimiter between types
                            if count > 0 {
                                names += ", "
                            }
                            
                            names += name.capitalized
                            count += 1
                        }
                    }
                    
                    self._type = names
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    if let url =  descArr[0]["resource_uri"] {
                        let DescURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(DescURL).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String,Any>{
                                
                                if let description = descDict["description"] as? String {
                                    let newDesc  = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDesc
                                    print(newDesc)
                                }
                                
                            }
                            completed()
                        })
                    }
                }else{
                    self._description = ""
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String,Any>], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExist = evolutions[0]["level"]{
                                    if let  lvl = lvlExist as? Int {
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                }else{
                                    self._nextEvoLvl = ""
                                }
                            }
                        }
                    }
                    print("***")
                    print(self.nextEvoLvl)
                    print(self.nextEvoId)
                    print(self.nextEvoName)
                    print("...")
                    
                }
                
            }
            completed()
        }
    }
}
