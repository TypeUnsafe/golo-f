module try_something_optional

union Option = {
 Some = { value }
 None
}

function checkIsNull = |item, errMessage|-> match {
  when item is null then success(item)
  otherwise failure(errMessage)
}
function checkIsNotNull = |item, errMessage|-> match {
  when item is null then failure(errMessage)
  otherwise success(item)
}
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

function checkIsNotNone = |item, errMessage|-> match {
  when item: equals(Option.None()) then failure(errMessage)
  otherwise success(item)
}

# simpler than previous
function checkIsNotNone = |item|-> match {
  when item: equals(Option.None()) then failure()
  otherwise success(item)
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

 let r = toInt("")

 match {
  when r: equals(Option.None()) then println("NONE")
  otherwise println(r: value())
 }

 println(
  checkIsNotNone(toInt(""), "none")(|some| -> some: value(), |errMsg| -> 0)
 )

 println(
  checkIsNotNone(toInt("45.6"))(|some| -> some: value(), -> 0)
 )

 println(
  checkIsNotNone(toInt("45"), "none")(|some| -> some: value(), |errMsg| -> 0)
 )

}