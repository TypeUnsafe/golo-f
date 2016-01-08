module results4

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

function checkIsString = |item, errMessage|-> match {
  when item oftype String.class then success(item)
  otherwise failure(errMessage)
}

function main = |args| {

  let emailChecker = |item|-> match {
    when item: contains("@") then success(item)
    when item: startsWith("+33") then failure("a French phone number?")
    when item: startsWith("http://") then failure("a website URL?")
    otherwise failure("I have no clue, mate!")
  }

  let onSuccess = |value| -> println("Mail sent to "+value)
  let onFailure = |errorMessage| -> println("Error message logged: "+errorMessage)

  emailChecker("foobar.com")(onSuccess, onFailure)
  emailChecker("foo@bar.com")(onSuccess, onFailure)
  emailChecker("http://foo.bar.com")(onSuccess, onFailure)
  emailChecker("+330664932112")(onSuccess, onFailure)


  println(
    checkIsString(42, "not a string")(|value| -> value, |err| -> err)
  )

}


