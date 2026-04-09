@fieldwise_init
struct fu(Copyable, Movable):

   @staticmethod
   def str_to_float(s: String) raises -> Float64:
      try:
         # locate decimal point
         var dot_pos = s.find(".")
         # grab the integer part of the number
         var int_str = s[byte=0:dot_pos]
         # grab the decimal part of the number
         var num_str = s[byte=dot_pos+1:s.byte_length()]
         # set the numerator to be the integer equivalent
         var numerator = atol(num_str)
         # construct denom_str to be "1" + "0"s for the length of the fraction
         var denom_str = String()
         for _ in range(num_str.byte_length()):
            denom_str += "0"
         var denominator = atol("1" + denom_str)
         # school-level maths here :)
         var frac = Float64(numerator) / Float64(denominator)
         # return the number as a Float64
         var result = Float64(atol(int_str)) + frac
         return result
      except:
         print("error in str_to_float")
         return 0.0

   @staticmethod
   def format_float(f: Float64, dec_places: Int) -> String:
      # get input number as a string
      var f_str = String(f)
      # use position of the decimal point to determine the number of decimal places
      var int_places = f_str.find(".")
      # build a multiplier to shift the digits before the decimal point
      var mult = 10 ** (dec_places + 1)
      # note the use of an extra power of 10 to get the rounding digit
      # use the multiplier build the integer value of the input number
      var i = Float64(f * Float64(mult)).cast[DType.int32]()
      # get the integer value as a string
      var i_str_full = String(i)
      # grab the last digit to be used to adjust/leave the previous digit
      var last_digit = i_str_full[byte=i_str_full.byte_length() - 1]
      # grab the last but one digit in the integer string
      var prev_digit_pos = i_str_full.byte_length() - 1
      var prev_digit = String(i_str_full[byte=prev_digit_pos - 1])
      # if last digit is >= to 5 then we...
      if ord(last_digit) >= ord("5"):
         # ... increment it by 1
         prev_digit = chr(ord(prev_digit) + 1)
      # isolate the unchanging part of integer string
      var i_str_less_2 = i_str_full[byte=0:i_str_full.byte_length() - 2]
      # grab the integer part of the output float string
      var i_str_int = i_str_full[byte=0:int_places]
      # chop the integer part from the unchanging part of the number
      i_str_less_2 = i_str_less_2[byte=int_places:i_str_less_2.byte_length()]
      # build the output float string
      var i_str_out = i_str_int + "." + i_str_less_2 + prev_digit
      return i_str_out
