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
        return "🥇"  // Gold medal emoji for 1st place
    case 1:
        return "🥈"  // Silver medal emoji for 2nd place
    case 2:
        return "🥉"  // Bronze medal emoji for 3rd place
    default:
        return "\(index + 1)."  // For 4th place and onwards, show the rank number
    }
}
