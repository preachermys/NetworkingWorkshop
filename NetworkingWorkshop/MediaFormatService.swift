//
//  MediaFormatService.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 31.03.2021.
//

import UIKit

enum MediaFormatService {
    private enum Constants {
        enum Quality {
            static let `default`: String = "default"
            static let separator: Character = "x"
            static let pointSeparator: Character = "."
        }
                
        enum Offset {
            static let fromSides: CGFloat = 40
        }
        
        enum Version: String {
            case placeholder = "{{version}}"
        }
        
        enum Extension: String {
            case placeholder = "{{ext}}"
        }
    }
    
    enum VideoVersion: String, CaseIterable {
        case original
        case p1080 = "1080p"
        case p720 = "720p"
        case p480 = "480p"
        case p360 = "360p"
    }
    
    enum VideoExtension: String {
        case m3u8
        case mp4
    }
    
    enum ImageExtension: String, CaseIterable {
        case jpg
        case png
        case webp
    }
    
    static func getFormattedVideo(from videoDictionary: [String: Any], version: VideoVersion? = nil, videoExt: VideoExtension = .mp4) -> [String] {
        var videos: [String] = []

        if let videoVersion = version, let fullUrl = getUrl(from: videoDictionary, version: videoVersion.rawValue, mediaExt: videoExt.rawValue) {
            return [fullUrl]
        }
        
        for version in VideoVersion.allCases {
            if let fullUrl = getUrl(from: videoDictionary, version: version.rawValue, mediaExt: VideoExtension.m3u8.rawValue) {
                videos.append(fullUrl)
            } else if let fullUrl = getUrl(from: videoDictionary, version: version.rawValue, mediaExt: VideoExtension.mp4.rawValue) {
                videos.append(fullUrl)
            }
        }
                
        return videos
    }
    
    static func isYoutubeVideo(from videoDictionary: [String: Any]) -> Bool {
        if videoDictionary["external_platform"] as? String == "youtube" {
            return true
        }
        
        return false
    }
    
    static func getFormattedImage(from imageDictionary: [String: Any], imageExt: ImageExtension? = nil) -> String {
        
        let availableVersions = getAvailableVersions(from: imageDictionary)
        let version = findSuitableVersion(from: availableVersions)
    
        if let ext = imageExt, let fullUrl = getUrl(from: imageDictionary, version: version, mediaExt: ext.rawValue) {
            return fullUrl
        }
        
        for ext in ImageExtension.allCases {
            if let fullUrl = getUrl(from: imageDictionary, version: version, mediaExt: ext.rawValue) {
                return fullUrl
            }
        }
            
        return ""
    }
        
    static func getAvailableVersions(from imageDictionary: [String: Any]) -> [String] {
        if let versions = imageDictionary["versions"] as? [[String: Any]] {
            let availableVersions = versions.compactMap({ ($0["version"] as? String) })
            
            return availableVersions
        }
        
        return []
    }
    
    static func getAvailableImages(from imagesDictionary: [String: Any]) -> [String] {
        var urls: [String] = []
        
        if let versions = imagesDictionary["versions"] as? [[String: Any]] {
            let availableVersions = versions.compactMap({ ($0["version"] as? String) })
    
            availableVersions.forEach { version in
                ImageExtension.allCases.forEach { ext in
                    if let url = getUrl(from: imagesDictionary, version: version, mediaExt: ext.rawValue) {
                        urls.append(url)
                    }
                }
            }
        }
        
        return urls
    }
    
    static func getVersions(from urls: [String]) -> [String] {
        var versions: Set<String> = []
        
        ImageExtension.allCases.forEach { ext in
            urls.forEach { url in
                if url.contains(ext.rawValue) {
                    let version = String(url.replacingOccurrences(of: ext.rawValue, with: "")
                        .dropLast())
                        .getSubstring(to: Constants.Quality.pointSeparator, from: .end)
                    
                    versions.insert(version)
                }
            }
        }
        
        return Array(versions)
    }
    
    static func findSuitableVersion(in versions: [String], needHighQuality: Bool, with width: CGFloat) -> String? {
        let widthInPixels = width * UIScreen.main.scale
        
        if needHighQuality {
            let sortedVersions = versions.filter({ $0 != Constants.Quality.default })
                .map({ String($0.drop(while: { $0 != Constants.Quality.separator }).dropFirst()) })
                .compactMap({ CGFloat(Int($0) ?? 0) })
                .sorted(by: <)
            if let width = sortedVersions.first(where: { $0 >= widthInPixels }),
               let version = versions.first(where: { width > 0 && $0.contains("\(Int(width))") }) {
                
                return version
            }
        } else {
//            if let width = versions.filter({ $0 != Constants.Quality.default })
//                     .map({ String($0.drop(while: { $0 != Constants.Quality.separator }).dropFirst()) })
//                     .compactMap({ CGFloat(Int($0) ?? 0) })
//                     .sorted(by: >)
//                     .first(where: { $0 <= widthInPixels }),
//                let version = versions.first(where: { width > 0 && $0.contains("\(Int(width))") }) {
//
//                return version
//            }
        }

        return Constants.Quality.default
    }
    
