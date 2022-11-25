# Just Report It Website

## Introduction ##

Just Report It (<https://justreport.it>) is an email plugin which makes it easy to report spam emails back to the domain registrar. This method ensures that spam domains are effetively being blocked at the registrar level and not just locally.

## Disclosure ##

This is the official repository for the Just Report It website (<https://justreport.it>).

## Building the app

> elm make src/Main.elm --optimize --output=elm.js

> uglifyjs elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output public/dist/app.min.js
