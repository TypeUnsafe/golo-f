module results

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

augmentation bind = {
  function bind = |this, success, failure| {
    case {
      when this oftype results.types.success.class {
        success(this: value())
      }
      otherwise {
        failure(this: message())
      }
    }
  }
}
augment failure with bind
augment success with bind


----
## result structure
----
struct result = {
  _success, _failure
}
augment result {
  function success = |this, value| {
    this: _success(success(value))
    return this: _success()
  }
  function failure = |this, message| {
    this: _failure(failure(message))
    return this: _failure()
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

  emailChecker("foobar.com")
    : bind(
      success= onSuccess,
      failure= onFailure
    )
  emailChecker("foo@bar.com")
    : bind(
      success= onSuccess,
      failure= onFailure
    )
  emailChecker("http://foo.bar.com")
    : bind(
      success= onSuccess,
      failure= onFailure
    )
  emailChecker("+330664932112")
    : bind(
      success= onSuccess,
      failure= onFailure
    )
}


