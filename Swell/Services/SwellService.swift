//
//  SwellService.swift
//  Swell
//
//  Created by dhison on 12/3/25.
//

import Foundation

/// Response model matching the Cloudflare Worker's output
struct SwellResponse: Decodable {
  let summary: String
  let reflection: String
}

enum SwellError: LocalizedError {
  case invalidURL
  case encodingError(Error)
  case networkError(Error)
  case invalidResponse(statusCode: Int)
  case decodingError(Error)

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "The application encountered an internal configuration error."
    case .encodingError:
      return "There was a problem preparing your data for the server."
    case .networkError:
      return "Could not connect to the server. Please check your internet connection."
    case .invalidResponse(let statusCode):
      return "The server responded with an error. Status code: \(statusCode)."
    case .decodingError:
      return "There was a problem understanding the server's response."
    }
  }
}

struct SwellService {
  // TODO: Is there a way to use local env vars?
  // private let workerURLString = "https://swell-worker.dhison.workers.dev"
  private let workerURLString = "http://localhost:8787"
  private let session: URLSession
  private let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Match JS default to be safe
    return formatter
  }()

  init(session: URLSession = .shared) {
    self.session = session
  }

  func fetchSwell(waves: [Wave]) async throws -> SwellResponse {
    guard let url = URL(string: workerURLString) else {
      throw SwellError.invalidURL
    }

    let waveDTOs = waves.map { wave in
      WaveDTO(content: wave.content, createdAt: dateFormatter.string(from: wave.createdAt))
    }
    let payload = SwellRequest(waves: waveDTOs)

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      request.httpBody = try JSONEncoder().encode(payload)
    } catch {
      throw SwellError.encodingError(error)
    }

    do {
      let (data, response) = try await session.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse else {
        throw SwellError.networkError(URLError(.badServerResponse))
      }

      guard (200...299).contains(httpResponse.statusCode) else {
        throw SwellError.invalidResponse(statusCode: httpResponse.statusCode)
      }

      return try JSONDecoder().decode(SwellResponse.self, from: data)

    } catch let error as SwellError {
      print(error)
      throw error
    } catch let error as DecodingError {
      print(error)
      throw SwellError.decodingError(error)
    } catch {
      print(error)
      throw SwellError.networkError(error)
    }
  }
}

private struct SwellRequest: Encodable {
  let waves: [WaveDTO]
}

private struct WaveDTO: Encodable {
  let content: String
  let createdAt: String
}


