//
//  ChatMessage.swift
//  Acao
//
//  Created by Tim Mahoney on 5/2/24.
//

import Foundation

public enum ChatMessage: Codable, Equatable {

    case system(Self.System)
    case user(Self.User)
    case assistant(Self.Assistant)
    case tool(Self.ToolMessage)

    public var content: Self.User.Content? { get {
        switch self {
        case .system(let systemMessage):
            return Self.User.Content.string(systemMessage.content)
        case .user(let userMessage):
            return userMessage.content
        case .assistant(let assistantMessage):
            if let content = assistantMessage.content {
                return Self.User.Content.string(content)
            }
            return nil
        case .tool(let toolMessage):
            return Self.User.Content.string(toolMessage.content)
        }
    }}

    public var role: Role { get {
        switch self {
        case .system(let systemMessage):
            return systemMessage.role
        case .user(let userMessage):
            return userMessage.role
        case .assistant(let assistantMessage):
            return assistantMessage.role
        case .tool(let toolMessage):
            return toolMessage.role
        }
    }}

    public var name: String? { get {
        switch self {
        case .system(let systemMessage):
            return systemMessage.name
        case .user(let userMessage):
            return userMessage.name
        case .assistant(let assistantMessage):
            return assistantMessage.name
        default:
            return nil
        }
    }}

    public var toolCallId: String? { get {
        switch self {
        case .tool(let toolMessage):
            return toolMessage.toolCallId
        default:
            return nil
        }
    }}

    public var toolCalls: [Self.Assistant.ToolCall]? { get {
        switch self {
        case .assistant(let assistantMessage):
            return assistantMessage.toolCalls
        default:
            return nil
        }
    }}

    public init?(
        role: Role,
        content: String? = nil,
        name: String? = nil,
        toolCalls: [Self.Assistant.ToolCall]? = nil,
        toolCallId: String? = nil
    ) {
        switch role {
        case .system:
            if let content {
                self = .system(.init(content: content, name: name))
            } else {
                return nil
            }
        case .user:
            if let content {
                self = .user(.init(content: .init(string: content), name: name))
            } else {
                return nil
            }
        case .assistant:
            self = .assistant(.init(content: content, name: name, toolCalls: toolCalls))
        case .tool:
            if let content, let toolCallId {
                self = .tool(.init(content: content, toolCallId: toolCallId))
            } else {
                return nil
            }
        }
    }

    public init?(
        role: Role,
        content: [User.Content.VisionContent],
        name: String? = nil
    ) {
        switch role {
        case .user:
            self = .user(.init(content: .vision(content), name: name))
        default:
            return nil
        }

    }

    private init?(
        content: String,
        role: Role,
        name: String? = nil
    ) {
        if role == .system {
            self = .system(.init(content: content, name: name))
        } else {
            return nil
        }
    }

    private init?(
        content: Self.User.Content,
        role: Role,
        name: String? = nil
    ) {
        if role == .user {
            self = .user(.init(content: content, name: name))
        } else {
            return nil
        }
    }

    private init?(
        role: Role,
        content: String? = nil,
        name: String? = nil,
        toolCalls: [Self.Assistant.ToolCall]? = nil
    ) {
        if role == .assistant {
            self = .assistant(.init(content: content, name: name, toolCalls: toolCalls))
        } else {
            return nil
        }
    }

    private init?(
        content: String,
        role: Role,
        toolCallId: String
    ) {
        if role == .tool {
            self = .tool(.init(content: content, toolCallId: toolCallId))
        } else {
            return nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .system(let a0):
            try container.encode(a0)
        case .user(let a0):
            try container.encode(a0)
        case .assistant(let a0):
            try container.encode(a0)
        case .tool(let a0):
            try container.encode(a0)
        }
    }

    enum CodingKeys: CodingKey {
        case system
        case user
        case assistant
        case tool
    }

    public struct System: Codable, Equatable {

        /// The contents of the system message.
        public let content: String
        /// The role of the messages author, in this case system.
        public let role: Role = .system
        /// An optional name for the participant. Provides the model information to differentiate between participants of the same role.
        public let name: String?

        public init(
            content: String,
            name: String? = nil
        ) {
            self.content = content
            self.name = name
        }

        enum CodingKeys: CodingKey {
            case content
            case role
            case name
        }
    }

    public struct User: Codable, Equatable {

        /// The contents of the user message.
        public let content: Content
        /// The role of the messages author, in this case user.
        public let role: Role = .user
        /// An optional name for the participant. Provides the model information to differentiate between participants of the same role.
        public let name: String?

        public init(
            content: Content,
            name: String? = nil
        ) {
            self.content = content
            self.name = name
        }

        enum CodingKeys: CodingKey {
            case content
            case role
            case name
        }

        public enum Content: Codable, Equatable {
            case string(String)
            case vision([VisionContent])

            public var string: String? { get {
                switch self {
                case .string(let string):
                    return string
                default:
                    return nil
                }
            }}

            public init(string: String) {
                self = .string(string)
            }

            public init(vision: [VisionContent]) {
                self = .vision(vision)
            }

