#import "@preview/hydra:0.6.2": hydra
#import "@preview/codly:1.3.0": *
#import "@preview/theorion:0.6.0": *

#let default-names = toml("config/names.toml")
#let default-styles = toml("config/styles.toml")
#let default-info = toml("config/info.toml").global

#let ctext(
  label,
  size: .8em,
  font: default-styles.fonts.at("zh").math,
  ..options,
) = text(
  label,
  size: size,
  font: font,
  ..options,
)

#let tip = tip-block
#let note = note-block
#let quote = quote-block
#let warning = warning-block
#let caution = caution-block
