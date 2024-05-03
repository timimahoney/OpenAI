//
//  Tool.swift
//  
//
//  Created by Tim Mahoney on 5/2/24.
//

import Foundation

public struct Tool: Codable, Equatable {

    public let type: Self.ToolType
    
    public let function: Self.FunctionDefinition

    public init(
        function: Self.FunctionDefinition
    ) {
        self.function = function
        self.type = .function
    }
    
    public static func function(
        name: String,
        description: String? = nil,
        parameters: Self.FunctionDefinition.Parameters? = nil
    ) -> Tool {
        let function = FunctionDefinition(name: name, description: description, parameters: parameters)
        return Self(function: function)
    }
    
    public static func function(_ definition: Self.FunctionDefinition) -> Tool {
        return Self(function: definition)
    }

    public struct FunctionDefinition: Codable, Equatable {
        /// The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
        public let name: String

        /// The description of what the function does.
        public let description: String?

        /// The parameters the functions accepts, described as a JSON Schema object.
        /// https://platform.openai.com/docs/guides/text-generation/function-calling
        /// https://json-schema.org/understanding-json-schema/
        /// **Python library defines only [String: Object] dictionary.
        public let parameters: Self.Parameters?

        public init(
            name: String,
            description: String? = nil,
            parameters: Self.Parameters? = nil
        ) {
            self.name = name
            self.description = description
            self.parameters = parameters
        }

        /// See the [guide](/docs/guides/gpt/function-calling) for examples, and the [JSON Schema reference](https://json-schema.org/understanding-json-schema/) for documentation about the format.
        public struct Parameters: Codable, Equatable {

            public let type: Self.JSONType
            public let properties: [String: Property]?
            public let required: [String]?
            public let pattern: String?
            public let const: String?
            public let `enum`: [String]?
            public let multipleOf: Int?
            public let minimum: Int?
            public let maximum: Int?

            public init(
                type: Self.JSONType,
                properties: [String : Property]? = nil,
                required: [String]? = nil,
                pattern: String? = nil,
                const: String? = nil,
                enum: [String]? = nil,
                multipleOf: Int? = nil,
                minimum: Int? = nil,
                maximum: Int? = nil
            ) {
                self.type = type
                self.properties = properties
                self.required = required
                self.pattern = pattern
                self.const = const
                self.`enum` = `enum`
                self.multipleOf = multipleOf
                self.minimum = minimum
                self.maximum = maximum
            }

            public struct Property: Codable, Equatable {
                public typealias JSONType = Tool.FunctionDefinition.Parameters.JSONType

                public let type: Self.JSONType
                public let description: String?
                public let format: String?
                public let items: Self.Items?
                public let required: [String]?
                public let pattern: String?
                public let const: String?
                public let `enum`: [String]?
                public let multipleOf: Int?
                public let minimum: Double?
                public let maximum: Double?
                public let minItems: Int?
                public let maxItems: Int?
                public let uniqueItems: Bool?

                public init(
                    type: Self.JSONType,
                    description: String? = nil,
                    format: String? = nil,
                    items: Self.Items? = nil,
                    required: [String]? = nil,
                    pattern: String? = nil,
                    const: String? = nil,
                    enum: [String]? = nil,
                    multipleOf: Int? = nil,
                    minimum: Double? = nil,
                    maximum: Double? = nil,
                    minItems: Int? = nil,
                    maxItems: Int? = nil,
                    uniqueItems: Bool? = nil
                ) {
                    self.type = type
                    self.description = description
                    self.format = format
                    self.items = items
                    self.required = required
                    self.pattern = pattern
                    self.const = const
                    self.`enum` = `enum`
                    self.multipleOf = multipleOf
                    self.minimum = minimum
                    self.maximum = maximum
                    self.minItems = minItems
                    self.maxItems = maxItems
                    self.uniqueItems = uniqueItems
                }

                public struct Items: Codable, Equatable {
                    public typealias JSONType = Tool.FunctionDefinition.Parameters.JSONType

                    public let type: Self.JSONType
                    public let properties: [String: Property]?
                    public let pattern: String?
                    public let const: String?
                    public let `enum`: [String]?
                    public let multipleOf: Int?
                    public let minimum: Double?
                    public let maximum: Double?
                    public let minItems: Int?
                    public let maxItems: Int?
                    public let uniqueItems: Bool?

                    public init(
                        type: Self.JSONType,
                        properties: [String : Property]? = nil,
                        pattern: String? = nil,
                        const: String? = nil,
                        `enum`: [String]? = nil,
                        multipleOf: Int? = nil,
                        minimum: Double? = nil,
                        maximum: Double? = nil,
                        minItems: Int? = nil,
                        maxItems: Int? = nil,
                        uniqueItems: Bool? = nil
                    ) {
                        self.type = type
                        self.properties = properties
                        self.pattern = pattern
                        self.const = const
                        self.`enum` = `enum`
                        self.multipleOf = multipleOf
                        self.minimum = minimum
                        self.maximum = maximum
                        self.minItems = minItems
                        self.maxItems = maxItems
                        self.uniqueItems = uniqueItems
                    }
                }
            }


            public enum JSONType: String, Codable {
                case integer
                case string
                case boolean
                case array
                case object
                case number
                case null
            }
        }
    }

    public enum ToolType: String, Codable, Equatable {
        case function
    }
}
