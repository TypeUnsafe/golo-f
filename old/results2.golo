module results2

----
## success structure
----
struct success = {
  _value
}
augment success {
  function value = |this| -> this: _value()
}
----
## failure structure
----
struct failure = {
  _errorMessage
}
augment failure {
  function message = |this| -> this: _errorMessage()
}

----
## result structure
----
struct result = {
  _success, _failure
}
augment result {
  function success = |this, value| {
    this: _success(success(value))
    return |success, failure| {
      success(this: _success(): value())
    }
  }
  function failure = |this, message| {
    this: _failure(failure(message))
    return |success, failure| {
      failure(this: _failure():message())
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

  emailChecker("foo@bar.com")(onSuccess, onFailure)
  emailChecker("http://foo.bar.com")(onSuccess, onFailure)
  emailChecker("+330664932112")(onSuccess, onFailure)
  #emailChecker("foobar.com")(success=onSuccess, failure=onFailure)
}


