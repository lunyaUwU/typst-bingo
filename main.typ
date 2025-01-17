#import "@preview/suiji:0.3.0": *

#set page("a5")
#set text(
  size: 15pt,
  font: "Helvetica"
)
#let myplugin = plugin("typst_bingo.wasm")
#let u32_to_u8_array(x) = {
  let a = ()
  let b = x
  let c = 0
  for i in range(3) {
    c = int(calc.rem(b,256))
    b = int((b - calc.rem(b,256)) / 256)
   a.push(c)
  }
  return a
}
#let shuffle(items:array,seed: int) = {
  let s = u32_to_u8_array(seed)
  [#seed]
  let indexes = myplugin.shuffle(bytes((range(items.len()))),bytes(s)) 
  let out = ()
  for index in indexes {
    out.push(items.at(index))
  }
  return out
}
#let shuffle-i(items:array,seed: int) = {
  let s = u32_to_u8_array(seed)
  let indexes = myplugin.shuffle(bytes(items),bytes(s)) 
  return array(indexes)
}

#let bingo(
  cards: ([1],[2],[3],[4],[5],[6],[7],[8],[9]),
  ensureCards: (),
  fixedCards: (),
  title: "Bingo",
  blankCard: [Free],
  amount: 3,
  seed: 9,
  pages: 5,
) = {
  layout(size => {
  let si = ((size.width * 0.9 / amount),) 
  let s = si*amount 
  let cardsI = cards
  let cardsAmount = amount * amount
  if cardsI.len() < cardsAmount {
    let missing =  cardsAmount - cards.len()
    cardsI = cardsI + (blankCard,) * missing
  }
  let indexesG = array.range(0,cardsAmount) 
  let indexesB = fixedCards.map(x=>{
     return x.at(2) * amount + x.at(1)
  })

  indexesB = indexesB.sorted().rev()
  //[#indexesB]
  // for index in indexesB {
  //  let i =  indexesG.remove(index)
  //}

  indexesG = indexesG.filter(x=> {
    return (indexesB.contains(x) == false)
  })
   
  //let rng = gen-rng-f(seed)
  for i in range(pages) {
    let indexes = indexesG
    let items = ()
    //(rng, items) = shuffle-f(rng, cardsI)
    items = shuffle(items: cardsI, seed: seed + i)
    items = items.slice(0,cardsAmount)
    for fixedCard in fixedCards {
      let pos = fixedCard.slice(1)
      let index = (pos.at(1)) * amount + pos.at(0)
      items.at(index)= fixedCard.at(0)
    } 
    //(rng, indexes) = shuffle-f(rng, indexes)
    indexes = shuffle-i(items: indexes, seed:seed+i)
    for ensureCard in ensureCards {
      let index = indexes.at(0)
      let b = indexes.remove(0)
      items.at(index) = ensureCard
    }

    align(center)[
      #v(1em)
      #text(size:2em)[#title]
      #v(0.5em)
      #table(columns:s,rows: s, align: horizon, 
        ..items
      )
    ]
    colbreak()
  }
  
  }
  )
}

#let seed = int(sys.inputs.at("seed", default: 0))
#bingo(
  cards:range(1,30).map(str),
  fixedCards: (
    ([Meow],2,2),
    ([Boop],1,0),
    ([Boop],3,1),
    ([NYAA],2,4),
    ([NYAA],4,4)
  ),
  ensureCards: ([Awa],[Gay],[NYA],[opo]),
  amount: 5,
  pages:  200,
  seed: seed,
)
