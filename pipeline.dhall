let Concourse = ./deps/concourse.dhall

let eiriniRepo = ./resources/eirini.dhall

let ciResources = ./resources/eirini-ci.dhall

let eiriniRepo = ./resources/eirini.dhall

let dockerOpi =
      ./resources/docker/opi.dhall "((docker-username))" "((docker-password))"

let runUnitTestJob = ./jobs/run-unit-tests.dhall eiriniRepo

let createDockerImageJob =
      ./jobs/create-docker-image.dhall
        ciResources
        eiriniRepo
        dockerOpi
        runUnitTestJob.name

in  [ runUnitTestJob, createDockerImageJob ]
