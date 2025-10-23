{
  imports =
    # Configuration profiles
    [
      ./profiles/base
      ./profiles/developer
      ./profiles/desktop
      ./profiles/work
    ]

    # Development tools and editors
    ++ [
      ./git
      ./neovim
      ./vscode
      ./cursor
      ./codex
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
      ./hugo
    ]

    # Terminal applications and tools
    ++ [
      ./kitty
      ./ghostty
      ./lazygit
      ./lazydocker
      ./warp
      ./brew
    ]

    # GUI applications - Development
    ++ [
      ./bruno
      ./dbeaver
      ./postman
      ./claude
    ]

    # GUI applications - Browsers
    ++ [
      ./firefox
      ./chrome
    ]

    # GUI applications - Media and Creative
    ++ [
      ./obs
      ./gimp
      ./audacity
      ./vlc
      ./unity
    ]

    # GUI applications - Productivity
    ++ [
      ./obsidian
      ./todoist
      ./office
      ./rectangle
      ./syncthing
      ./slack
      ./discord
      ./telegram
    ]

    # Databases and storage
    ++ [
      ./mongodb
      ./postgres
      ./sqlite
    ]

    # AI and specialized tools
    ++ [
      ./ollama
      ./antivirus
    ];
}
