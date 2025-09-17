// Created by Denis Mandych on 06.09.2025

import Foundation
import LibXray

public protocol XrayProviding: Actor {
    nonisolated var isRunning: Bool { get }
    nonisolated var version: String { get }

    func start(config: Data, datDir: String) throws
    func stop() throws
}

public extension XrayProviding {
    func start(config: Data) throws {
        try start(config: config, datDir: NSTemporaryDirectory())
    }
}

public enum XrayError: LocalizedError {
    case callFailed(message: String)
    case invalidResponse

    public var errorDescription: String? {
        switch self {
        case .callFailed(let msg): return msg
        case .invalidResponse: return "Invalid response from LibXray"
        }
    }
}

private struct RunXrayFromJSONRequest: Codable {
    let datDir: String
    let configJSON: String
}

public actor XrayProvider: XrayProviding {
    public init() {}

    public nonisolated var isRunning: Bool {
        LibXrayGetXrayState()
    }

    public nonisolated var version: String {
        LibXrayXrayVersion()
    }

    public func start(config: Data, datDir: String) throws {
        guard let jsonString = String(data: config, encoding: .utf8) else {
            throw XrayError.callFailed(message: "Config is not UTF-8 JSON")
        }

        let request = RunXrayFromJSONRequest(datDir: datDir, configJSON: jsonString)
        let encoded = try JSONEncoder().encode(request)
        let base64 = encoded.base64EncodedString()

        let result = LibXrayRunXrayFromJSON(base64)
        try unwrapBase64Response(result)
    }

    public func stop() throws {
        let result = LibXrayStopXray()
        try unwrapBase64Response(result)
    }

    private func unwrapBase64Response(_ str: String?) throws {
        guard let str = str,
              let data = Data(base64Encoded: str) else {
            throw XrayError.invalidResponse
        }
        guard let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw XrayError.invalidResponse
        }
        if let errMsg = obj["error"] as? String, !errMsg.isEmpty {
            throw XrayError.callFailed(message: errMsg)
        }
    }
}
