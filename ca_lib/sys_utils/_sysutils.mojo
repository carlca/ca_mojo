import sys
from ca_lib.string_utils import su

@value
struct sysutils:

  @staticmethod
  fn get_full_app_name() -> String:
    var args = sys.argv()
    if args.__len__() > 0:
      return String(args[0])
    return "Unknown"

  @staticmethod
  fn get_app_name() raises -> String:
    var full_app_name = sysutils.get_full_app_name()
    var parts = su.split(full_app_name, "/")
    if parts.size > 0:
      return parts[0]
    return "Unknown"

  @staticmethod
  fn get_app_path(ensure_final_sep: Bool) raises -> String:
    var full_app_name = sysutils.get_full_app_name()
    var parts = su.split(full_app_name, "/")
    if parts.size > 0:
      var parts_trimmed = parts[: -1]
      var slash = String("/")
      var result = String("")
      for part in parts_trimmed:
        result += part[] + slash
      if not ensure_final_sep:
        result = result[: -1]
      return result
    return "Unknown"

  @staticmethod
  fn get_app_path() raises -> String:
    return sysutils.get_app_path(True)

  @staticmethod 
  fn get_args() -> List[String]:
    var result: List[String] = List[String]()
    var args = sys.argv()
    if args.__len__() > 0:
      for i in range(0, args.__len__()):
        result.append(String(args[i]))
    return result

  @staticmethod
  fn get_params() raises -> List[String]:
    var args = Self.get_args()
    if args.size > 1:
      return args[1:]
    return List[String]()

  @staticmethod
  fn get_param(index: Int) raises -> String:
    var args = Self.get_args()
    if args.size > index:
      return args[index]
    return ""

  