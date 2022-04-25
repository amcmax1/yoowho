docker-compose run --no-deps web rails new . --force --database=postgresql --api

docker-compose run backend rake db:create db:migrate
docker-compose run backend bash
docker-compose up
docker-compose run web rake db:create