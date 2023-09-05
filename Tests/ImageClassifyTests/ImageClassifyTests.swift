import XCTest
@testable import ImageClassify

enum TestsErrors: Error {
    case pathError
    case invalidImage
    case cgImage
}

final class ImageClassifyTests: XCTestCase {
    func testExample() throws {
        // XCTest Documenation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        
        throw XCTSkip("Please help me understand how to load this test image...")
        
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: "plane", ofType: "jpg") else {
            throw(TestsErrors.pathError)
        }
        
        guard let im = NSImage(byReferencingFile:path) else {
            throw(TestsErrors.invalidImage)
        }
        

        guard let cgImage = im.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw(TestsErrors.cgImage)
        }
        
        let cl = ClassifyImage()
        let rsp = cl.ProcessImage(image: cgImage)
        
        print(rsp)
    }
}
