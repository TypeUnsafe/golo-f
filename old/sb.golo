module sb
#Kind of Ternary operator
function T = |condition| {
  return |trueValue| {
    return |falseValue| {
      if condition { return trueValue } else { return falseValue }
    }
  }
}

union Result = {
  Success = { value }
  Failure = { value }
}

augment Result {
  function bind = |this, success, failure| {
    case {
      when this oftype types.Result$Success.class {
        return success(this: value())
      }
      otherwise {
        return failure(this: value())
      }
    }
  }
}

function isString = |value| -> T(value oftype String.class)(Result.Success(value))(Result.Failure(value + " is not a String"))


function main = |args| {

  let a = T(true)(5)(42)
  println(a)
  let b = T(false)(5)(42)
  println(b)

  println(T("bob" oftype String.class)(Result.Success("bob"))(Result.Failure("Huston?")))

  println(isString(5))
  println(isString("BOB"))

}