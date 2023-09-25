//
//  EndPointComponents.swift
//  MyLOSTARK
//
//  Created by dhoney96 on 2023/07/17.
//

enum Path {
    case notice
    case event
    case calendar
    case profile(String)
    case equipment(String)
    
    var list: [String] {
        switch self {
        case .notice:
            return ["news", "notices"]
        case .event:
            return ["news", "events"]
        case .calendar:
            return ["gamecontents", "calendar"]
        case .profile(let name):
            return ["armories", "characters", name, "profiles"]
        case .equipment(let name):
            return ["armories", "characters", name, "equipment"]
        }
    }
}

struct Parameter {
    let key: String
    let value: String?
}

enum HTTPMethod: String {
    case get = "GET"
}

struct Headers {
    let accept: String
    let authorization: String
    
    init(
        accept: String = "application/json",
        authorization: String
    ) {
        self.accept = accept
        self.authorization = "bearer \(authorization)"
    }
}

// MARK: Character Profile FilterCondition
enum FilterCondition {
    case all
    case profile
    case equipment
    case avatars
    case combatSkills
    case engravings
    case cards
    case gems
    
    var value: String? {
        switch self {
        case .all:
            return nil
        case .profile:
            return "profiles+"
        case .equipment:
            return "equipment+"
        case .avatars:
            return "avatars+"
        case .combatSkills:
            return "combat-skills+"
        case .engravings:
            return "engravings+"
        case .cards:
            return "cards+"
        case .gems:
            return "gems+"
        }
    }
}
