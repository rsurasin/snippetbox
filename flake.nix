{
  description = "A Go 1.22 development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Use flake-utils to simplify flake setup across multiple systems
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Import the nixpkgs with overlay and configuration
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };
        in {
          # Define a development shell
          devShell = pkgs.mkShell {
            buildInputs = [
              pkgs.go_1_22
              pkgs.gopls
              pkgs.mysql
            ];

            # Optional: Set GOPATH and other env variables
            shellHook = ''
              # Directory for MySQL data
              if [ ! -d "$PWD/mysql-data" ]; then
                echo "Initializing MySQL data directory..."
                mysql_install_db --datadir=$PWD/mysql-data --auth-root-authentication-method=normal
              fi

              # Check if MySQL Server is already running
              if ! mysqladmin ping --socket=$PWD/mysql.sock --silent; then
                echo "Starting MySQL server..."
                mysqld --datadir=$PWD/mysql-data --socket=$PWD/mysql.sock --pid-file=$PWD/mysql.pid &
                export MYSQL_UNIX_PORT=$PWD/mysql.sock

                echo "Waiting for MySQL server to start..."
                while ! mysqladmin ping --socket=$MYSQL_UNIX_PORT --silent; do
                  sleep 1
                done
                echo "MySQL server started."
              else
                echo "MySQL server is already running."
                export MYSQL_UNIX_PORT=$PWD/mysql.sock
              fi
            '';
          };
        }
    );
}
