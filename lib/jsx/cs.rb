module Jsx
  extend self

  module CS
    
    REG_NAME = {
      "indesign" => "InDesign",
      "illustrator" => "Illustrator",
      "photoshop" => "Photoshop"
    }

    VERSIONS = {
      "indesign" => {
        "5.0" => "CS3",
        "6.0" => "CS4",
        "7.0" => "CS5",
        "7.5" => "CS5.5",
        "8.0" => "CS6",
        "9.2" => "CC",
        "10"  => "CC 2014"
      },
      "illustrator" => {
        "13.0" => "CS3",
        "14.0" => "CS4",
        "15.0" => "CS5",
        "15.1" => "CS5.1",
        "16.0" => "CS6"
      },
      "photoshop" => {
        "10.0" => "CS3",
        "11.0" => "CS4",
        "12.0" => "CS5",
        "12.1" => "CS5.1",
        "13.0" => "CS6"
      }
    }

    DEFAULTS = {
      "indesign" => Jsx::CS::VERSIONS["indesign"]["7.0"],
      "illustrator" => Jsx::CS::VERSIONS["illustrator"]["15.0"],
      "photoshop" => Jsx::CS::VERSIONS["photoshop"]["12.0"]
    }
  end
end
