import sys
from ca_lib.string_utils import su
from ca_lib.stringlist import StringList

@value
struct sysutils:

  @staticmethod
  fn get_full_app_name() -> String:
    var args = sys.argv()
    if args.__len__() > 0:
      return args[0]
    return "Unknown"

  @staticmethod
  fn get_app_name() raises -> String:
    var full_app_name = sysutils.get_full_app_name()
    var parts = su.split(full_app_name, "/")
    if parts.len() > 0:
      return parts.last()
    return "Unknown"

  @staticmethod
  fn get_app_path(ensure_final_sep: Bool) raises -> String:
    var full_app_name = sysutils.get_full_app_name()
    var parts = su.split(full_app_name, "/")
    if parts.len() > 0:
      return parts.all_but_last_n(1).join("/", ensure_final_sep)
    return "Unknown"

  @staticmethod
  fn get_app_path() raises -> String:
    return sysutils.get_app_path(True)

  @staticmethod 
  fn get_args() -> StringList:
    var result: StringList = StringList()
    var args = sys.argv()
    if args.__len__() > 0:
      for i in range(0, args.__len__()):
        result += args[i]
    return result

  @staticmethod
  fn get_params() raises -> StringList:
    var args = Self.get_args()
    if args.len() > 1:
      return args.all_but_first_n(1)
    return args

  @staticmethod
  fn get_param(index: Int) raises -> String:
    var args = Self.get_args()
    if args.len() > index:
      return args[index]
    return ""

  