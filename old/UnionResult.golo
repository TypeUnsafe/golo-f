module sandbox

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

function checkIsString = |item, errMessage|-> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure(errMessage)
}

function main = |args| {

  println(checkIsString("42", "ouch"): getClass(): getName())

  println(checkIsString(42, "ouch"): getClass(): getName())

  checkIsString(42, "ouch")
    : bind(
      success=|value| { println("YES:"+value) },
      failure=|err| { println("NO:"+err) }
    )

  checkIsString("42", "ouch")
    : bind(
      success=|value| { println("YES:"+value) },
      failure=|err| { println("NO:"+err) }
    )

}