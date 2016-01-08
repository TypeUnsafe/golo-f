module ifPresentAndorElseGet

import gololang.error.Errors

@result
function toInt = |sParam| {
  println("--------------------")
  println("-> sParam: " + sParam)
  return java.lang.Integer.parseInt(sParam: trim())
}

function main = |args| {
  println(
    toInt("hello")
  )

  println(
    toInt("42")
  )

  toInt("hello"): map(|value| {
    println("value: " + value)
  }): mapError(|error| {
    println("-> error: " + error)
  })

  toInt("42"): map(|value| {
    println("value: " + value)
  }): mapError(|error| {
    println("-> error: " + error)
  })


}