// taken from Argo: https://github.com/thoughtbot/Argo/blob/td-swift-2/ArgoTests/JSON/JSONFileReader.swift
import Foundation

func JsonFromFile(file: String) -> AnyObject? {
    return NSBundle(forClass: JsonFileReader.self)
        .pathForResource(file, ofType: "json")
        .flatMap { NSData(contentsOfFile: $0) }
        .flatMap(JSONObjectWithData)
}

private func JSONObjectWithData(data: NSData) -> AnyObject? {
    do {
        return try NSJSONSerialization.JSONObjectWithData(data, options: [])
    }
    catch {
        return .None
    }
}

private class JsonFileReader { }
