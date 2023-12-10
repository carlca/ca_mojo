fn main():
  let a: Int64 = 123
  let b: UInt64 = 456
  let c = a.to_int() + b
  print(c)

  var data: DynamicVector[UInt8] = DynamicVector[UInt8]()
  data.push_back(1)
  data.push_back(2)
  print(data.__len__())
  for i in range(0, data.__len__()):
    print(data[i])

  let i64: Int64 = 123
  let i = i64.to_int()
  