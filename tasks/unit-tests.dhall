let Concourse = ../deps/concourse.dhall

let Prelude = ../deps/prelude.dhall

let ciImage =
      Some
        Concourse.schemas.ImageResource::{
        , type = "docker-image"
        , source = Some (toMap { repository = Prelude.JSON.string "eirini/ci" })
        }

in    λ(repo : Concourse.Types.Resource)
    → Concourse.helpers.taskStep
        Concourse.schemas.TaskStep::{
        , task = "run-unit-tests"
        , config =
            Concourse.Types.TaskSpec.Config
              Concourse.schemas.TaskConfig::{
              , image_resource = ciImage
              , inputs =
                  Some
                    [ { name = repo.name
                      , path = None Text
                      , optional = None Bool
                      }
                    ]
              , run =
                  Concourse.schemas.TaskRunConfig::{
                  , path = "${repo.name}/scripts/run_unit_tests.sh"
                  }
              }
        }
