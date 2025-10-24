{
  imports =
    # Development tools and editors
    [
      ./git
      ./neovim
      ./shell
      ./tmux
    ]

    # Programming languages and compilers
    ++ [
      ./go
      ./dotnet
      ./gcc
      ./lua
      ./nodejs
    ]

    # Build tools and utilities
    ++ [
      ./make
    ]

    # Terminal applications and tools
    ++ [
      ./ghostty
      ./lazygit
    ]

    # GUI applications - Development
    ++ [
      ./bruno
      ./postman
      ./claude
    ]

    # GUI applications - Browsers
    ++ [
      ./chrome
    ]

    # GUI applications - Media and Creative
    ++ [
      ./gimp
      ./vlc
    ]

    # GUI applications - Productivity
    ++ [
      ./obsidian
      ./todoist
      ./office
      ./slack
      ./discord
      ./telegram
    ]

    # Databases and storage
    ++ [
      ./mongodb
    ];
}
