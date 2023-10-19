FROM python:3.11-slim

LABEL maintainer="tb <tb@wodore.com>"
VOLUME /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PYTHONPATH=/app


COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt

RUN apt-get -y update; apt-get -y install curl

# copy files
COPY ./start.sh  ./gunicorn_conf.py ./start-reload.sh /

RUN addgroup --system user && adduser --system --group user
# user withou home
# RUN addgroup --gid 1001 --system app && \
#     adduser --no-create-home --shell /bin/false --disabled-password --uid 1001 --system --group app

RUN chmod +x /*.sh && \
    chown user:user /*.sh

USER user
WORKDIR /app/
EXPOSE 80

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Uvicorn
CMD ["/start.sh"]
