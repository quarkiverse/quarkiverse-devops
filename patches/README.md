# Scripts to patch the Quarkiverse repositories

The script performs these actions

1) Clone each Quarkiverse repository
2) Create a branch
3) Run the jbang script
4) Commit the changes
5) Creates a pull-request by pushing a branch to the repository (the GitHub user must have write access to the repository)

## Installation 

It requires the following tools to be installed and configured:

- gh CLI tool (https://cli.github.com/manual/)
- jq (https://stedolan.github.io/jq/)
- JBang (https://www.jbang.dev/)

## Usage

```bash
./patch.sh -b {1} -t {2} -m {3} -j {4}
```

Where the parameters are:

- `-b` - The branch to create the PR from
- `-t` - The PR title
- `-m`  - The PR body
- `-j` - The JBang script to run

Example:

```bash
./patch.sh -b add_scm -t "Include \`scm\` info" -m "This includes the \`scm\` tag in the project parent" -j $(pwd)/AddScm.java
```

A `pull-requests.txt` will be created with the list of pull-requests created in this process.
