//
//  Ranks.swift
//  StepCompetition
//
//  Created by Kevin Koscica on 4/20/25.
//

import Foundation

func getRankEmoji(for index: Int) -> String {
    switch index {
    case 0:
        return "🥇"
    case 1:
        return "🥈"  
    case 2:
        return "🥉"
    default:
        return "\(index + 1)."  // For 4th place and onwards, show the rank number
    }
}
