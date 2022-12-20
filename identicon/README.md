# Identicon

We're going to write a module that will generate an identical image.
The random image that `github` uses when we're not uploading
any avatar when creating new account. Something that is some
number of pixels across some number of pixels down and has some
color design.

An identical twin is formed of a `5x5` grid (`250px x 250px`).

Requirements:

- Each identical line should not be randomly generated. If I
  enter the same string twice, I should always get back the
  same identical

Flow of our app

- Input string
- Fetch into Identicon Generator
- Get output image
