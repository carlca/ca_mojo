import .floatutils as fu

fn main() raises:
    let pi_str = "3.1415926234534563"
    print("pi_str: ", pi_str)
    let pi = fu.str_to_float(pi_str)
    print("pi: ", pi)
    print(fu.format_float(pi, 5))  # 3.14159
    print(fu.format_float(pi, 6))  # 3.141593
    print(fu.format_float(pi, 7))  # 3.1415926