    static func getImageExtensions(from images: [String]) -> [String] {
        let extensions = Set(images.map { $0.getSubstring(to: Constants.Quality.pointSeparator, from: .end) })
        
        return Array(extensions)
    }
    
    static func getSuitableExtension(from extensions: [String]) -> String? {
        for ext in ImageExtension.allCases {
            if let `extension` = extensions.first(where: { $0 == ext.rawValue }) {
                return `extension`
            }
        }
        
        return nil
    }
    
    static func getFormattedImage(from images: [String], needHighQuality: Bool = false, basedOn width: CGFloat) -> URL? {
        let versions = getVersions(from: images)
        let extensions = getImageExtensions(from: images)
        
        guard let suitableVersion = findSuitableVersion(in: versions, needHighQuality: needHighQuality, with: width),
            let suitableExtension = getSuitableExtension(from: extensions), !images.isEmpty else { return nil }
        
        if let image = images.first(where: { $0.contains(suitableExtension) && $0.contains(suitableVersion) }) {
            return URL(string: image)
        }
        
        return URL(string: images[0])
    }
    
    static func getUrl(from mediaDictionary: [String: Any], version: String, mediaExt: String) -> String? {
        if let url = mediaDictionary["url"] as? String,
            let versions = mediaDictionary["versions"] as? [[String: Any]],
            versions.first(where: { ($0["version"] as? String) == version }) != nil,
            let index = versions.firstIndex(where: { ($0["version"] as? String) == version }),
            let resolution = versions[index]["ext"] as? [String: Any] {
            let extArray = Array(resolution.keys)
            if extArray.first(where: { $0 == mediaExt }) != nil {
                
                let urlWithVersion = url.replacingOccurrences(of: "{{version}}", with: version)
                let fullUrl = urlWithVersion.replacingOccurrences(of: "{{ext}}", with: mediaExt)
                
                return fullUrl
            }
        }
        
        return nil
    }
    
    static func findSuitableVersion(from versions: [String]) -> String {
        let widthInPixels = (UIScreen.main.bounds.width - Constants.Offset.fromSides) * UIScreen.main.scale

//        if let width = versions.filter({ $0 != Constants.Quality.default })
//            .map({ String($0.drop(while: { $0 != Constants.Quality.separator }).dropFirst()) })
//            .compactMap({ CGFloat(Int($0) ?? 0) })
//            .sorted(by: >)
//            .first(where: { $0 <= widthInPixels }),
//            let version = versions.first(where: { width > 0 && $0.contains("\(Int(width))") }) {
//            
//            return version
//        }
        
        return Constants.Quality.default
    }
    
    static func getAudioLink(from audioDictionary: [String: Any]) -> String {

        if let startUrl = audioDictionary["url"] as? String,
            let versions = audioDictionary["versions"] as? [[String: Any]],
            let version = versions.first, let neededVersion = version["version"] as? String,
            let ext = versions.first, let neededExt = ext["ext"] as? [String: Any],
            let extensionKey = neededExt.keys.first {
            
            return startUrl.replacingOccurrences(of: Constants.Version.placeholder.rawValue,
                                                 with: neededVersion)
                            .replacingOccurrences(of: Constants.Extension.placeholder.rawValue,
                                                  with: extensionKey)
        }
        
        return ""
    }
    
    static func getDefaultImageQuality(from url: String) -> String {
        if let ext = ImageExtension.allCases.first(where: { url.contains($0.rawValue) })?.rawValue {
            return String(url.dropLast(ext.count + 1)
                    .reversed()
                    .drop(while: { $0 != Constants.Quality.pointSeparator })
                    .reversed())
                    .appending("\(Constants.Quality.default)\(Constants.Quality.pointSeparator)\(ext)")
        }
        
        return url
    }
}

extension String {
    enum Distination {
        case start
        case end
    }
    
    func getSubstring(to character: Character, from distination: Distination = .start) -> String {
        var string = self
        var result: String = ""
                
        while distination == .end ? string.last != character : string.first != character, !string.isEmpty {
            result.insert(distination == .end ? string.removeLast() : string.removeFirst(),
                          at: result.startIndex)
        }
                
        return result
    }
}

