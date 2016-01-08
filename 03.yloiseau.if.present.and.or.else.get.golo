module ifPresentAndorElseGet

import gololang.error.Errors

# like the option decorator
function toInt = |sParam| {
  println("--------------------")
  println("-> sParam: " + sParam)
  try {
    return Some(java.lang.Integer.parseInt(sParam: trim()))
  } catch(e) {
    #catch Exception to catch null 's'
    println("-> Huston!?")
    return None()
  }
}


function main = |args| {
  # # see https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html
  println(
    toInt("hello"): ifPresent(|value| { # void => null
      println("-> ifPresent is true")
      println("-> value: " + value)
    })
  )

  println(
    toInt("42"): ifPresent(|value| { # void => null
      println("-> ifPresent is true")
      println("-> value: " + value)
    })
  )

  println( # return null
    toInt("hello"): orElseGet({
      println("-> orElseGet is true")
    })
  )

  println( # return value
    toInt("42"): orElseGet({
      println("-> orElseGet is true")
    })
  )



}