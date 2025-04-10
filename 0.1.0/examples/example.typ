#import "@local/qooklet:0.1.0": *
#show: doc => conf(
  title: "Bellman Eqation",
  author: "ivaquero",
  header-cap: "Reinforcement Learning",
  footer-cap: "ivaquero",
  outline-on: false,
  doc,
)

= Bellman Eqation

#definition("Bellman Eqation")[

  ...

  $
    text(v_π (s), fill: #rgb("#ff0000"))
    &= 𝔼[R_(t+1)|S_t = s] + γ 𝔼[G_(t+1)|S_t = s], \
    &= ∑_(a ∈ 𝒜) π(a|s) ∑_(r ∈ ℛ) p(r|s,a) +
    γ ∑_(a ∈ 𝒜) π(a|s) ∑_(s^′ ∈ 𝒮) p(s^′|s,a) v_π (s^′) \
    &= ∑_(a ∈ 𝒜) π(a|s) [∑_(r ∈ ℛ) p(r|s,a) r +
      γ ∑_(s^′ ∈ 𝒮) p(s^′|s,a) text(v_π (s^′), fill: #rgb("#ff0000"))], ∀s ∈ 𝒮
  $ <bellman>
]

= Bellman Optimal Eqation

By Eq. @bellman,...

$
  v(s) &= max_(π(s) ∈ ∏(s)) ∑_(a ∈ 𝒜) π(a|s)(∑_(r ∈ ℛ) p(r|s, a) r + γ ∑_(s^′ ∈ 𝒮) p(s^′|s, a) v(s^′)), quad &∀s ∈ 𝒮 \
  &= max_(π(s) ∈ ∏(s)) ∑_(a ∈ 𝒜) π(a|s) q(s, a), quad &∀s ∈ 𝒮
$ <boe>

= Case: Shortest Path of Islands

#let csv1 = csv("islands.csv")
#figure(
  ktable(csv1, 9, inset: 0.31em),
  caption: "Geographic Info of Islands",
  supplement: "Table",
  kind: table,
)
