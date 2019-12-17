# Database Worker

How to run in production

```
MIX_ENV="prod" \
RABBITMQ_HOST="0.0.0.0" \
RABBITMQ_USER="rabbitmq_username" \
RABBITMQ_PASS="rabbitmq_password" \
RABBITMQ_VHOST="301remover" \
DATABASE_PATH="./301remover-db" \
mix run --no-halt
```
