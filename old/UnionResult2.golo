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


function checkIsString = |item, err| -> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure(err)
}


union Option = {
 Some = { value }
 None
}

augment Option {
  function checkIsNotNone = |this, err| -> match {
    when this: equals(Option.None()) then Result.Failure(err)
    otherwise Result.Success(this)
  }

  function getOrElse = |this, elseValue| ->
    this: checkIsNotNone(elseValue): bind(
      success=|some| -> some: value(),
      failure=|valueIfError| -> valueIfError
    )
}

function toInt = |sParam| {
  try {
    return Option.Some(java.lang.Integer.parseInt(sParam: trim()))
  } catch(e) {
    #catch Exception to catch null 's'
    return Option.None()
  }
}

function main = |args| {

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

  println(toInt("45.6"): getOrElse(999))
  println(toInt("45"): getOrElse(999))

  toInt("45.6"): checkIsNotNone(99)
    : bind(
      success=|some| { println("YES:"+some: value()) },
      failure=|err| { println("NO:"+err) }
    )

  toInt("45"): checkIsNotNone(99)
    : bind(
      success=|some| { println("YES:"+some: value()) },
      failure=|err| { println("NO:"+err) }
    )


}