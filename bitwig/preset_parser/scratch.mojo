from utils.vector import DynamicVector
from memory.unsafe import bitcast
from math.bit import bswap

# fn main():
#   let a: Int64 = 123
#   let b: UInt64 = 456
#   let c = a.to_int() + b
#   print(c)

#   var data: DynamicVector[UInt8] = DynamicVector[UInt8]()
#   data.push_back(1)
#   data.push_back(2)
#   print(data.__len__())
#   for i in range(0, data.__len__()):
#     print(data[i])

#   let i64: Int64 = 123
#   let i = i64.to_int()
  
fn main():
    var v = DynamicVector[UInt8]()
    v.append(0)
    v.append(0)
    v.append(0)
    v.append(0x18)

    let ui32_ptr = Pointer[UInt8](v.data.value).bitcast[UInt32]()
    let unswapped_size = ui32_ptr[0]
    let size = bswap[DType.uint32, 1](unswapped_size)
    print(unswapped_size, size)

    _ = v