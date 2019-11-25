let Concourse = ./deps/concourse.dhall

let eiriniRepo = ./resources/eirini.dhall

let job = ./jobs/run-unit-tests.dhall eiriniRepo
       

in  [ job ]
