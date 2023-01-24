
import SDL2
import GLAD

extension SDL_Event {
    mutating func poll() -> Bool {
        SDL_PollEvent(&self) != 0 ? true : false
    }
}

/// A divider for organising command line log output.
let divider = "================================================================"

/// Allows optimising unreachable code.
@inline(__always)
@inlinable
@_transparent
public func unreachable() -> Never {
    return unsafeBitCast((), to: Never.self)
}

// Pretty `throw "String"` syntax trick found on Stack Overflow.
extension String: Error {}

// Simplified OpenGL error handling, by default only works in debug mode.
extension GL {
    
    static private let GLERROR = "GL error:"
    
    @inline(__always)
    @inlinable
    @_transparent
    static func checkForErrors() {
        #if DEBUG || SHOWGLERRORS
        let error = glad_glGetError()
        switch error {
        case 0: break
        case 0x0500:
            print(
                """
                
                \(GLERROR.color(.red)) Invalid enum
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0501:
            print(
                """
                
                \(GLERROR.color(.red)) Invalid value
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0502:
            print(
                """
                
                \(GLERROR.color(.red)) Invalid operation
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0503:
            print(
                """
                
                \(GLERROR.color(.red)) Stack overflow
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0504:
            print(
                """
                
                \(GLERROR.color(.red)) Stack underflow
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0505:
            print(
                """
                
                \(GLERROR.color(.red)) Out of memory
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0506:
            print(
                """
                
                \(GLERROR.color(.red)) Invalid framebuffer operation
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        case 0x0507:
            print(
                """
                
                \(GLERROR.color(.red)) Context lost
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        default:
            print(
                """
                
                \(GLERROR.color(.red)) Unknown \(error)
                File: \(#file) Line: \(#line) Column: \(#column)
                
                """
            )
        }
        #endif
    }
}

// Colored terminal output for more readable errors and debugging.
extension String {
    
    mutating func color(_ color: Color, _ type: ColorType = .foreground) {
        if type == .foreground {
            switch color {
            case .black:     self = "\u{001B}[30m" + self
            case .red:       self = "\u{001B}[31m" + self
            case .green:     self = "\u{001B}[32m" + self
            case .yellow:    self = "\u{001B}[33m" + self
            case .blue:      self = "\u{001B}[34m" + self
            case .magenta:   self = "\u{001B}[35m" + self
            case .cyan:      self = "\u{001B}[36m" + self
            case .white:     self = "\u{001B}[37m" + self
            case .`default`: self = "\u{001B}[39m" + self
            }
        } else if type == .background {
            switch color {
            case .black:     self = "\u{001B}[40m" + self
            case .red:       self = "\u{001B}[41m" + self
            case .green:     self = "\u{001B}[42m" + self
            case .yellow:    self = "\u{001B}[43m" + self
            case .blue:      self = "\u{001B}[44m" + self
            case .magenta:   self = "\u{001B}[45m" + self
            case .cyan:      self = "\u{001B}[46m" + self
            case .white:     self = "\u{001B}[47m" + self
            case .`default`: self = "\u{001B}[49m" + self
            }
        }
        self += "\u{001B}[0m"
    }
    
    mutating func formatting(_ formatting: Format...) {
        for argument in formatting {
            switch argument {
                case .bold:          self = "\u{001B}[1m" + self
                case .italic:        self = "\u{001B}[3m" + self
                case .underline:     self = "\u{001B}[4m" + self
                case .strikethrough: self = "\u{001B}[9m" + self
                case .faint:         self = "\u{001B}[2m" + self
                case .blinking:      self = "\u{001B}[5m" + self
                case .inverse:       self = "\u{001B}[7m" + self
                case .invisible:     self = "\u{001B}[8m" + self
            }
        }
        self += "\u{001B}[0m"
    }
    
    func color(_ color: Color, _ type: ColorType = .foreground) -> String {
        if type == .foreground {
            switch color {
            case .black:     return "\u{001B}[30m" + self + "\u{001B}[0m"
            case .red:       return "\u{001B}[31m" + self + "\u{001B}[0m"
            case .green:     return "\u{001B}[32m" + self + "\u{001B}[0m"
            case .yellow:    return "\u{001B}[33m" + self + "\u{001B}[0m"
            case .blue:      return "\u{001B}[34m" + self + "\u{001B}[0m"
            case .magenta:   return "\u{001B}[35m" + self + "\u{001B}[0m"
            case .cyan:      return "\u{001B}[36m" + self + "\u{001B}[0m"
            case .white:     return "\u{001B}[37m" + self + "\u{001B}[0m"
            case .`default`: return "\u{001B}[39m" + self + "\u{001B}[0m"
            }
        } else {
            switch color {
            case .black:     return "\u{001B}[40m" + self + "\u{001B}[0m"
            case .red:       return "\u{001B}[41m" + self + "\u{001B}[0m"
            case .green:     return "\u{001B}[42m" + self + "\u{001B}[0m"
            case .yellow:    return "\u{001B}[43m" + self + "\u{001B}[0m"
            case .blue:      return "\u{001B}[44m" + self + "\u{001B}[0m"
            case .magenta:   return "\u{001B}[45m" + self + "\u{001B}[0m"
            case .cyan:      return "\u{001B}[46m" + self + "\u{001B}[0m"
            case .white:     return "\u{001B}[47m" + self + "\u{001B}[0m"
            case .`default`: return "\u{001B}[49m" + self + "\u{001B}[0m"
            }
        }
    }
    
    func formatting(_ formatting: Format...) -> String {
        for argument in formatting {
            switch argument {
                case .bold:          return "\u{001B}[1m" + self + "\u{001B}[0m"
                case .italic:        return "\u{001B}[3m" + self + "\u{001B}[0m"
                case .underline:     return "\u{001B}[4m" + self + "\u{001B}[0m"
                case .strikethrough: return "\u{001B}[9m" + self + "\u{001B}[0m"
                case .faint:         return "\u{001B}[2m" + self + "\u{001B}[0m"
                case .blinking:      return "\u{001B}[5m" + self + "\u{001B}[0m"
                case .inverse:       return "\u{001B}[7m" + self + "\u{001B}[0m"
                case .invisible:     return "\u{001B}[8m" + self + "\u{001B}[0m"
            }
        }
        unreachable()
    }
    
    mutating func reset()  { self = "\u{001B}[0m" + self }
    func reset() -> String { return "\u{001B}[0m" + self }
    
    enum ColorType { case foreground, background }
    
    enum Format {
        case bold
        case italic
        case underline
        case strikethrough
        case faint
        case blinking
        case inverse
        case invisible
    }
    
    enum Color {
        case black
        case red
        case green
        case yellow
        case blue
        case magenta
        case cyan
        case white
        case `default`
    }
}

public typealias CString = [CChar]

extension Array: ExpressibleByUnicodeScalarLiteral where Element == CChar {}

extension Array: ExpressibleByExtendedGraphemeClusterLiteral where Element == CChar {}

extension Array: ExpressibleByStringLiteral where Element == CChar {
    @inlinable
    @inline(__always)
    public init(stringLiteral value: StaticString) {
        precondition(value.isASCII, "You can only initialize a cString from an ASCII string.")
        self = Array<CChar>(unsafeUninitializedCapacity: value.utf8CodeUnitCount,
                     initializingWith: { buffer, initializedCount in
            
            var stringPointer = value.utf8Start
            
            for i in 0..<value.utf8CodeUnitCount {
                buffer[i] = CChar(stringPointer.pointee)
                stringPointer += 1
            }
            
            initializedCount = value.utf8CodeUnitCount
        })
    }
}

extension CChar: ExpressibleByUnicodeScalarLiteral {
    @inlinable
    @inline(__always)
    public init(unicodeScalarLiteral value: UnicodeScalar) {
        self.init(value.value)
    }
}
