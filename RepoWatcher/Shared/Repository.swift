//
//  Repository.swift
//  RepoWatcher
//
//  Created by Julian Schenkemeyer on 21.08.22.
//

import Foundation

struct Repository: Decodable {
	let name: String
	let owner: Owner
	let hasIssues: Bool
	let forks: Int
	let watchers: Int
	let openIssues: Int
	let pushedAt: String
	
	
	static let placeholder = Repository(name: "Your Repository",
										owner: Owner(avatarUrl: ""),
										hasIssues: true,
										forks: 12,
										watchers: 999,
										openIssues: 16,
										pushedAt: "2022-08-12T18:09:00Z")
}

struct Owner: Decodable {
	let avatarUrl: String
}
