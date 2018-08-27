//
//  BoardModel.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation

class Person {
    
    var id: String
    var firstName: String
    var lastName: String
    var roles: [Role] // Must be array due to possibility of dual roles
    
    enum Role: String {
        case consejero = "CONSEJERO"
        case presidente = "PRESIDENTE"
        case secretario = "SECRETARIO"
        case administrador = "ADMINISTRADOR"
        case invitado = "INVITADO"
    }
    
    init(firstName: String, lastName: String, roles: [Role]) {
        self.firstName = firstName
        self.lastName = lastName
        self.roles = roles
        self.id = generateId()
    }
}



class Location {
    var name: Name
    var meetings: [Meeting]
    
    enum Name: String {
        case sala1 = "SALA 1"
        case sala2 = "SALA 2"
        case sala3 = "SALA 3"
        case sala4 = "SALA 4"
    }
    
    init(name: Name, meetings: [Meeting] ) {
        self.name = name
        self.meetings = meetings
    }
}

class Meeting {
    var participants: [Person]
    var topics: [Topic]
    var location: Location
    var totalDuration: TimeInterval {
        get {
            // Return added seconds from topics
            var duration = TimeInterval()
            for topic in topics {
                duration += topic.duration
            }
            return duration
        }
    }
    
    init(participants: [Person], topics: [Topic], location: Location) {
        self.participants = participants
        self.topics = topics
        self.location = location
    }
}

class Topic {
    var title: String
    var objective: String
    var pointsToDiscuss: [DiscussionPoint]
    var duration: TimeInterval
    var fileURLs: [String]?
    
    init(title: String, objective: String, pointsToDiscuss: [DiscussionPoint], duration: TimeInterval) {
        self.title = title
        self.objective = objective
        self.pointsToDiscuss = pointsToDiscuss
        self.duration = duration
    }
}

class DiscussionPoint {
    var point: String
    
    // Una vez que se haya discutido el punto, se llenan los variables:
    var agreement: String?
    var ballot: Ballot?
    
    init(point: String) {
        self.point = point
    }
}

class Ballot {
    var question: String
    var vote: [BallotOption]
    var resolution: BallotOption {
        get {
            var winningOption = BallotOption(title: "", voteCount: 0)
            for option in vote {
                if option.voteCount > winningOption.voteCount {
                    winningOption = option
                }
            }
            return winningOption
        }
    }
    
    init(question: String, vote: [BallotOption]) {
        self.question = question
        self.vote = vote
    }
}

class BallotOption {
    var title: String
    var voteCount: Int
    init(title: String, voteCount: Int) {
        self.title = title
        self.voteCount = voteCount
    }
}

func generateId() -> String { // Possibly use name to create ID
    return "an id"
}
