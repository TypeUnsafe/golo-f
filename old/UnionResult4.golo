module sandbox

union Option = {
 Some = { value }
 None
}

augment Option {

  function bind = |this, whenSome, whenNone| {
    case {
      when this oftype types.Option$Some.class {
        return whenSome(this)
      }
      otherwise {
        return whenNone(this)
      }
    }
  }

  function getOrElse = |this, defaultValue| {
    case {
      when this oftype types.Option$Some.class {
        return this: value()
      }
      otherwise {
        return defaultValue
      }
    }
  }
  # Dealing with Option composition
  function flatMap = |this, func| -> match {
    when this is Option.None() then this
    otherwise func(this: value())
  }

  function map = |this, func| -> match {
    when this is Option.None() then this
    otherwise Option.Some(func(this: value()))
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

  function getOrElse = |this, defaultValue| {
    case {
      when this oftype types.Result$Success.class {
        return this: value()
      }
      otherwise {
        return defaultValue
      }
    }
  }

}


function checkIsString = |item, err| -> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure(err)
}

function checkIsString = |item| -> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure("not a string")
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

  println(checkIsString(42): getOrElse("-->42"))
  println(checkIsString("42"): getOrElse("-->42"))

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

  toInt("45.6")
    : bind(
      whenSome=|some| { println("YES:"+some: value()) },
      whenNone=|err| { println("NO:"+err) }
    )

  toInt("45")
    : bind(
      whenSome=|some| { println("YES:"+some: value()) },
      whenNone=|err| { println("NO:"+err) }
    )


}