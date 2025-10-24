#!/bin/bash

set -e
CONTAINER_NAME="exercise_6"
DB_NAME="testdb"
COMPOSE_FILE="6-compose.yml"
INIT_SQL_FILE="6-init.sql"

cat <<EOF > $INIT_SQL_FILE
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL
);
EOF

cat <<EOF > $COMPOSE_FILE
version: '3.9'

services:
  postgres:
    image: postgres:18-alpine
    container_name: $CONTAINER_NAME
    restart: always
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: cestsecretchuuut
      POSTGRES_DB: $DB_NAME
    ports:
      - "5432:5432"
    volumes:
      - exercise6_data:/var/lib/postgresql/data
      - ./$INIT_SQL_FILE:/docker-entrypoint-initdb.d/$INIT_SQL_FILE

volumes:
  exercise6_data:
    driver: local
EOF

docker compose -f $COMPOSE_FILE up -d

sleep 5

docker exec -it $CONTAINER_NAME psql -U postgres -d $DB_NAME -c "\dt"

if [ $? -eq 0 ]; then
    echo "Tables created successfully in database '$DB_NAME'."
else
    echo "Failed to create tables in database '$DB_NAME'."
    exit 1
fi

echo "Clean : docker compose -f $COMPOSE_FILE down -v"