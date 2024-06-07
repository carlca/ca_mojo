from ca_lib.sys_utils import sysutils 
from bitwig.preset_parser import presetparser

fn main() raises:
  var args = sysutils.get_params()
  if args.size == 0:
    print("Usage: mojo preset_parser <preset file>")
    return
  var filename = sysutils.get_app_path() + args[0]
  print("filename: " + filename)
  print()
  
  var pp = presetparser.PresetParser()
  pp.debug = True
  pp.process_preset(filename)
  print()

  

