let Concourse = ./deps/concourse.dhall

let eiriniRepo = ./resources/eirini.dhall

let ciResources = ./resources/eirini-ci.dhall

let eiriniStagingRepo = ./resources/eirini-staging.dhall

let eiriniRepo = ./resources/eirini.dhall

let dockerOpi =
      ./resources/docker/opi.dhall "((docker-username))" "((docker-password))"

let runEiriniUnitTestJob = ./jobs/run-unit-tests.dhall eiriniRepo

let runEiriniStagingTestJob = ./jobs/run-unit-tests.dhall eiriniStagingRepo

let createDockerImageJob =
      ./jobs/create-docker-image.dhall
        ciResources
        eiriniRepo
        dockerOpi
        runEiriniUnitTestJob.name

in  [ runEiriniUnitTestJob, runEiriniStagingTestJob, createDockerImageJob ]
