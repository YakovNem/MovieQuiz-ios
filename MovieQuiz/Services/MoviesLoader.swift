//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Yakov Nemychenkov on 16.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_s5z5b7qx") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }


    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch let error {
                    handler(.failure(error))
                }
            }
        }
    
    }
}

