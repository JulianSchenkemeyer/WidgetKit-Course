//
//  NetworkManager.swift
//  RepoWatcher
//
//  Created by Julian Schenkemeyer on 28.08.22.
//

import Foundation


class NetworkManager {
	static let shared = NetworkManager()
	
	let decoder = JSONDecoder()
	
	private init() {
		// Configure decoder strategies
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
	}
	
	func getRepository(from urlString: String) async throws -> Repository {
		guard let url = URL(string: urlString) else {
			throw NetworkError.invalidURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw NetworkError.invalidResponse
		}
		
		do {
			let repository = try decoder.decode(Repository.self, from: data)
			return repository
		} catch {
			throw NetworkError.invalidData
		}
	}
	
	func downloadImage(from urlString: String) async -> Data? {
		guard let url = URL(string: urlString) else { return nil }
		
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			return data
		} catch {
			return nil
		}
	}
}

enum NetworkError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
}

enum RepoDummyUrl {
	static let swiftNews = "https://api.github.com/repos/sallen0400/swift-news"
	static let publish = "https://api.github.com/repos/johnsundell/publish"
}
