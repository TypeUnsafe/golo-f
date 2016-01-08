module someAndNone

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
  println(
    toInt("hello") # Optional.empty
  )
  println(
    toInt("42hello") # Optional.empty
  )
  println(
    toInt("hello42") # Optional.empty
  )

  let test = toInt("42")
  println(
    test # Optional[42]
  )
  println("value of test: " + test: get())


  println(
    toInt(42) # Optional.empty
  )

}