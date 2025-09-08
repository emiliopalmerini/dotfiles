let
  # User configurations per host
  users = {
    athena = {
      username = "emil_io";
      email = "emilio.palmerini@proton.me";
      fullName = "Emilio Palmerini";
      homeDirectory = "/home/emil_io";
    };
    
    hera = {
      username = "emil_io";
      email = "emilio.palmerini@proton.me"; 
      fullName = "Emilio Palmerini";
      homeDirectory = "/home/emil_io";
    };
    
    hephaestus = {
      username = "emil_io";
      email = "emilio.palmerini@proton.me";
      fullName = "Emilio Palmerini"; 
      homeDirectory = "/home/emil_io";
    };
    
    eris = {
      username = "emiliopalmerini";
      email = "emilio.palmerini@gmail.com";
      fullName = "Emilio Palmerini";
      homeDirectory = "/Users/emiliopalmerini";
    };
  };
in
{
  # Expose users
  inherit users;
  
  # Helper function to get user config for a host
  getUserConfig = hostname: users.${hostname};
}