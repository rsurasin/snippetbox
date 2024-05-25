# Snippetbox
## Description
I am following Alex Edward's "Let's Go!" Professional Edition (v2) book
in order to learn how to build a web app in Go.

### Dev Environment (flake.nix)
1. Enter root of project dir and run: `nix develop`
    - This will bring up a dev shell with Go 1.22.2, gopls, and MySQL
    (actually MariaDB).
2. In order to login to the database: `mysql -u root` or `mysql -D snippetbox -u web -p`
3. To spin down the database: `sudo mysqladmin shutdown --socket=$MYSQL_UNIX_PORT`
    - Where `$MYSQL_UNIX_PORT` is the `mysql.sock` created in the root of the
    project directory from the use of `nix develop` and removed when running
    **step 2**.

TODO: Need to create a shell script to populate the MySQL database
