from builtin.simd import *

fn main() raises:
    # Create two vectors of 4 floats
    var a = float4(1.0, 2.0, 3.0, 4.0)
    var b = float4(5.0, 6.0, 7.0, 8.0)

    # Perform SIMD operations
    var c = a + b  # Vector addition
    var d = a * b  # Vector multiplication

    # Access individual elements
    print(c.x)  # Prints 6.0
    print(c.y)  # Prints 8.0
    print(c.z)  # Prints 10.0
    print(c.w)  # Prints 12.0

    print(d.x)  # Prints 5.0
    print(d.y)  # Prints 12.0
    print(d.z)  # Prints 21.0
    print(d.w)  # Prints 32.0
