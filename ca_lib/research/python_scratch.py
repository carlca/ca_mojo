
data_string = '[[1, 2, 3], [4, 5, 6], [7, 8, 9]]'
print(data_string)
rowStrings = data_string.strip("[]")
print(rowStrings)
rowStrings = rowStrings.split('], [')
print(rowStrings)
print(rowStrings[0])
print(rowStrings[1])
print(rowStrings[2])
print(len(rowStrings))

list = [2, 3, 4, 5, 6, 7, 8, 9]
print(list)