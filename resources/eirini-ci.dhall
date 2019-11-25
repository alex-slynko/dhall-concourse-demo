let Concourse = ../deps/concourse.dhall
let Prelude = ../deps/prelude.dhall
in Concourse.defaults.Resource
        ⫽ { name = "eirini-ci"
          , type = Concourse.Types.ResourceType.InBuilt "git"
          , icon = Some "git"
          , source =
              Some
                ( toMap
                    { uri =
                        Prelude.JSON.string
                          "https://github.com/cloudfoundry-incubator/eirini-ci.git"
                    , branch = Prelude.JSON.string "master"
                    }
                )
          }
