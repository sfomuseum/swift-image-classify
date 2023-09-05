import Foundation
import Vision

@available(macOS 10.15, *)
public struct ClassifyImageResponse: Codable {
    public var categories:[String: VNConfidence]
    public var searchTerms : [String: VNConfidence]
}

@available(macOS 10.15, *)
public struct ImageClassify {

    let req = VNRecognizeTextRequest()
    
    public init() {
    }
    
    public func ProcessImage(image: CGImage) -> Result<ClassifyImageResponse, Error> {
                
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        let req = VNClassifyImageRequest()

        let categories: [String: VNConfidence]
        let searchTerms: [String: VNConfidence]
        
        do {
            try handler.perform([req])
        } catch {
            return .failure(error)
        }
        
        guard let observations = req.results else {
            categories = [:]
            searchTerms = [:]
            let rsp = ClassifyImageResponse(categories: categories, searchTerms: searchTerms)
            return .success(rsp)
        }
        
        categories = observations
            .filter { $0.hasMinimumRecall(0.01, forPrecision: 0.9) }
            .reduce(into: [String: VNConfidence]()) { dict, observation in dict[observation.identifier] = observation.confidence }
            
        searchTerms = observations
            .filter { $0.hasMinimumPrecision(0.01, forRecall: 0.7) }
            .reduce(into: [String: VNConfidence]()) { (dict, observation) in dict[observation.identifier] = observation.confidence }
    
        let rsp = ClassifyImageResponse(categories: categories, searchTerms: searchTerms)
        return .success(rsp)
    }
}
