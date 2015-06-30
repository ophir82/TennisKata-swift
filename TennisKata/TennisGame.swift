//
//  Tennis.swift
//  TennisKata
//
//  Created by opaz on 15/06/15.
//  Copyright © 2015 Snapp. All rights reserved.
//

import Foundation

enum Player {
    case Player1
    case Player2
}

class TennisGame {
    
    enum Score {
        case Points(player1:Int, player2:Int)
        case Advantage(player:Player)
        case Win(player:Player)
        
        func increment(player:Player) -> Score {
            switch self {
            case let .Advantage(p) where p == player:
                return .Win(player:player)
            
            case let .Advantage(p) where p != player:
                return .Points(player1:40, player2:40)
            
            case .Points(40, 40):
                return .Advantage(player: player)

            case let .Points(v1, v2) where player == .Player1:
                return .Points(player1: nextPoints(v1), player2: v2)
                
            case let .Points(v1, v2) where player == .Player2:
                return .Points(player1: v1, player2: nextPoints(v2))
            
            default:
                return self
            }
        }
        
        func nextPoints(p:Int) -> Int {
            return p < 30 ? p+15 : 40
        }
    }

    func score(history:[Player]) -> Score {
        return history.reduce(.Points(player1:0, player2:0), combine: { $0.increment($1) } )
    }
}

extension TennisGame {
    func scoreString(name1 name1:String, name2:String, history:[Player]) -> String {
        let nameOf = { $0 == Player.Player1 ? name1 : name2 }
        
        switch score(history) {
        case .Points(40, 40):
            return "Deuce"
            
        case let .Points(v1, v2) where v1 == v2 && v1 >= 15:
            return "\(v1) A"
            
        case let .Points(v1, v2):
            return "\(name1): \(v1) - \(name2): \(v2)"
            
        case let .Advantage(player):
            return "Adv \(nameOf(player))"
            
        case let .Win(player):
            return "\(nameOf(player)) wins"            
        }
    }
}