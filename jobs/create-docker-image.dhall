let Concourse = ../deps/concourse.dhall

let in_parallel = Concourse.helpers.inParallelStepSimple

let Prelude = ../deps/prelude.dhall

let triggerOnRepoChange =
        λ(repo : Concourse.Types.Resource)
      → λ(jobName : Text)
      → Concourse.helpers.getStep
          Concourse.schemas.GetStep::{
          , resource = repo
          , trigger = Some True
          , passed = Some [ jobName ]
          }

let putDocker =
        λ(resource : Concourse.Types.Resource)
      → λ(dockerfile : Text)
      → Concourse.helpers.putStep
          Concourse.schemas.PutStep::{
          , resource = resource
          , params =
              Some
                ( toMap
                    { build = Prelude.JSON.string "eirini"
                    , dockerfile =
                        Prelude.JSON.string
                          "eirini/docker/${dockerfile}/Dockerfile"
                    , build_args_file =
                        Prelude.JSON.string "docker-build-args/args.json"
                    }
                )
          }

let createGoDockerImages =
        λ(ciResources : Concourse.Types.Resource)
      → λ(eiriniRepo : Concourse.Types.Resource)
      → λ(dockerOpi : Concourse.Types.Resource)
      → λ(previousJobName : Text)
      → let makeDockerBuildArgs =
              ../tasks/make-docker-build-args.dhall ciResources eiriniRepo
        
        in  Concourse.schemas.Job::{
            , name = "create-go-docker-images"
            , plan =
                [ in_parallel
                    [ triggerOnRepoChange eiriniRepo previousJobName
                    , Concourse.helpers.getStep
                        Concourse.schemas.GetStep::{ resource = ciResources }
                    ]
                , makeDockerBuildArgs
                , putDocker dockerOpi "opi"
                ]
            }

in  createGoDockerImages
