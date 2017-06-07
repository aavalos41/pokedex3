//
//  PokeCell.swift
//  pokedex
//
//  Created by alf ac on 4/19/17.
//  Copyright © 2017 alf ac. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon){
        
    
        nameLbl.text = pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
    
    }
    
    
    
}
