@value
struct fu:

  @staticmethod
  fn str_to_float(s: String) raises -> Float64:
    try:
      # locate decimal point
      var dot_pos = s.find(".")
      # grab the integer part of the number
      var int_str = s[0:dot_pos]
      # grab the decimal part of the number
      var num_str = s[dot_pos+1:len(s)]
      # set the numerator to be the integer equivalent
      var numerator = atol(num_str)
      # construct denom_str to be "1" + "0"s for the length of the fraction
      var denom_str = String()
      for _ in range(len(num_str)):
        denom_str += "0"
      var denominator = atol("1" + denom_str)
      # school-level maths here :)
      var frac = numerator / denominator

      # return the number as a Float64
      var result: Float64 = atol(int_str) + frac
      return result
    except:
      print("error in str_to_float")
      return 0.0

  @staticmethod
  fn format_float(f: Float64, dec_places: Int) -> String:
    # get input number as a string
    var f_str = String(f)
    # use position of the decimal point to determine the number of decimal places
    var int_places = f_str.find(".")
    # build a multiplier to shift the digits before the decimal point
    var mult = 10 ** (dec_places + 1)
    # note the use of an extra power of 10 to get the rounding digit
    # use the multiplier build the integer value of the input number
    var i = Float64(f * mult).cast[DType.int32]()
    # get the integer value as a string
    var i_str_full = String(i)
    # grab the last digit to be used to adjust/leave the previous digit
    var last_digit = i_str_full[len(i_str_full)-1]
    # grab the last but one digit in the integer string
    var prev_digit_pos = len(i_str_full) - 1
    var prev_digit = i_str_full[prev_digit_pos - 1]
    # if last digit is >= to 5 then we...
    if ord(last_digit) >= ord("5"):
      # ... increment it by 1
      prev_digit = chr(ord(prev_digit) + 1)
    # isolate the unchanging part of integer string
    var i_str_less_2 = i_str_full[0:len(i_str_full) - 2]
    # grab the integer part of the output float string
    var i_str_int = i_str_full[0:int_places]
    # chop the integer part from the unchanging part of the number
    i_str_less_2 = i_str_less_2[int_places:len(i_str_less_2)]
    # build the output float string
    var i_str_out = i_str_int + "." + i_str_less_2 + prev_digit
    return i_str_out
