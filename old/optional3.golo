module try_something_optional

function success = |value| {
  return |success, failure| {
    return success(value)
  }
}
function failure = |message| {
  return |success, failure| {
    return failure(message)
  }
}
function failure = {
  return |success, failure| {
    return failure()
  }
}

union Option = {
 Some = { value }
 None
}

augment Option {
  function checkIsNotNone = |this, errMessage|-> match {
    when this: equals(Option.None()) then failure(errMessage)
    otherwise success(this)
  }

  # simpler than previous
  function checkIsNotNone = |this|-> match {
    when this: equals(Option.None()) then failure()
    otherwise success(this)
  }

  function getOrElse = |this, elseValue| ->
    checkIsNotNone(this, elseValue)(
      |some| -> some: value(),
      |valueIfError| -> valueIfError
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

# union Option.None

function main = |args| {

  let r = toInt("")

  match {
    when r: equals(Option.None()) then println("NONE")
    otherwise println(r: value())
  }

  println(
    toInt(""): checkIsNotNone("none")(|some| -> some: value(), |errMessage| {
      println(errMessage)
      return 0
    })
  )

  println(
    toInt("45.6"): checkIsNotNone()(|some| -> some: value(), -> 0)
  )

  println(
    toInt("45"): checkIsNotNone("none")(|some| -> some: value(), |errMessage| {
      println(errMessage)
      return 0
    })
  )

  println(toInt("45.6"): getOrElse(99))
  println(toInt("45"): getOrElse(99))

}