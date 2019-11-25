let Concourse = ./deps/concourse.dhall
let Prelude = ./deps/prelude.dhall

let eiriniRepo
    =     Concourse.defaults.Resource
        ⫽ { name = "eirini"
          , type = Concourse.Types.ResourceType.InBuilt "git"
          , icon = Some "git"
          , source =
              Some
                ( toMap
                    { uri =
                        Prelude.JSON.string
                          "https://github.com/cloudfoundry-incubator/eirini.git"
                    , branch = Prelude.JSON.string "master"
                    }
                )
          }
let triggerOnEirini =
    Concourse.helpers.getStep
        Concourse.schemas.GetStep::{ resource = eiriniRepo, trigger = Some True }

let ciImage =
      Some
        Concourse.schemas.ImageResource::{
        , type = "docker-image"
        , source = Some (toMap { repository = Prelude.JSON.string "eirini/ci" })
        }

let runUnitTestsTask =
      Concourse.helpers.taskStep
              Concourse.schemas.TaskStep::{
              , task = "run-unit-tests"
              , config =
                  Concourse.Types.TaskSpec.Config
                    Concourse.schemas.TaskConfig::{
                    , image_resource = ciImage
                    , inputs =
                        Some
                          [ { name = eiriniRepo.name
                            , path = None Text
                            , optional = None Bool
                            }
                          ]
                    , run =
                        Concourse.schemas.TaskRunConfig::{
                        , path = "${eiriniRepo.name}/scripts/run_unit_tests.sh"                       
                        }
                    }
              }
let job = Concourse.defaults.Job
            ⫽ { name = "run-tests"
              , public = Some True
              , plan =
                  [ triggerOnEirini,                      
                  runUnitTestsTask
                  ]
              }

in  [ job ]
