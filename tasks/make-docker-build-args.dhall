let Concourse = ../deps/concourse.dhall

let taskFile =
        λ(ciResources : Concourse.Types.Resource)
      → λ(taskName : Text)
      → Concourse.Types.TaskSpec.File
          "${ciResources.name}/tasks/${taskName}/task.yml"

in    λ(ciResources : Concourse.Types.Resource)
    → λ(repository : Concourse.Types.Resource)
    → Concourse.helpers.taskStep
        Concourse.schemas.TaskStep::{
        , task = "make-docker-build-args"
        , config = taskFile ciResources "make-docker-build-args"
        , input_mapping = Some (toMap { repository = repository.name })
        }
