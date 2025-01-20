fn main() raises:
  # 30,1,acid bass,aggressive + analog + distorted + stereo
  with open("/Users/carlcaulkett/Code/FPC/Osmose Presets/OsmoseCategories.pas", "r") as f_in:
    with open("/Users/carlcaulkett/Code/FPC/Osmose Presets/OsmoseCategories OUT.pas", "w") as f_out:

      var in_lines = f_in.read().split('\n')
      var out_lines = String()

      for in_line in in_lines:
        var out_subs = in_line[].split(",", 4)

        var out_line = out_subs[0] + ", " + out_subs[1] + ", '" + out_subs[2] + "', '" + out_subs[4] + "'\n"
        print (out_line)

        out_lines += out_line

      # print ("About to write output")
      # f_out.write(out_lines)
