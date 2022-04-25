

### Initial Docker Compose Setup
```
docker-compose run --no-deps web rails new . --force --database=postgresql --api
docker-compose build
docker-compose up
docker-compose run web rake db:create
docker-compose down


docker-compose up --build
docker-compose run web bundle install
docker-compose up --build

```


### Useful docker commands
```
docker ps -a
docker exec -it e6eb2e12145f bash
docker system prune
docker-compose down --volumes
```

### Git Semantics Key
- build: Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- ci: Changes to our CI configuration files and scripts (examples: CircleCi, SauceLabs)
- docs: Documentation only changes
- feat: A new feature
- fix: A bug fix
- perf: A code change that improves performance
- refactor: A code change that neither fixes a bug nor adds a feature
- test: Adding missing tests or correcting existing tests