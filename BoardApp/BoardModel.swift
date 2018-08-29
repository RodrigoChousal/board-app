//
//  BoardModel.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/27/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Global {
    static var localUser: LocalUser? // Optional because users can enter as visitors
    static let databaseRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
}

class Person {
    
    var id: String
    var firstName: String
    var lastName: String
    var fullName: String {
        return firstName + " " + lastName
    }
    
    enum Role: String {
        case consejero = "CONSEJERO"
        case presidente = "PRESIDENTE"
        case secretario = "SECRETARIO"
        case administrador = "ADMINISTRADOR"
        case invitado = "INVITADO"
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = generateId()
    }
}

// Userful for storing authentication credentials
class LocalUser: Person {
    var username: String
    var meetings: [Meeting]
    
    init(username: String, firstName: String, lastName: String, meetings: [Meeting]) {
        self.username = username
        self.meetings = meetings
        super.init(firstName: firstName, lastName: lastName)
    }
}

struct Credentials {
    var email: String
    var password: String
}

class Location {
    var name: ValidName
    var meetings: [Meeting]?
    
    enum ValidName: String {
        case sala1 = "SALA 1"
        case sala2 = "SALA 2"
        case sala3 = "SALA 3"
        case sala4 = "SALA 4"
    }
    
    init(name: ValidName) {
        self.name = name
    }
}

class Meeting {
    var title: String
    var participants: [Person.Role : Person]
    var topics: [Topic]
    var location: Location
    var timeDate: Date
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
    var participantList: String {
        get {
            var list = ""
            var count = 0
            for participant in participants {
                list += participant.value.fullName
                count += 1
                if count != participants.count {
                    list += ", "
                }
            }
            return list
        }
    }
    var topicList: String {
        get {
            var list = ""
            var count = 0
            for topic in topics {
                list += topic.title
                count += 1
                if count != topics.count {
                    list += ", "
                }
            }
            return list
        }
    }
    var fileCount: Int {
        get {
            var count = 0
            for topic in topics {
                if let list = topic.fileURLs {
                    count += list.count
                }
            }
            return count
        }
    }
    var progress: TimeInterval? // Only relevant if meeting has begun
    
    func pause() {
        // Record time since meeting started and pause UI
    }
    
    func end() {
        // Store meeting information in safe place for future reference
    }
    
    init(title: String, timeDate: Date, participants: [Person.Role : Person], topics: [Topic], location: Location) {
        self.title = title
        self.timeDate = timeDate
        self.participants = participants
        self.topics = topics
        self.location = location
    }
    
    init(fromDictionary meetingsDictionary: NSDictionary) {
        self.title = DatabaseManager.validTitle(fromString: meetingsDictionary.value(forKey: "title") as? String ?? "")
        self.timeDate = DatabaseManager.validDate(fromString: meetingsDictionary.value(forKey: "timeDate") as? String ?? "")
        self.participants = DatabaseManager.validParticipants(fromDictionary: meetingsDictionary.value(forKey: "participants") as? NSDictionary ?? NSDictionary())
        self.topics = DatabaseManager.validTopics(fromArray: meetingsDictionary.value(forKey: "topics") as? NSArray ?? NSArray())
        self.location = DatabaseManager.validLocation(fromString: meetingsDictionary.value(forKey: "location") as? String ?? "")
    }
}

class Topic {
    var color: UIColor
    var title: String
    var objective: String
    var pointsToDiscuss: [DiscussionPoint]
    var duration: TimeInterval
    var responsible: Person
    var fileURLs: [String]?
    
    init(color: UIColor, title: String, responsible: Person, objective: String, pointsToDiscuss: [DiscussionPoint], duration: TimeInterval) {
        self.color = color
        self.title = title
        self.responsible = responsible
        self.objective = objective
        self.pointsToDiscuss = pointsToDiscuss
        self.duration = duration
    }
}

class DiscussionPoint {
    var point: String
    var date: String? // Don't understand why this is needed but it is included in wireframe
    
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
    
    func close() {
        // Close ballot so no more votes are counted
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
