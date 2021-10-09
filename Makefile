init:
	pdm install
	npm install
	docker compose build

# Postgres runs on localhost:5432
# Flask    runs on localhost:5000
# React    runs on localhost:3000
start:
	screen -S docker-services -X stuff ^C; \
	screen -S react-dev-server -X stuff ^C; \
	screen -dmS docker-services docker-compose up; \
	screen -dmS react-dev-server npm run start; \
	pdm run start; \
	screen -S docker-services -X stuff ^C; \
	screen -S react-dev-server -X stuff ^C;
