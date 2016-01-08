module sandbox

union Option = {
 Some = { value }
 None
}

augment Option {

  function bind = |this, whenSome, whenNone| {
    case {
      when this oftype types.Option$Some.class {
        return whenSome(this)
      }
      otherwise {
        return whenNone(this)
      }
    }
  }

  function getOrElse = |this, defaultValue| {
    case {
      when this oftype types.Option$Some.class {
        return this: value()
      }
      otherwise {
        return defaultValue
      }
    }
  }
  # Dealing with Option composition
  function flatMap = |this, func| -> match {
    when this is Option.None() then this
    otherwise func(this: value())
  }

  function map = |this, func| -> match {
    when this is Option.None() then this
    otherwise Option.Some(func(this: value()))
  }
}


union Result = {
  Success = { value }
  Failure = { value }
}

augment Result {
  function bind = |this, success, failure| {
    case {
      when this oftype types.Result$Success.class {
        return success(this: value())
      }
      otherwise {
        return failure(this: value())
      }
    }
  }

  function getOrElse = |this, defaultValue| {
    case {
      when this oftype types.Result$Success.class {
        return this: value()
      }
      otherwise {
        return defaultValue
      }
    }
  }

}


function checkIsString = |item, err| -> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure(err)
}

function checkIsString = |item| -> match {
  when item oftype String.class then Result.Success(item)
  otherwise Result.Failure("not a string")
}



function toInt = |sParam| {
  try {
    return Option.Some(java.lang.Integer.parseInt(sParam: trim()))
  } catch(e) {
    #catch Exception to catch null 's'
    return Option.None()
  }
}


struct toon = {
  firstName, lastName, email
}
function Toon = |firstName, lastName| {
  return toon(firstName, lastName, Option.None())
}
function Toon = |firstName, lastName, email| {
  return toon(firstName, lastName, Option.Some(email))
}
----
let person = dao: findByName("Mr Bean")
let city = person?: address()?: city() orIfNull "n/a"
----
augment java.util.LinkedHashMap {
  function getOption = |this, key| {
    let value = this: get(key)
    return match {
      when value isnt null then Option.Some(value)
      otherwise Option.None()
    }
  }
}


function main = |args| {


  let toons = map[]
  toons: put("Mickey", Toon("Mickey", "Mouse", "mickey@disney.com"))
  toons: put("Minnie", Toon("Minnie", "Mouse"))
  toons: put("Donald", Toon("Donald", "Duck", "donald@disney.com"))

  let mickey = toons: getOption("Mickey"): flatMap(|toon|-> toon: email())
  let minnie = toons: getOption("Minnie"): flatMap(|toon|-> toon: email())
  #let minnie = toons: getOption("Minnie"): email()

  let goofy = toons: getOption("Goofy"): flatMap(|toon|-> toon: email())

  println(mickey: getOrElse("No Data"))
  println(minnie: getOrElse("No Data"))
  println(goofy: getOrElse("No Data"))

}