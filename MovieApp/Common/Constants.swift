//
//  Constants.swift
//  MovieApp
//
//  Created by Dimas Wisodewo on 17/07/24.
//

import Foundation

struct Constants {
    static let API_KEY = "a6d711b26775a0f8071fec618c79bd64"
    static let accessTokenAuth = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJhNmQ3MTFiMjY3NzVhMGY4MDcxZmVjNjE4Yzc5YmQ2NCIsIm5iZiI6MTcyMTIzMTUzMC40MTU1NDgsInN1YiI6IjYzY2RmZDU1N2FlY2M2MDA4YWYxMTY5NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._H0d9EMG_WKuK8wwDUMLstDZ2I6ntuj50lRd6i0RtWs"
    static let tmdbBaseURL = "https://api.themoviedb.org/3/"
    static let imagePreviewBaseURL = "https://image.tmdb.org/t/p/w500/"
    static let imageBackdropBaseURL = "https://image.tmdb.org/t/p/w1280/"
    static let tmdbHeader = [
        "accept": "application/json",
        "Authorization": "Bearer \(Constants.accessTokenAuth)"
    ]
    
    static let YouTube_API_KEY = "AIzaSyCg10bS0mz18S_nqaMrntWwvRf5fXK4AdA"
    static let Youtube_BaseURL = "https://youtube.googleapis.com/youtube/v3/"
    static let youtubeVideoEmbedBaseURL = "https://www.youtube.com/embed/"
}
