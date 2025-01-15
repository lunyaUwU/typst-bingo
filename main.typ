#import "@preview/suiji:0.3.0": *

#set page("a5")
#set text(
  size: 15pt,
  font: "Helvetica"
)

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
   
  let rng = gen-rng-f(seed)
  for i in range(pages) {
    let indexes = indexesG
    let items = ()
    (rng, items) = shuffle-f(rng, cardsI)
    items = items.slice(0,cardsAmount)
    for fixedCard in fixedCards {
      let pos = fixedCard.slice(1)
      let index = (pos.at(1)) * amount + pos.at(0)
      items.at(index)= fixedCard.at(0)
    } 
    (rng, indexes) = shuffle-f(rng, indexes)
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
