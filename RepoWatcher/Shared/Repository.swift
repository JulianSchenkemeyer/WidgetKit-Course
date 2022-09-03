//
//  Repository.swift
//  RepoWatcher
//
//  Created by Julian Schenkemeyer on 21.08.22.
//

import Foundation

struct Repository {
	let name: String
	let owner: Owner
	let hasIssues: Bool
	let forks: Int
	let watchers: Int
	let openIssues: Int
	let pushedAt: String
	
	var avatarData: Data
}

extension Repository {
	struct CodingData: Decodable {
		let name: String
		let owner: Owner
		let hasIssues: Bool
		let forks: Int
		let watchers: Int
		let openIssues: Int
		let pushedAt: String
		
		
		var repository: Repository {
			Repository(name: name,
					   owner: owner,
					   hasIssues: hasIssues,
					   forks: forks,
					   watchers: watchers,
					   openIssues: openIssues,
					   pushedAt: pushedAt,
					   avatarData: Data())
		}
	}
}

struct Owner: Decodable {
	let avatarUrl: String
}
