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
      username = "prometeo";
      email = "emilio.palmerini@gmail.com"; 
      fullName = "Prometeo";
      homeDirectory = "/home/prometeo";
    };
    
    hephaestus = {
      username = "emilio";
      email = "emilio.palmerini@codiceplastico.com";
      fullName = "Emilio Palmerini"; 
      homeDirectory = "/home/emilio";
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