let
  # User configurations per machine
  users = {
    thinkpad-home-server = {
      username = "prometeo";
      email = "emilio.palmerini@gmail.com";
      fullName = "Prometeo";
      homeDirectory = "/home/prometeo";
    };

    dell-xps-15 = {
      username = "emilio";
      email = "emilio.palmerini@codiceplastico.com";
      fullName = "Emilio Palmerini";
      homeDirectory = "/home/emilio";
    };

    macbook-air-m1 = {
      username = "emiliopalmerini";
      email = "emilio.palmerini@gmail.com";
      fullName = "Emilio Palmerini";
      homeDirectory = "/Users/emiliopalmerini";
    };

    # VM configurations
    vm-aarch64 = {
      username = "emilio";
      email = "emilio.palmerini@gmail.com";
      fullName = "Emilio Palmerini";
      homeDirectory = "/home/emilio";
    };

    wsl = {
      username = "emilio";
      email = "emilio.palmerini@gmail.com";
      fullName = "Emilio Palmerini";
      homeDirectory = "/home/emilio";
    };
  };
in
{
  # Expose users
  inherit users;

  # Helper function to get user config for a machine
  getUserConfig = machineName: users.${machineName};
}