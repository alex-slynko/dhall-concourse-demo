let Concourse = ../deps/concourse.dhall

let runUnitTestsJob =
        λ(repo : Concourse.Types.Resource)
      → let triggerOnRepoChange =
              Concourse.helpers.getStep
                Concourse.schemas.GetStep::{
                , resource = repo
                , trigger = Some True
                }
        
        let runUnitTestsTask = ../tasks/unit-tests.dhall repo
        
        in    Concourse.defaults.Job
            ⫽ { name = "run-tests-${repo.name}"
              , public = Some True
              , plan = [ triggerOnRepoChange, runUnitTestsTask ]
              }

in  runUnitTestsJob
