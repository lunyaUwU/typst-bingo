#import "@preview/suiji:0.3.0": *
#set page("a5")
#set text(
  size: 20pt,
  font: "Helvetica"
)

#let bingo(
  cards: ([1],[2],[3],[4],[5],[6],[7],[8],[9]),
  title: "Bingo",
  amount: 3,
  seed: 20,
  pages: 5,
) = {
  layout(size => {
  let si = (size.width * 0.9) / amount 
  let s = ()
  for i in range(amount) {
    s.push(si)
  }
  for i in range(pages) {
    let rng = gen-rng-f(seed+i)
    let (rng,items) = shuffle-f(rng, cards)
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
#bingo(cards:range(1,26).map(str),amount: 5)
