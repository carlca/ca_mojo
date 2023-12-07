trait MyStringable(Stringable):
    fn str(self) -> String:
        return "MyStringable"

fn to_string[T: Stringable](a: T) -> String:
    return str(a)

def main():
    print(to_string[String](String("hello")))