module mapAndMapError

import gololang.error.Errors

@result
function toInt = |sParam| {
  return java.lang.Integer.parseInt(sParam: trim())
}

function main = |args| {

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
