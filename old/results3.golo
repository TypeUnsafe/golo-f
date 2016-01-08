module results3

----
## result structure
----
struct result = {
  _foo # never used
}
augment result {

  function success = |this, value| {
    return |success, failure| {
      success(value)
    }
  }
  function failure = |this, message| {
    return |success, failure| {
      failure(message)
    }
  }
}

function main = |args| {

  let emailChecker = |item|-> match {
    when item: contains("@") then result(): success(item)
    when item: startsWith("+33") then result(): failure("a French phone number?")
    when item: startsWith("http://") then result(): failure("a website URL?")
    otherwise result(): failure("I have no clue, mate!")
  }

  let onSuccess = |value| -> println("Mail sent to "+value)
  let onFailure = |errorMessage| -> println("Error message logged: "+errorMessage)

  emailChecker("foobar.com")(onSuccess, onFailure)
  emailChecker("foo@bar.com")(onSuccess, onFailure)
  emailChecker("http://foo.bar.com")(onSuccess, onFailure)
  emailChecker("+330664932112")(onSuccess, onFailure)
}