            public enum CodingKeys: CodingKey {
                case string
                case vision
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .string(let a0):
                    try container.encode(a0)
                case .vision(let a0):
                    try container.encode(a0)
                }
            }

        public enum VisionContent: Codable, Equatable {
            case chatCompletionContentPartTextParam(ChatCompletionContentPartTextParam)
            case chatCompletionContentPartImageParam(ChatCompletionContentPartImageParam)

            public var text: String? { get {
                switch self {
                case .chatCompletionContentPartTextParam(let text):
                    return text.text
                default:
                    return nil
                }
            }}

            public var imageUrl: Self.ChatCompletionContentPartImageParam.ImageURL? { get {
                switch self {
                case .chatCompletionContentPartImageParam(let image):
                    return image.imageUrl
                default:
                    return nil
                }
            }}

            public init(chatCompletionContentPartTextParam: ChatCompletionContentPartTextParam) {
                self = .chatCompletionContentPartTextParam(chatCompletionContentPartTextParam)
            }

            public init(chatCompletionContentPartImageParam: ChatCompletionContentPartImageParam) {
                self = .chatCompletionContentPartImageParam(chatCompletionContentPartImageParam)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                switch self {
                case .chatCompletionContentPartTextParam(let a0):
                    try container.encode(a0)
                case .chatCompletionContentPartImageParam(let a0):
                    try container.encode(a0)
                }
            }

            enum CodingKeys: CodingKey {
                case chatCompletionContentPartTextParam
                case chatCompletionContentPartImageParam
            }

            public struct ChatCompletionContentPartTextParam: Codable, Equatable {
                /// The text content.
                public let text: String
                /// The type of the content part.
                public let type: String

                public init(text: String) {
                    self.text = text
                    self.type = "text"
                }
            }

            public struct ChatCompletionContentPartImageParam: Codable, Equatable {
                public let imageUrl: ImageURL
                /// The type of the content part.
                public let type: String

                public init(imageUrl: ImageURL) {
                    self.imageUrl = imageUrl
                    self.type = "image_url"
                }

                public struct ImageURL: Codable, Equatable {
                    /// Either a URL of the image or the base64 encoded image data.
                    public let url: String
                    /// Specifies the detail level of the image. Learn more in the
                    /// Vision guide https://platform.openai.com/docs/guides/vision/low-or-high-fidelity-image-understanding
                    public let detail: Detail

                    public init(url: String, detail: Detail) {
                        self.url = url
                        self.detail = detail
                    }

                    public init(url: Data, detail: Detail) {
                        self.init(
                            url: "data:image/jpeg;base64,\(url.base64EncodedString())",
                            detail: detail)
                    }

                    public enum Detail: String, Codable, Equatable, CaseIterable {
                        case auto
                        case low
                        case high
                    }
                }

                public enum CodingKeys: String, CodingKey {
                    case imageUrl = "image_url"
                    case type
                }
            }
        }
    }
    }

    internal struct ChatCompletionMessageParam: Codable, Equatable {
        
        let role: Role

        enum CodingKeys: CodingKey {
            case role
        }
    }

    public struct Assistant: Codable, Equatable {

        //// The role of the messages author, in this case assistant.
        public let role: Role = .assistant
        /// The contents of the assistant message. Required unless tool_calls is specified.
        public let content: String?
        /// The name of the author of this message. `name` is required if role is `function`, and it should be the name of the function whose response is in the `content`. May contain a-z, A-Z, 0-9, and underscores, with a maximum length of 64 characters.
        public let name: String?
        /// The tool calls generated by the model, such as function calls.
        public let toolCalls: [Self.ToolCall]?

        public init(
            content: String? = nil,
            name: String? = nil,
            toolCalls: [Self.ToolCall]? = nil
        ) {
            self.content = content
            self.name = name
            self.toolCalls = toolCalls
        }

        public enum CodingKeys: String, CodingKey {
            case name
            case role
            case content
            case toolCalls = "tool_calls"
        }

        public struct ToolCall: Codable, Equatable {

            /// The ID of the tool call.
            public let id: String
            /// The function that the model called.
            public let function: Self.Function
            /// The type of the tool. Currently, only `function` is supported.
            public let type: Tool.ToolType

            public init(
                id: String,
                function:  Self.Function
            ) {
                self.id = id
                self.function = function
                self.type = .function
            }

            public struct Function: Codable, Equatable {
                /// The arguments to call the function with, as generated by the model in JSON format. Note that the model does not always generate valid JSON, and may hallucinate parameters not defined by your function schema. Validate the arguments in your code before calling your function.
                public let arguments: String
                /// The name of the function to call.
                public let name: String
            }
        }
    }

    public struct ToolMessage: Codable, Equatable {
        
        /// The contents of the tool message.
        public let content: String
        /// The role of the messages author, in this case tool.
        public let role: Role = .tool
        /// Tool call that this message is responding to.
        public let toolCallId: String

        public init(
            content: String,
            toolCallId: String
        ) {
            self.content = content
            self.toolCallId = toolCallId
        }

        public enum CodingKeys: String, CodingKey {
            case content
            case role
            case toolCallId = "tool_call_id"
        }
    }
}
