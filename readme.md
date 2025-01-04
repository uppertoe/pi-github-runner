# Self-Hosted Github Runner
A Dockerised Github Actions runner

# Environment Variables
`GH_RUNNER_REPO`: The repository for the runner to take workflows from
- In the format username/repository

`GH_RUNNER_CONFIG_TOKEN`: The token provided by Github for the runner
- See [Github](https://github.com/) repo -> settings -> actions

# Use in workflows
Use this YAML in your workflow file for each job
```
runs-on: self-hosted
```